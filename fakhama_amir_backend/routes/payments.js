const express = require('express');
const router = express.Router();
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, paymentSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType } = require('../middleware/auth');
const { sendPaymentNotification } = require('../config/firebase');
const Joi = require('joi');

// GET /api/payments - عرض جميع الدفعات (للمشرفين)
router.get('/',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          p.id, p.amount, p.payment_method, p.status, p.payment_date, p.created_at,
          o.order_number, c.full_name as customer_name
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        JOIN customers c ON o.customer_id = c.id
      `;
      
      let countQuery = `
        SELECT COUNT(*) as total 
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        JOIN customers c ON o.customer_id = c.id
      `;
      
      let params = [];
      
      if (search) {
        const searchCondition = ' WHERE (o.order_number LIKE ? OR c.full_name LIKE ?)';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam];
      }
      
      baseQuery += ' ORDER BY p.created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات الدفعات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات الدفعات بنجاح',
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

// GET /api/payments/order/:orderId - دفعات طلب معين
router.get('/order/:orderId',
  verifyToken,
  validateParams({ orderId: Joi.number().integer().positive().required() }),
  async (req, res) => {
    try {
      const { orderId } = req.validatedParams;
      const { userType, userId } = req.user;
      
      // التحقق من وجود الطلب والصلاحية
      let orderCheckQuery = `
        SELECT o.id, o.order_number, c.full_name as customer_name
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        WHERE o.id = ?
      `;
      
      let orderCheckParams = [orderId];
      
      // إذا كان عميل، تأكد من أنه يطلب دفعات طلبه فقط
      if (userType === 'customer') {
        orderCheckQuery += ' AND o.customer_id = ?';
        orderCheckParams.push(userId);
      }
      
      const orderCheckResult = await executeQuery(orderCheckQuery, orderCheckParams);
      
      if (!orderCheckResult.success || orderCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الطلب غير موجود'
        });
      }
      
      // استرداد دفعات الطلب
      const paymentsQuery = `
        SELECT id, amount, payment_method, status, notes, payment_date, created_at
        FROM payments 
        WHERE order_id = ?
        ORDER BY created_at DESC
      `;
      
      const paymentsResult = await executeQuery(paymentsQuery, [orderId]);
      
      if (!paymentsResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد دفعات الطلب'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد دفعات الطلب بنجاح',
        data: {
          order: orderCheckResult.data[0],
          payments: paymentsResult.data
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

// GET /api/payments/my - دفعات العميل المسجل دخوله
router.get('/my',
  verifyToken,
  checkUserType(['customer']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit } = req.validatedQuery;
      const customerId = req.user.userId;
      
      const baseQuery = `
        SELECT 
          p.id, p.amount, p.payment_method, p.status, p.payment_date, p.notes,
          o.order_number, o.total_amount as order_total
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        WHERE o.customer_id = ?
      `;
      
      const countQuery = `
        SELECT COUNT(*) as total 
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        WHERE o.customer_id = ?
      `;
      
      const result = await getPaginatedData(
        baseQuery + ' ORDER BY p.created_at DESC',
        countQuery,
        [customerId],
        page,
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد دفعاتك'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد دفعاتك بنجاح',
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

// GET /api/payments/:id - عرض دفعة واحدة
router.get('/:id',
  verifyToken,
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { userType, userId } = req.user;
      
      let paymentQuery = `
        SELECT 
          p.id, p.amount, p.payment_method, p.status, p.notes,
          p.payment_date, p.created_at, p.updated_at,
          o.order_number, o.total_amount as order_total,
          c.full_name as customer_name, c.email as customer_email
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        JOIN customers c ON o.customer_id = c.id
        WHERE p.id = ?
      `;
      
      let paymentParams = [id];
      
      // إذا كان عميل، تأكد من أنه يطلب دفعة طلبه فقط
      if (userType === 'customer') {
        paymentQuery += ' AND o.customer_id = ?';
        paymentParams.push(userId);
      }
      
      const paymentResult = await executeQuery(paymentQuery, paymentParams);
      
      if (!paymentResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات الدفعة'
        });
      }
      
      if (paymentResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الدفعة غير موجودة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات الدفعة بنجاح',
        data: paymentResult.data[0]
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

// POST /api/payments - إنشاء دفعة جديدة
router.post('/',
  verifyToken,
  checkUserType(['user']),
  validate(paymentSchemas.create),
  async (req, res) => {
    try {
      const { order_id, amount, payment_method, notes } = req.validatedData;
      
      // التحقق من وجود الطلب
      const orderCheckQuery = `
        SELECT o.id, o.order_number, o.total_amount, o.customer_id, c.firebase_token, c.full_name
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        WHERE o.id = ?
      `;
      
      const orderCheckResult = await executeQuery(orderCheckQuery, [order_id]);
      
      if (!orderCheckResult.success || orderCheckResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الطلب غير موجود'
        });
      }
      
      const order = orderCheckResult.data[0];
      
      // التحقق من أن المبلغ لا يتجاوز إجمالي الطلب
      if (amount > order.total_amount) {
        return res.status(400).json({
          success: false,
          message: 'مبلغ الدفعة لا يمكن أن يتجاوز إجمالي الطلب'
        });
      }
      
      // حساب إجمالي الدفعات السابقة
      const previousPaymentsQuery = `
        SELECT COALESCE(SUM(amount), 0) as total_paid
        FROM payments 
        WHERE order_id = ? AND status = 'paid'
      `;
      
      const previousPaymentsResult = await executeQuery(previousPaymentsQuery, [order_id]);
      
      if (!previousPaymentsResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حساب الدفعات السابقة'
        });
      }
      
      const totalPaid = previousPaymentsResult.data[0].total_paid;
      const remainingAmount = order.total_amount - totalPaid;
      
      if (amount > remainingAmount) {
        return res.status(400).json({
          success: false,
          message: `المبلغ المتبقي للطلب هو ${remainingAmount} ريال فقط`
        });
      }
      
      // إنشاء الدفعة الجديدة
      const insertQuery = `
        INSERT INTO payments (order_id, amount, payment_method, notes, status)
        VALUES (?, ?, ?, ?, ?)
      `;
      
      const insertParams = [order_id, amount, payment_method, notes || null, 'paid'];
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء الدفعة'
        });
      }

      const paymentId = insertResult.data.insertId;
      
      // إرسال إشعار Firebase للعميل
      console.log('🔔 بدء عملية إرسال إشعار Firebase للعميل...');
      console.log(`👤 العميل: ${order.full_name} (ID: ${order.customer_id})`);
      console.log(`💰 الدفعة: ${amount} ريال للطلب ${order.order_number}`);
      
      if (order.firebase_token) {
        try {
          const notificationData = {
            paymentId: paymentId,
            orderNumber: order.order_number,
            amount: amount,
            paymentMethod: payment_method
          };
          
          const notificationResult = await sendPaymentNotification(order.firebase_token, notificationData);
          
          if (notificationResult.success) {
            console.log('✅ تم إرسال إشعار Firebase بنجاح للعميل');
            console.log(`📨 معرف الرسالة: ${notificationResult.messageId}`);
          } else {
            console.log('❌ فشل في إرسال إشعار Firebase للعميل');
            console.log(`🔍 السبب: ${notificationResult.error}`);
          }
        } catch (notificationError) {
          console.error('❌ خطأ غير متوقع في إرسال إشعار Firebase:', notificationError.message);
        }
      } else {
        console.log('⚠️ لا يوجد Firebase token للعميل - لن يتم إرسال إشعار');
        console.log(`👤 العميل: ${order.full_name} (ID: ${order.customer_id})`);
      }
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء الدفعة بنجاح',
        data: {
          id: paymentId,
          order_number: order.order_number,
          amount: amount,
          remaining_amount: remainingAmount - amount
        }
      });
    } catch (error) {
      console.error('❌ خطأ في إنشاء الدفعة:', error.message);
      res.status(500).json({
        success: false,
        message: 'خطأ في الخادم',
        error: error.message
      });
    }
  }
);

// PUT /api/payments/:id/status - تحديث حالة الدفعة
router.put('/:id/status',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  validate(paymentSchemas.updateStatus),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { status, notes } = req.validatedData;
      
      // التحقق من وجود الدفعة
      const checkQuery = `
        SELECT p.id, p.status as current_status, o.order_number
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        WHERE p.id = ?
      `;
      
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الدفعة غير موجودة'
        });
      }
      
      const currentStatus = checkResult.data[0].current_status;
      const orderNumber = checkResult.data[0].order_number;
      
      // تحديث حالة الدفعة
      let updateQuery = `UPDATE payments SET status = ?, updated_at = NOW()`;
      let updateParams = [status];
      
      if (notes) {
        updateQuery += `, notes = ?`;
        updateParams.push(notes);
      }
      
      if (status === 'paid') {
        updateQuery += `, payment_date = NOW()`;
      }
      
      updateQuery += ` WHERE id = ?`;
      updateParams.push(id);
      
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث حالة الدفعة'
        });
      }
      
      const statusText = {
        'pending': 'في الانتظار',
        'paid': 'مدفوعة',
        'failed': 'فشلت'
      };
      
      res.json({
        success: true,
        message: `تم تحديث حالة الدفعة للطلب ${orderNumber} إلى ${statusText[status] || status}`
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

// DELETE /api/payments/:id - حذف دفعة
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      // التحقق من وجود الدفعة
      const checkQuery = `
        SELECT p.id, p.status, o.order_number
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        WHERE p.id = ?
      `;
      
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الدفعة غير موجودة'
        });
      }
      
      const payment = checkResult.data[0];
      
      // منع حذف الدفعات المدفوعة
      if (payment.status === 'paid') {
        return res.status(400).json({
          success: false,
          message: 'لا يمكن حذف دفعة مدفوعة'
        });
      }
      
      // حذف الدفعة
      const deleteQuery = 'DELETE FROM payments WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف الدفعة'
        });
      }
      
      res.json({
        success: true,
        message: `تم حذف الدفعة للطلب ${payment.order_number} بنجاح`
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

// GET /api/payments/methods/list - قائمة طرق الدفع المتاحة
router.get('/methods/list',
  async (req, res) => {
    try {
      const methods = [
        { value: 'نقداً', label: 'الدفع نقداً عند الاستلام' },
        { value: 'بطاقة ائتمان', label: 'بطاقة ائتمان' },
        { value: 'تحويل بنكي', label: 'تحويل بنكي' },
        { value: 'محفظة إلكترونية', label: 'محفظة إلكترونية' },
        { value: 'شبكة', label: 'بطاقة شبكة' },
        { value: 'STC Pay', label: 'محفظة STC Pay' },
        { value: 'Apple Pay', label: 'Apple Pay' },
        { value: 'مدى', label: 'بطاقة مدى' }
      ];
      
      res.json({
        success: true,
        message: 'تم استرداد طرق الدفع بنجاح',
        data: methods
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

// GET /api/payments/dashboard/stats - إحصائيات الدفعات
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_payments,
          COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_payments,
          COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_payments,
          COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_payments,
          COALESCE(SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END), 0) as total_revenue,
          COALESCE(SUM(CASE WHEN status = 'paid' AND DATE(payment_date) = CURDATE() THEN amount ELSE 0 END), 0) as today_revenue,
          COALESCE(SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END), 0) as pending_amount,
          COALESCE(AVG(CASE WHEN status = 'paid' THEN amount END), 0) as average_payment,
          COUNT(CASE WHEN DATE(created_at) = CURDATE() THEN 1 END) as today_payments,
          COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as week_payments,
          COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) as month_payments
        FROM payments
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات الدفعات'
        });
      }
      
      const stats = result.data[0];
      
      // حساب معدل النجاح
      const successRate = stats.total_payments > 0 
        ? ((stats.paid_payments / stats.total_payments) * 100).toFixed(2)
        : 0;
      
      res.json({
        success: true,
        message: 'تم استرداد الإحصائيات بنجاح',
        data: {
          ...stats,
          success_rate: parseFloat(successRate)
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

// GET /api/payments/reports/monthly - تقارير شهرية
router.get('/reports/monthly',
  verifyToken,
  checkUserType(['user']),
  validateQuery(Joi.object({
    year: Joi.number().integer().min(2020).max(2030).optional().default(new Date().getFullYear()),
    month: Joi.number().integer().min(1).max(12).optional()
  })),
  async (req, res) => {
    try {
      const { year, month } = req.validatedQuery;
      
      let dateCondition = 'YEAR(p.created_at) = ?';
      let queryParams = [year];
      
      if (month) {
        dateCondition += ' AND MONTH(p.created_at) = ?';
        queryParams.push(month);
      }
      
      // ملخص عام
      const summaryQuery = `
        SELECT 
          COUNT(*) as total_payments,
          COALESCE(SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END), 0) as paid_amount,
          COALESCE(SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END), 0) as pending_amount,
          COALESCE(SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END), 0) as failed_amount,
          COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_count,
          COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_count,
          COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_count
        FROM payments p
        WHERE ${dateCondition}
      `;
      
      // التوزيع حسب طريقة الدفع
      const methodsQuery = `
        SELECT 
          payment_method as method,
          COUNT(*) as count,
          COALESCE(SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END), 0) as amount
        FROM payments p
        WHERE ${dateCondition} AND status = 'paid'
        GROUP BY payment_method
        ORDER BY amount DESC
      `;
      
      // التوزيع اليومي
      const dailyQuery = `
        SELECT 
          DATE(p.created_at) as date,
          COUNT(*) as payments_count,
          COALESCE(SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END), 0) as total_amount
        FROM payments p
        WHERE ${dateCondition}
        GROUP BY DATE(p.created_at)
        ORDER BY date ASC
      `;
      
      const [summaryResult, methodsResult, dailyResult] = await Promise.all([
        executeQuery(summaryQuery, queryParams),
        executeQuery(methodsQuery, queryParams),
        executeQuery(dailyQuery, queryParams)
      ]);
      
      if (!summaryResult.success || !methodsResult.success || !dailyResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد التقرير الشهري'
        });
      }
      
      const summary = summaryResult.data[0];
      const successRate = summary.total_payments > 0 
        ? ((summary.paid_count / summary.total_payments) * 100).toFixed(1)
        : 0;
      
      // حساب النسب المئوية لطرق الدفع
      const totalPaidAmount = summary.paid_amount;
      const methodsWithPercentage = methodsResult.data.map(method => ({
        ...method,
        percentage: totalPaidAmount > 0 
          ? ((method.amount / totalPaidAmount) * 100).toFixed(1)
          : 0
      }));
      
      const months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      
      const periodName = month 
        ? `${months[month - 1]} ${year}`
        : `عام ${year}`;
      
      res.json({
        success: true,
        message: 'تم استرداد التقرير الشهري بنجاح',
        data: {
          period: periodName,
          summary: {
            ...summary,
            success_rate: parseFloat(successRate)
          },
          by_method: methodsWithPercentage,
          daily_summary: dailyResult.data
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

// GET /api/payments/search/date - البحث بالتاريخ
router.get('/search/date',
  verifyToken,
  checkUserType(['user']),
  validateQuery(Joi.object({
    from_date: Joi.date().iso().required(),
    to_date: Joi.date().iso().min(Joi.ref('from_date')).required(),
    status: Joi.string().valid('pending', 'paid', 'failed').optional(),
    payment_method: Joi.string().max(50).optional(),
    page: Joi.number().integer().positive().optional().default(1),
    limit: Joi.number().integer().min(1).max(100).optional().default(10)
  })),
  async (req, res) => {
    try {
      const { from_date, to_date, status, payment_method, page, limit } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          p.id, p.amount, p.payment_method, p.status, p.payment_date, p.created_at,
          o.order_number, c.full_name as customer_name
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        JOIN customers c ON o.customer_id = c.id
        WHERE DATE(p.created_at) BETWEEN ? AND ?
      `;
      
      let countQuery = `
        SELECT COUNT(*) as total
        FROM payments p
        JOIN orders o ON p.order_id = o.id
        JOIN customers c ON o.customer_id = c.id
        WHERE DATE(p.created_at) BETWEEN ? AND ?
      `;
      
      let params = [from_date, to_date];
      
      if (status) {
        baseQuery += ' AND p.status = ?';
        countQuery += ' AND p.status = ?';
        params.push(status);
      }
      
      if (payment_method) {
        baseQuery += ' AND p.payment_method = ?';
        countQuery += ' AND p.payment_method = ?';
        params.push(payment_method);
      }
      
      // استعلام الملخص
      const summaryQuery = `
        SELECT 
          COUNT(*) as total_found,
          COALESCE(SUM(amount), 0) as total_amount,
          COALESCE(AVG(amount), 0) as average_payment
        FROM payments p
        WHERE DATE(p.created_at) BETWEEN ? AND ?
        ${status ? 'AND p.status = ?' : ''}
        ${payment_method ? 'AND p.payment_method = ?' : ''}
      `;
      
      let summaryParams = [from_date, to_date];
      if (status) summaryParams.push(status);
      if (payment_method) summaryParams.push(payment_method);
      
      baseQuery += ' ORDER BY p.created_at DESC';
      
      const [dataResult, summaryResult] = await Promise.all([
        getPaginatedData(baseQuery, countQuery, params, page, limit),
        executeQuery(summaryQuery, summaryParams)
      ]);
      
      if (!dataResult.success || !summaryResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في البحث في الدفعات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم البحث في الدفعات بنجاح',
        data: dataResult.data,
        pagination: dataResult.pagination,
        summary: summaryResult.data[0]
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
