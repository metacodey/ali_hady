const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');

class SocketManager {
  constructor() {
    this.io = null;
    this.connectedUsers = new Map(); // Map<userId, {socketId, userType, conversationId}>
    this.conversationRooms = new Map(); // Map<conversationId, Set<socketId>>
  }

  init(server) {
    this.io = new Server(server, {
      cors: {
        origin: process.env.CORS_ORIGIN || "*",
        methods: ["GET", "POST"]
      }
    });

    this.io.use(this.authenticateSocket.bind(this));
    this.io.on('connection', this.handleConnection.bind(this));

    console.log('🔌 Socket.IO server initialized');
  }

  // التحقق من صحة المصادقة للـ Socket
  async authenticateSocket(socket, next) {
    try {
      const token = socket.handshake.auth.token;
      if (!token) {
        return next(new Error('Authentication error: No token provided'));
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      socket.userId = decoded.userId;
      
      socket.userType = decoded.userType || 'customer'; // customer or admin
      
      next();
    } catch (error) {
      next(new Error('Authentication error: Invalid token'));
    }
  }

  // معالجة الاتصال الجديد
  handleConnection(socket) {
    console.log(`👤 User connected: ${socket.userId} (${socket.userType})`);
    // تسجيل المستخدم المتصل
    this.connectedUsers.set(socket.userId, {
      socketId: socket.id,
      userType: socket.userType,
      userId: socket.userId,
      conversationId: null
    });

    // الانضمام إلى غرفة المستخدم الشخصية
    socket.join(`user_${socket.userId}`);

    // معالجة الأحداث
    socket.on('join_conversation', this.handleJoinConversation.bind(this, socket));
    socket.on('leave_conversation', this.handleLeaveConversation.bind(this, socket));
    socket.on('send_message', this.handleSendMessage.bind(this, socket));
    socket.on('mark_message_read', this.handleReadMessage.bind(this, socket));
    socket.on('new_conversation_created', this.handleNewConversationCreated.bind(this, socket));
    socket.on('update_conversation_status', this.handleUpdateConversationStatus.bind(this, socket));
    socket.on('disconnect', this.handleDisconnect.bind(this, socket));
  }
  
  // معالجة إنشاء محادثة جديدة
  async handleNewConversationCreated(socket, data) {
    try {
      const { conversation, created_by,customer_id } = data;
      console.log('📝 New conversation created:', conversation);
      
      // إشعار جميع المدراء المتصلين
      this.notifyAdmins('new_conversation', {
        conversation: conversation,
        created_by: created_by,
        timestamp: new Date().toISOString()
      });
      
      if(created_by==='user'){  
         conversation.status='open';
        this.notifyUser('new_conversation',customer_id,{
          conversation: conversation,
          created_by: created_by,
          timestamp: new Date().toISOString(),
          status:'open'
        });
      }
      
      // تأكيد الإنشاء للعميل
      socket.emit('conversation_created_success', {
        success: true,
        conversation: conversation
      });
      
      console.log(`✅ New conversation notification sent to admins`);
    } catch (error) {
      console.error('❌ Error in handleNewConversationCreated:', error);
      socket.emit('error', { message: 'خطأ في إنشاء المحادثة' });
    }
  }
  
  // معالجة تحديث حالة المحادثة
  async handleUpdateConversationStatus(socket, data) {
    try {
      const { conversation_id, status, updated_by } = data;
      console.log('🔄 Conversation status update:', data);
      
      // إشعار جميع المستخدمين المهتمين بالمحادثة
      this.io.emit('conversation_status_changed', {
        conversation_id: conversation_id,
        status: status,
        updated_by: updated_by,
        timestamp: new Date().toISOString()
      });
      
      // تأكيد التحديث
      socket.emit('conversation_status_updated', {
        success: true,
        conversation_id: conversation_id,
        status: status
      });
      
      console.log(`✅ Conversation status update sent for ${conversation_id}`);
    } catch (error) {
      console.error('❌ Error in handleUpdateConversationStatus:', error);
      socket.emit('error', { message: 'خطأ في تحديث حالة المحادثة' });
    }
  }

  // الانضمام إلى محادثة
  async handleJoinConversation(socket, data) {
    try {
      const { conversationId } = data;
      
      // مغادرة المحادثة السابقة إن وجدت
      if (this.connectedUsers.get(socket.userId)?.conversationId) {
        await this.handleLeaveConversation(socket, {
          conversationId: this.connectedUsers.get(socket.userId).conversationId
        });
      }

      // الانضمام إلى غرفة المحادثة
      socket.join(`conversation_${conversationId}`);
      
      // تحديث بيانات المستخدم المتصل
      const userData = this.connectedUsers.get(socket.userId);
      userData.conversationId = conversationId;
      this.connectedUsers.set(socket.userId, userData);

      // إضافة المستخدم إلى غرفة المحادثة
      if (!this.conversationRooms.has(conversationId)) {
        this.conversationRooms.set(conversationId, new Set());
      }
      this.conversationRooms.get(conversationId).add(socket.id);

      // إشعار المشاركين الآخرين بالانضمام
      socket.to(`conversation_${conversationId}`).emit('user_joined', {
        userId: socket.userId,
        userType: socket.userType
      });

      socket.emit('conversation_joined', { conversationId });
      console.log(`📝 User ${socket.userId} joined conversation ${conversationId}`);
    } catch (error) {
      console.error('Error joining conversation:', error);
      socket.emit('error', { message: 'خطأ في الانضمام إلى المحادثة' });
    }
  }

  // مغادرة المحادثة
  async handleLeaveConversation(socket, data) {
    try {
      const { conversationId } = data;
      
      socket.leave(`conversation_${conversationId}`);
      
      // إزالة المستخدم من غرفة المحادثة
      if (this.conversationRooms.has(conversationId)) {
        this.conversationRooms.get(conversationId).delete(socket.id);
        if (this.conversationRooms.get(conversationId).size === 0) {
          this.conversationRooms.delete(conversationId);
        }
      }

      // تحديث بيانات المستخدم
      const userData = this.connectedUsers.get(socket.userId);
      if (userData) {
        userData.conversationId = null;
        this.connectedUsers.set(socket.userId, userData);
      }

      // إشعار المشاركين الآخرين بالمغادرة
      socket.to(`conversation_${conversationId}`).emit('user_left', {
        userId: socket.userId,
        userType: socket.userType
      });

      socket.emit('conversation_left', { conversationId });
      console.log(`📤 User ${socket.userId} left conversation ${conversationId}`);
    } catch (error) {
      console.error('Error leaving conversation:', error);
    }
  }

  // معالجة إرسال الرسائل
  async handleSendMessage(socket, data) {
    try {
      const { conversation_id, reciver_id } = data;
      // البحث عن المستقبل في المستخدمين المتصلين
      const receiverData = this.connectedUsers.get(reciver_id);
      if (receiverData) {
        // إرسال الرسالة للمستقبل المتصل مباشرة
        this.io.to(receiverData.socketId).emit('new_message', {
          conversation_id: conversation_id,
          message: data
        });
        console.log(`✅ Message sent to receiver ${reciver_id}`);
      } else {
        console.log(`⚠️ Receiver ${reciver_id} is not connected`);
      }
      // تأكيد الإرسال للمرسل
      socket.emit('message_sent', {
        success: true,
        message: data
      });
      
    } catch (error) {
      console.error('❌ Error in handleSendMessage:', error);
      socket.emit('error', { message: 'خطأ في إرسال الرسالة' });
    }
  }

  async handleReadMessage(socket, data) {
    try {
      const { id, conversation_id, reciver_id, reader_id, reader_type } = data;
      console.log('📖 Processing read notification:', data);
      
      // البحث عن المستقبل (المرسل الأصلي) في المستخدمين المتصلين
      const receiverData = this.connectedUsers.get(reciver_id);
      if (receiverData) {
        // إرسال إشعار القراءة للمستقبل المتصل مباشرة
        this.io.to(receiverData.socketId).emit('message_read_notification', {
          message_id: id,
          conversation_id: conversation_id,
          read_by: reader_id,
          reader_type: reader_type,
          read_at: new Date().toISOString()
        });
        console.log(`✅ Read notification sent to receiver ${reciver_id}`);
      } else {
        console.log(`⚠️ Receiver ${reciver_id} is not connected`);
      }
      
      // تأكيد نجاح العملية للمرسل (المشرف)
      socket.emit('message_read_success', {
        success: true,
        message_id: id,
        conversation_id: conversation_id
      });
      
    } catch (error) {
      console.error('❌ Error in handleReadMessage:', error);
      socket.emit('error', { message: 'خطأ في معالجة إشعار القراءة' });
    }
  }

  // قطع الاتصال
  handleDisconnect(socket) {
    console.log(`👋 User disconnected: ${socket.userId}`);
    
    // إزالة المستخدم من القوائم
    const userData = this.connectedUsers.get(socket.userId);
    if (userData?.conversationId) {
      // إشعار المشاركين في المحادثة بالمغادرة
      socket.to(`conversation_${userData.conversationId}`).emit('user_left', {
        userId: socket.userId,
        userType: socket.userType
      });
      
      // إزالة من غرفة المحادثة
      if (this.conversationRooms.has(userData.conversationId)) {
        this.conversationRooms.get(userData.conversationId).delete(socket.id);
        if (this.conversationRooms.get(userData.conversationId).size === 0) {
          this.conversationRooms.delete(userData.conversationId);
        }
      }
    }
    
    this.connectedUsers.delete(socket.userId);
  }

  // إشعار برسالة جديدة (يتم استدعاؤها من API)
  notifyNewMessage(conversationId, messageData) {
    this.io.to(`conversation_${conversationId}`).emit('new_message', {
      conversationId,
      message: messageData
    });
    console.log(`💬 Message notification sent to conversation ${conversationId}`);
  }

  // إشعار بتحديث حالة قراءة الرسالة (يتم استدعاؤها من API)
  notifyMessageRead(conversationId, messageId, readBy) {
    this.io.to(`conversation_${conversationId}`).emit('message_read', {
      messageId,
      readBy
    });
    console.log(`👁️ Message read notification sent for message ${messageId}`);
  }

  // إشعار بتحديث المحادثة (يتم استدعاؤها من API)
  notifyConversationUpdate(conversationId, updateData) {
    this.io.to(`conversation_${conversationId}`).emit('conversation_updated', {
      conversationId,
      ...updateData
    });
    console.log(`🔄 Conversation update notification sent for ${conversationId}`);
  }

  // إشعار المشرفين - تم إصلاح الخطأ هنا
  notifyAdmins(event, data) {
    // إرسال إشعار لجميع المشرفين المتصلين
    for (const [userId, userData] of this.connectedUsers) {
      if (userData.userType === 'admin') { // تصحيح: admin بدلاً من user
        this.io.to(userData.socketId).emit(event, data);
      }
    }
  }

  // إرسال إشعار لمستخدم محدد
  notifyUser(event,userId, data) {
    const userData = this.connectedUsers.get(userId);
    if (userData) {
      this.io.to(userData.socketId).emit(event, data);
    }
  }

  // الحصول على المستخدمين المتصلين في محادثة
  getConnectedUsersInConversation(conversationId) {
    const users = [];
    for (const [userId, userData] of this.connectedUsers) {
      if (userData.conversationId === conversationId) {
        users.push({
          userId,
          userType: userData.userType
        });
      }
    }
    return users;
  }
}

module.exports = new SocketManager();
