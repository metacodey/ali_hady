const express = require('express');
const router = express.Router();
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, conversationSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType, verifyCustomer } = require('../middleware/auth');

// GET /api/conversations - عرض المحادثات (للمشرفين)
router.get('/',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          conv.id, conv.subject, conv.status, conv.created_at, conv.updated_at,
          c.full_name as customer_name, c.email as customer_email,
          u.full_name as assigned_user,
          (
            SELECT COUNT(*) FROM messages m 
            WHERE m.conversation_id = conv.id AND m.is_read = 0 AND m.sender_type = 'customer'
          ) as unread_messages,
          (
            SELECT m.message FROM messages m 
            WHERE m.conversation_id = conv.id 
            ORDER BY m.created_at DESC LIMIT 1
          ) as last_message
        FROM conversations conv
        JOIN customers c ON conv.customer_id = c.id
        LEFT JOIN users u ON conv.user_id = u.id
      `;
      
      let countQuery = `
        SELECT COUNT(*) as total 
        FROM conversations conv
        JOIN customers c ON conv.customer_id = c.id
      `;
      
      let params = [];
      
      if (search) {
        const searchCondition = ' WHERE (conv.subject LIKE ? OR c.full_name LIKE ? OR c.email LIKE ?)';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam, searchParam];
      }
      
      baseQuery += ' ORDER BY conv.updated_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد المحادثات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد المحادثات بنجاح',
        data: result.data,
        pagination: result.pagination
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// GET /api/conversations/my - محادثات العميل المسجل دخوله
router.get('/my',
  verifyToken,
  checkUserType(['customer']),
  verifyCustomer,
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit } = req.validatedQuery;
      const customerId = req.user.userId;
      
      const baseQuery = `
        SELECT 
          conv.id, conv.subject, conv.status,conv.user_id, conv.created_at, conv.updated_at,
          u.full_name as assigned_user,
          (
            SELECT COUNT(*) FROM messages m 
            WHERE m.conversation_id = conv.id AND m.is_read = 0 AND m.sender_type = 'user'
          ) as unread_messages,
          (
            SELECT m.message FROM messages m 
            WHERE m.conversation_id = conv.id 
            ORDER BY m.created_at DESC LIMIT 1
          ) as last_message
        FROM conversations conv
        LEFT JOIN users u ON conv.user_id = u.id
        WHERE conv.customer_id = ?
      `;
      
      const countQuery = 'SELECT COUNT(*) as total FROM conversations WHERE customer_id = ?';
      
      const result = await getPaginatedData(
        baseQuery + ' ORDER BY conv.id DESC',
        countQuery,
        [customerId],
        page,
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد محادثاتك'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد محادثاتك بنجاح',
        data: result.data,
        pagination: result.pagination
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// GET /api/conversations/:id - عرض محادثة واحدة
router.get('/:id',
  verifyToken,
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { userType, userId } = req.user;
      
      // استعلام تفاصيل المحادثة
      let conversationQuery = `
        SELECT 
          conv.id, conv.subject, conv.status, conv.created_at, conv.updated_at,
          c.full_name as customer_name, c.email as customer_email,
          u.full_name as assigned_user
        FROM conversations conv
        JOIN customers c ON conv.customer_id = c.id
        LEFT JOIN users u ON conv.user_id = u.id
        WHERE conv.id = ?
      `;
      
      // إذا كان عميل، تأكد من أنه يطلب محادثته فقط
      if (userType === 'customer') {
        conversationQuery += ' AND conv.customer_id = ?';
      }
      
      const conversationParams = userType === 'customer' ? [id, userId] : [id];
      const conversationResult = await executeQuery(conversationQuery, conversationParams);
      
      if (!conversationResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد المحادثة'
        });
      }
      
      if (conversationResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد المحادثة بنجاح',
        data: conversationResult.data[0]
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// GET /api/conversations/customer/:customerId - عرض جميع محادثات عميل معين (للمشرفين فقط)
router.get('/customer/:customerId',
  verifyToken,
  checkUserType(['user']),
   validateParams(conversationSchemas.customerParams),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { customerId } = req.validatedParams;
      const { page, limit } = req.validatedQuery;
      
      // التحقق من وجود العميل
      const customerCheckQuery = 'SELECT id, full_name FROM customers WHERE id = ?';
      const customerCheckResult = await executeQuery(customerCheckQuery, [customerId]);
      
      if (!customerCheckResult.success || customerCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'العميل غير موجود'
        });
      }
      
      // استعلام محادثات العميل مع معلومات إضافية
      const baseQuery = `
        SELECT 
          conv.id, conv.subject, conv.status, conv.created_at, conv.updated_at,
          c.full_name as customer_name, c.email as customer_email,
          u.full_name as assigned_user,
          COUNT(m.id) as total_messages,
          COUNT(CASE WHEN m.sender_type = 'customer' AND m.is_read = 0 THEN 1 END) as unread_from_customer,
          MAX(m.created_at) as last_message_date,
          (SELECT message FROM messages WHERE conversation_id = conv.id ORDER BY created_at DESC LIMIT 1) as last_message
        FROM conversations conv
        JOIN customers c ON conv.customer_id = c.id
        LEFT JOIN users u ON conv.user_id = u.id
        LEFT JOIN messages m ON conv.id = m.conversation_id
        WHERE conv.customer_id = ?
        GROUP BY conv.id
      `;
      
      const countQuery = 'SELECT COUNT(*) as total FROM conversations WHERE customer_id = ?';
      
      const result = await getPaginatedData(
        baseQuery + ' ORDER BY conv.updated_at DESC',
        countQuery,
        [customerId],
        page,
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد محادثات العميل'
        });
      }
      
      // تنسيق البيانات
      const formattedData = result.data.map(conversation => ({
        ...conversation,
        total_messages: parseInt(conversation.total_messages),
        unread_from_customer: parseInt(conversation.unread_from_customer),
        needs_attention: conversation.unread_from_customer > 0,
        is_active: conversation.status === 'open'
      }));
      
      res.json({
        success: true,
        message: 'تم استرداد محادثات العميل بنجاح',
        data: formattedData,
        pagination: result.pagination,
        customer: customerCheckResult.data[0]
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// POST /api/conversations - إنشاء محادثة جديدة (للعملاء)
router.post('/',
  verifyToken,
  checkUserType(['customer']),
  verifyCustomer,
  validate(conversationSchemas.create),
  async (req, res) => {
    try {
      const { subject } = req.validatedData;
      const customerId = req.user.userId;
      
      // إنشاء المحادثة الجديدة
      const insertQuery = `
        INSERT INTO conversations (customer_id, subject)
        VALUES (?, ?)
      `;
      
      const insertParams = [customerId, subject || 'محادثة جديدة'];
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء المحادثة'
        });
      }
      
      const conversationId = insertResult.data.insertId;
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء المحادثة بنجاح',
        data: {
          id: conversationId,
          subject: subject || 'محادثة جديدة'
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);


// POST /api/conversations - إنشاء محادثة جديدة (للعملاء)
router.post('/by_admin',
  verifyToken,
  checkUserType(['user']),
  validate(conversationSchemas.createByAdmin),
  async (req, res) => {
    try {
      const { subject,customerId } = req.validatedData;
      // إنشاء المحادثة الجديدة
      const insertQuery = `
        INSERT INTO conversations (customer_id, subject,status)
        VALUES (?, ?,'open')
      `;
      
      const insertParams = [customerId, subject || 'محادثة جديدة'];
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء المحادثة'
        });
      }
      
      const conversationId = insertResult.data.insertId;
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء المحادثة بنجاح',
        data: {
          id: conversationId,
          subject: subject || 'محادثة جديدة'
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);


// PUT /api/conversations/:id/assign - تخصيص محادثة لمستخدم
router.put('/:id/assign',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  validate(require('joi').object({
    user_id: require('joi').number().integer().positive().optional().allow(null)
  })),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { user_id } = req.validatedData;
      
      // التحقق من وجود المحادثة
      const checkQuery = 'SELECT id, subject FROM conversations WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة'
        });
      }
      
      // التحقق من وجود المستخدم إذا تم تقديم معرف
      if (user_id) {
        const userCheckQuery = 'SELECT id, full_name FROM users WHERE id = ? AND is_active = 1';
        const userCheckResult = await executeQuery(userCheckQuery, [user_id]);
        
        if (!userCheckResult.success || userCheckResult.data.length === 0) {
          return res.status(400).json({
            success: false,
            message: 'المستخدم غير موجود أو غير مفعل'
          });
        }
      }
      
      // تحديث تخصيص المحادثة
      const updateQuery = 'UPDATE conversations SET user_id = ?, updated_at = NOW() WHERE id = ?';
      const updateResult = await executeQuery(updateQuery, [user_id || null, id]);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث تخصيص المحادثة'
        });
      }
      
      const message = user_id ? 'تم تخصيص المحادثة بنجاح' : 'تم إلغاء تخصيص المحادثة';
      
      res.json({
        success: true,
        message
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// PUT /api/conversations/:id/status - تحديث حالة المحادثة
// PUT /api/conversations/:id/status - تحديث حالة المحادثة
router.put('/:id/status',
  verifyToken,
  checkUserType(['user','customer']),
  validateParams(commonSchemas.id),
  validate(require('joi').object({
    status: require('joi').string().valid('open', 'closed', 'pending').required()
  })),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { status } = req.validatedData;
      const { userType, userId } = req.user;
      
      // التحقق من وجود المحادثة
      const checkQuery = 'SELECT id, subject, status, user_id FROM conversations WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة'
        });
      }

      const conversation = checkResult.data[0];
      
      // تحديث حالة المحادثة
      let updateQuery = 'UPDATE conversations SET status = ?, updated_at = NOW()';
      let updateParams = [status];
      
      // إذا كان المشرف يقوم بقبول المحادثة (من pending إلى open)
      if (status === 'open' && userType === 'user' && conversation.status === 'pending') {
        updateQuery += ', user_id = ?';
        updateParams.push(userId);
      }
      
      if (status === 'closed') {
        updateQuery += ', closed_at = NOW()';
      }
      
      updateQuery += ' WHERE id = ?';
      updateParams.push(id);
      
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث حالة المحادثة'
        });
      }
      
      let statusText;
      let message;
      
      switch(status) {
        case 'open':
          statusText = 'مفتوحة';
          if (conversation.status === 'pending' && userType === 'user') {
            message = 'تم قبول المحادثة وإسنادها إليك';
          } else {
            message = `تم تحديث حالة المحادثة إلى ${statusText}`;
          }
          break;
        case 'closed':
          statusText = 'مغلقة';
          message = `تم تحديث حالة المحادثة إلى ${statusText}`;
          break;
        case 'pending':
          statusText = 'معلقة';
          message = `تم تحديث حالة المحادثة إلى ${statusText}`;
          break;
        default:
          message = 'تم تحديث حالة المحادثة';
      }
      
      res.json({
        success: true,
        message: message,
        data: {
          conversation_id: id,
          old_status: conversation.status,
          new_status: status,
          assigned_user: status === 'open' && userType === 'user' && conversation.status === 'pending' ? userId : conversation.user_id
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);
// DELETE /api/conversations/:id - حذف محادثة
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      // التحقق من وجود المحادثة
      const checkQuery = 'SELECT id, subject FROM conversations WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة'
        });
      }
      
      // حذف المحادثة (سيتم حذف الرسائل تلقائياً بسبب CASCADE)
      const deleteQuery = 'DELETE FROM conversations WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف المحادثة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم حذف المحادثة بنجاح'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// GET /api/conversations/stats - إحصائيات المحادثات
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_conversations,
          COUNT(CASE WHEN status = 'open' THEN 1 END) as open_conversations,
          COUNT(CASE WHEN status = 'closed' THEN 1 END) as closed_conversations,
          COUNT(CASE WHEN DATE(created_at) = CURDATE() THEN 1 END) as today_conversations,
          COUNT(CASE WHEN user_id IS NULL THEN 1 END) as unassigned_conversations,
          (
            SELECT COUNT(*) FROM messages m 
            JOIN conversations c ON m.conversation_id = c.id 
            WHERE m.is_read = 0 AND m.sender_type = 'customer'
          ) as total_unread_messages
        FROM conversations
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات المحادثات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد الإحصائيات بنجاح',
        data: result.data[0]
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

module.exports = router;