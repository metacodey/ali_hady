const express = require('express');
const router = express.Router();
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, messageSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType, verifyCustomer } = require('../middleware/auth');

// GET /api/messages/conversation/:conversationId - رسائل محادثة معينة
router.get('/conversation/:conversationId',
  verifyToken,
  validateParams(messageSchemas.conversationParams),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { conversationId } = req.validatedParams;
      const { page, limit } = req.validatedQuery;
      const { userType, userId } = req.user;
      
      // التحقق من وجود المحادثة والصلاحية
      let conversationCheckQuery = `
        SELECT conv.id, conv.customer_id, c.full_name as customer_name
        FROM conversations conv
        JOIN customers c ON conv.customer_id = c.id
        WHERE conv.id = ?
      `;
      
      let conversationCheckParams = [conversationId];
      
      // إذا كان عميل، تأكد من أنه يطلب رسائل محادثته فقط
      if (userType === 'customer') {
        conversationCheckQuery += ' AND conv.customer_id = ?';
        conversationCheckParams.push(userId);
      }
      
      const conversationCheckResult = await executeQuery(conversationCheckQuery, conversationCheckParams);
      
      if (!conversationCheckResult.success || conversationCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة'
        });
      }
      
     // استرداد رسائل المحادثة
        const baseQuery = `
          SELECT 
            m.id, m.message, m.sender_type, m.sender_id, m.is_read, m.created_at,
            CASE 
              WHEN m.sender_type = 'customer' THEN c.full_name
              WHEN m.sender_type = 'user' THEN u.full_name
              ELSE 'غير معروف'
            END as sender_name
          FROM messages m
          LEFT JOIN customers c ON m.sender_type = 'customer' AND m.sender_id = c.id
          LEFT JOIN users u ON m.sender_type = 'user' AND m.sender_id = u.id
          WHERE m.conversation_id = ?
        `;
      
      const countQuery = 'SELECT COUNT(*) as total FROM messages WHERE conversation_id = ?';
      
      const result = await getPaginatedData(
        baseQuery + ' ORDER BY m.id DESC',
        countQuery,
        [conversationId],
        page,
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد رسائل المحادثة'
        });
      }
      
      // تحديد الرسائل كمقروءة للمستقبل
      const markAsReadQuery = `
        UPDATE messages 
        SET is_read = 1, read_at = NOW() 
        WHERE conversation_id = ? AND sender_type != ? AND is_read = 0
      `;
      
      const receiverType = userType === 'customer' ? 'customer' : 'user';
      await executeQuery(markAsReadQuery, [conversationId, receiverType]);
      
      res.json({
        success: true,
        message: 'تم استرداد رسائل المحادثة بنجاح',
        data: result.data,
        pagination: result.pagination,
        conversation: conversationCheckResult.data[0]
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

// POST /api/messages - إرسال رسالة جديدة
router.post('/',
  verifyToken,
  validate(messageSchemas.create),
  async (req, res) => {
    try {
      const { conversation_id, message } = req.validatedData;
      const { userType, userId } = req.user;
      
      // التحقق من وجود المحادثة والصلاحية
      let conversationCheckQuery = `
        SELECT id, customer_id, status
        FROM conversations 
        WHERE id = ?
      `;
      
      let conversationCheckParams = [conversation_id];
      
      // إذا كان عميل، تأكد من أنه يرسل في محادثته فقط
      if (userType === 'customer') {
        conversationCheckQuery += ' AND customer_id = ?';
        conversationCheckParams.push(userId);
      }
      
      const conversationCheckResult = await executeQuery(conversationCheckQuery, conversationCheckParams);
      
      if (!conversationCheckResult.success || conversationCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة أو غير مسموح لك بالوصول إليها'
        });
      }
      
      const conversation = conversationCheckResult.data[0];
      
      // التحقق من أن المحادثة مفتوحة
      if (conversation.status === 'closed' && userType === 'customer') {
        return res.status(400).json({
          success: false,
          message: 'المحادثة مغلقة، لا يمكن إرسال رسائل جديدة'
        });
      }
      // التحقق من أن المحادثة مفتوحة

       if (conversation.status === 'pending' && userType === 'customer') {
        return res.status(400).json({
          success: false,
          message: 'يرجى الأنتظار. حتى يقوم الدعم  بقبول محادثتك'
        });
      }
      
      // إدراج الرسالة الجديدة
      const insertQuery = `
        INSERT INTO messages (conversation_id, sender_type, sender_id, message)
        VALUES (?, ?, ?, ?)
      `;
      
      const insertParams = [conversation_id, userType, userId, message];
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إرسال الرسالة'
        });
      }
      
      // إذا كانت المحادثة مغلقة وأرسل المشرف رسالة، افتحها مرة أخرى
      if (conversation.status === 'closed' && userType === 'user') {
        await executeQuery('UPDATE conversations SET status = "open", updated_at = NOW() WHERE id = ?', [conversation_id]);
      }
      
      res.status(201).json({
        success: true,
        message: 'تم إرسال الرسالة بنجاح',
        data: {
          id: insertResult.data.insertId,
          conversation_id,
          message
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

// GET /api/messages/:id - عرض رسالة واحدة
router.get('/:id',
  verifyToken,
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { userType, userId } = req.user;
      
      let messageQuery = `
        SELECT 
          m.id, m.conversation_id, m.message, m.sender_type, m.sender_id,
          m.is_read, m.created_at,
          CASE 
            WHEN m.sender_type = 'customer' THEN c.full_name
            WHEN m.sender_type = 'user' THEN u.full_name
            ELSE 'غير معروف'
          END as sender_name,
          conv.customer_id
        FROM messages m
        LEFT JOIN customers c ON m.sender_type = 'customer' AND m.sender_id = c.id
        LEFT JOIN users u ON m.sender_type = 'user' AND m.sender_id = u.id
        JOIN conversations conv ON m.conversation_id = conv.id
        WHERE m.id = ?
      `;
      
      // إذا كان عميل، تأكد من أنه يطلب رسالة من محادثته فقط
      if (userType === 'customer') {
        messageQuery += ' AND conv.customer_id = ?';
      }
      
      const messageParams = userType === 'customer' ? [id, userId] : [id];
      const messageResult = await executeQuery(messageQuery, messageParams);
      
      if (!messageResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد الرسالة'
        });
      }
      
      if (messageResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الرسالة غير موجودة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد الرسالة بنجاح',
        data: messageResult.data[0]
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

// PUT /api/messages/:id/read - تحديد رسالة كمقروءة
router.put('/:id/read',
  verifyToken,
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { userType, userId } = req.user;
      
      // التحقق من وجود الرسالة والصلاحية
      let messageCheckQuery = `
        SELECT m.id, m.sender_type, m.is_read, conv.customer_id
        FROM messages m
        JOIN conversations conv ON m.conversation_id = conv.id
        WHERE m.id = ?
      `;
      
      // إذا كان عميل، تأكد من أنه يحدث رسالة في محادثته فقط
      if (userType === 'customer') {
        messageCheckQuery += ' AND conv.customer_id = ?';
      }
      
      const messageCheckParams = userType === 'customer' ? [id, userId] : [id];
      const messageCheckResult = await executeQuery(messageCheckQuery, messageCheckParams);
      
      if (!messageCheckResult.success || messageCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الرسالة غير موجودة'
        });
      }
      
      const message = messageCheckResult.data[0];
      
      // التحقق من أن المستخدم ليس مرسل الرسالة
      if (message.sender_type === userType) {
        return res.status(400).json({
          success: false,
          message: 'لا يمكنك تحديد رسائلك الخاصة كمقروءة'
        });
      }
      
      // تحديث حالة القراءة
      const updateQuery = `
        UPDATE messages 
        SET is_read = 1, read_at = NOW() 
        WHERE id = ?
      `;
      
      const updateResult = await executeQuery(updateQuery, [id]);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث حالة الرسالة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تحديد الرسالة كمقروءة'
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

// DELETE /api/messages/:id - حذف رسالة (للمشرفين فقط)
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      // التحقق من وجود الرسالة
      const checkQuery = 'SELECT id, message FROM messages WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الرسالة غير موجودة'
        });
      }
      
      // حذف الرسالة
      const deleteQuery = 'DELETE FROM messages WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف الرسالة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم حذف الرسالة بنجاح'
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

// GET /api/messages/unread/count - عدد الرسائل غير المقروءة
router.get('/unread/count',
  verifyToken,
  async (req, res) => {
    try {
      const { userType, userId } = req.user;
      
      let countQuery;
      let queryParams;
      
      if (userType === 'customer') {
        // عدد الرسائل غير المقروءة للعميل (من المشرفين)
        countQuery = `
          SELECT COUNT(*) as unread_count
          FROM messages m
          JOIN conversations conv ON m.conversation_id = conv.id
          WHERE conv.customer_id = ? AND m.sender_type = 'user' AND m.is_read = 0
        `;
        queryParams = [userId];
      } else {
        // عدد الرسائل غير المقروءة للمشرفين (من العملاء)
        countQuery = `
          SELECT COUNT(*) as unread_count
          FROM messages m
          WHERE m.sender_type = 'customer' AND m.is_read = 0
        `;
        queryParams = [];
      }
      
      const result = await executeQuery(countQuery, queryParams);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حساب الرسائل غير المقروءة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم حساب الرسائل غير المقروءة بنجاح',
        data: {
          unread_count: result.data[0].unread_count
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

// POST /api/messages/mark-all-read - تحديد جميع رسائل محادثة كمقروءة
router.post('/mark-all-read',
  verifyToken,
validate(messageSchemas.markAllRead),
  async (req, res) => {
    try {
      const { conversation_id } = req.validatedData;
      const { userType, userId } = req.user;
      
      // التحقق من وجود المحادثة والصلاحية
      let conversationCheckQuery = `
        SELECT id, customer_id
        FROM conversations 
        WHERE id = ?
      `;
      
      let conversationCheckParams = [conversation_id];
      
      if (userType === 'customer') {
        conversationCheckQuery += ' AND customer_id = ?';
        conversationCheckParams.push(userId);
      }
      
      const conversationCheckResult = await executeQuery(conversationCheckQuery, conversationCheckParams);
      
      if (!conversationCheckResult.success || conversationCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المحادثة غير موجودة'
        });
      }
      
      // تحديد جميع الرسائل كمقروءة (عدا رسائل المرسل نفسه)
      const updateQuery = `
        UPDATE messages 
        SET is_read = 1, read_at = NOW() 
        WHERE conversation_id = ? AND sender_type != ? AND is_read = 0
      `;
      
      const senderType = userType === 'customer' ? 'customer' : 'user';
      const updateResult = await executeQuery(updateQuery, [conversation_id, senderType]);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث الرسائل'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تحديد جميع الرسائل كمقروءة',
        data: {
          updated_count: updateResult.data.changedRows
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

module.exports = router;