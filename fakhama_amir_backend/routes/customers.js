const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, customerSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType } = require('../middleware/auth');

// GET /api/customers - عرض جميع العملاء مع المبلغ المتبقي (للمشرفين فقط)
router.get('/', 
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          c.id, c.username, c.email, c.full_name, c.phone, c.city, c.country,
          c.is_active, c.email_verified, c.phone_verified, c.created_at, c.last_login,
          COALESCE(order_totals.total_orders, 0) as total_orders,
          COALESCE(order_totals.total_amount, 0.00) as total_amount,
          COALESCE(payment_totals.total_paid, 0.00) as total_paid,
          COALESCE(order_totals.total_amount, 0.00) - COALESCE(payment_totals.total_paid, 0.00) as remaining_amount
        FROM customers c
        LEFT JOIN (
          SELECT 
            customer_id,
            COUNT(*) as total_orders,
            SUM(total_amount) as total_amount
          FROM orders 
          GROUP BY customer_id
        ) order_totals ON c.id = order_totals.customer_id
        LEFT JOIN (
          SELECT 
            o.customer_id,
            SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END) as total_paid
          FROM orders o
          LEFT JOIN payments p ON o.id = p.order_id
          GROUP BY o.customer_id
        ) payment_totals ON c.id = payment_totals.customer_id
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM customers c';
      let params = [];
      
      // إضافة البحث إذا كان موجود
      if (search) {
        const searchCondition = ' WHERE c.full_name LIKE ? OR c.email LIKE ? OR c.phone LIKE ?';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam, searchParam];
      }
      
      baseQuery += ' ORDER BY c.created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات العملاء'
        });
      }
      
      // تنسيق البيانات لإظهار المبالغ بشكل واضح
      const formattedData = result.data.map(customer => ({
        ...customer,
        financial_summary: {
          total_orders: customer.total_orders,
          total_amount: parseFloat(customer.total_amount),
          total_paid: parseFloat(customer.total_paid),
          remaining_amount: parseFloat(customer.remaining_amount),
          payment_status: customer.remaining_amount > 0 ? 'has_debt' : 'paid_up'
        }
      }));
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات العملاء بنجاح',
        data: formattedData,
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

// GET /api/customers/map - عرض جميع العملاء مع المبلغ المتبقي على الخريطة
router.get('/map', 
 verifyToken,
 checkUserType(['user']),
 async (req, res) => {
   try {
     const query = `
       SELECT 
         c.id, c.full_name, c.phone, c.latitude, c.longitude,
         COALESCE(order_totals.total_amount, 0.00) - COALESCE(payment_totals.total_paid, 0.00) as remaining_amount
       FROM customers c
       LEFT JOIN (
         SELECT 
           customer_id,
           SUM(total_amount) as total_amount
         FROM orders 
         GROUP BY customer_id
       ) order_totals ON c.id = order_totals.customer_id
       LEFT JOIN (
         SELECT 
           o.customer_id,
           SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END) as total_paid
         FROM orders o
         LEFT JOIN payments p ON o.id = p.order_id
         GROUP BY o.customer_id
       ) payment_totals ON c.id = payment_totals.customer_id
       WHERE c.latitude IS NOT NULL AND c.longitude IS NOT NULL
       ORDER BY c.created_at DESC
     `;
     
     const result = await executeQuery(query);
     
     if (!result.success) {
       return res.status(500).json({
         success: false,
         message: 'خطأ في استرداد بيانات العملاء'
       });
     }
     
     // تنسيق البيانات للخريطة مع المبلغ المتبقي
     const mapData = result.data.map(customer => ({
       ...customer,
       remaining_amount: parseFloat(customer.remaining_amount),
       debt_level: customer.remaining_amount > 1000 ? 'high' : 
                  customer.remaining_amount > 0 ? 'medium' : 'none'
     }));
     
     res.json({
       success: true,
       message: 'تم استرداد بيانات العملاء بنجاح',
       data: mapData
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

// GET /api/customers/:id - عرض عميل واحد مع تفاصيل مالية كاملة
router.get('/:id',
  verifyToken,
  checkUserType(['user','customer']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      const query = `
        SELECT 
          c.id, c.username, c.email, c.full_name, c.phone, 
          c.city, c.country, c.street_address, c.latitude, c.longitude,
          c.profile_image, c.is_active, c.email_verified, c.phone_verified,
          c.created_at, c.updated_at, c.last_login,
          COALESCE(order_totals.total_orders, 0) as total_orders,
          COALESCE(order_totals.total_amount, 0.00) as total_amount,
          COALESCE(payment_totals.total_paid, 0.00) as total_paid,
          COALESCE(order_totals.total_amount, 0.00) - COALESCE(payment_totals.total_paid, 0.00) as remaining_amount
        FROM customers c
        LEFT JOIN (
          SELECT 
            customer_id,
            COUNT(*) as total_orders,
            SUM(total_amount) as total_amount
          FROM orders 
          WHERE customer_id = ?
          GROUP BY customer_id
        ) order_totals ON c.id = order_totals.customer_id
        LEFT JOIN (
          SELECT 
            o.customer_id,
            SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END) as total_paid
          FROM orders o
          LEFT JOIN payments p ON o.id = p.order_id
          WHERE o.customer_id = ?
          GROUP BY o.customer_id
        ) payment_totals ON c.id = payment_totals.customer_id
        WHERE c.id = ?
      `;
      
      const result = await executeQuery(query, [id, id, id]);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات العميل'
        });
      }
      
      if (result.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'العميل غير موجود'
        });
      }
      
      const customer = result.data[0];
      
      // إضافة تفاصيل مالية منظمة
      const customerWithFinancials = {
        ...customer,
        financial_details: {
          total_orders: customer.total_orders,
          total_amount: parseFloat(customer.total_amount),
          total_paid: parseFloat(customer.total_paid),
          remaining_amount: parseFloat(customer.remaining_amount),
          payment_percentage: customer.total_amount > 0 ? 
            ((customer.total_paid / customer.total_amount) * 100).toFixed(2) : 0,
          status: customer.remaining_amount > 0 ? 'مديون' : 'مسدد'
        }
      };
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات العميل بنجاح',
        data: customerWithFinancials
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

// GET /api/customers/dashboard/stats - إحصائيات العملاء مع المعلومات المالية
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_customers,
          COUNT(CASE WHEN c.is_active = 1 THEN 1 END) as active_customers,
          COUNT(CASE WHEN DATE(c.created_at) = CURDATE() THEN 1 END) as new_today,
          COUNT(CASE WHEN DATE(c.created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as new_this_week,
          COUNT(CASE WHEN financial_data.remaining_amount > 0 THEN 1 END) as customers_with_debt,
          COALESCE(SUM(financial_data.remaining_amount), 0) as total_debt,
          COALESCE(AVG(financial_data.remaining_amount), 0) as average_debt_per_customer
        FROM customers c
        LEFT JOIN (
          SELECT 
            c.id,
            COALESCE(order_totals.total_amount, 0.00) - COALESCE(payment_totals.total_paid, 0.00) as remaining_amount
          FROM customers c
          LEFT JOIN (
            SELECT customer_id, SUM(total_amount) as total_amount
            FROM orders GROUP BY customer_id
          ) order_totals ON c.id = order_totals.customer_id
          LEFT JOIN (
            SELECT 
              o.customer_id,
              SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END) as total_paid
            FROM orders o
            LEFT JOIN payments p ON o.id = p.order_id
            GROUP BY o.customer_id
          ) payment_totals ON c.id = payment_totals.customer_id
        ) financial_data ON c.id = financial_data.id
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات العملاء'
        });
      }
      
      const stats = result.data[0];
      
      // تنسيق الإحصائيات
      const formattedStats = {
        customers: {
          total: stats.total_customers,
          active: stats.active_customers,
          new_today: stats.new_today,
          new_this_week: stats.new_this_week
        },
        financial: {
          customers_with_debt: stats.customers_with_debt,
          total_debt: parseFloat(stats.total_debt),
          average_debt: parseFloat(stats.average_debt_per_customer),
          debt_percentage: stats.total_customers > 0 ? 
            ((stats.customers_with_debt / stats.total_customers) * 100).toFixed(2) : 0
        }
      };
      
      res.json({
        success: true,
        message: 'تم استرداد الإحصائيات بنجاح',
        data: formattedStats
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

// GET /api/customers/debts - قائمة العملاء المديونين فقط
router.get('/debts/list',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit } = req.validatedQuery;
      
      const baseQuery = `
        SELECT 
          c.id, c.full_name, c.email, c.phone, c.city,
          COALESCE(order_totals.total_amount, 0.00) as total_amount,
          COALESCE(payment_totals.total_paid, 0.00) as total_paid,
          COALESCE(order_totals.total_amount, 0.00) - COALESCE(payment_totals.total_paid, 0.00) as remaining_amount,
          c.last_login
        FROM customers c
        LEFT JOIN (
          SELECT customer_id, SUM(total_amount) as total_amount
          FROM orders GROUP BY customer_id
        ) order_totals ON c.id = order_totals.customer_id
        LEFT JOIN (
          SELECT 
            o.customer_id,
            SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END) as total_paid
          FROM orders o
          LEFT JOIN payments p ON o.id = p.order_id
          GROUP BY o.customer_id
        ) payment_totals ON c.id = payment_totals.customer_id
        HAVING remaining_amount > 0
      `;
      
      const countQuery = `
        SELECT COUNT(*) as total FROM (
          ${baseQuery}
        ) as debt_customers
      `;
      
      const result = await getPaginatedData(
        baseQuery + ' ORDER BY remaining_amount DESC', 
        countQuery, 
        [], 
        page, 
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد قائمة المديونين'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد قائمة العملاء المديونين بنجاح',
        data: result.data.map(customer => ({
          ...customer,
          remaining_amount: parseFloat(customer.remaining_amount),
          total_amount: parseFloat(customer.total_amount),
          total_paid: parseFloat(customer.total_paid)
        })),
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

// باقي الروتات تبقى كما هي...
// POST /api/customers - إنشاء عميل جديد
router.post('/',
  validate(customerSchemas.create),
  async (req, res) => {
    try {
      const customerData = req.validatedData;
      
      // التحقق من عدم وجود اسم المستخدم أو البريد مسبقاً
      const checkQuery = 'SELECT id FROM customers WHERE username = ? OR email = ?';
      const checkResult = await executeQuery(checkQuery, [customerData.username, customerData.email]);
      
      if (!checkResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في التحقق من البيانات'
        });
      }
      
      if (checkResult.data.length > 0) {
        return res.status(409).json({
          success: false,
          message: 'اسم المستخدم أو البريد الإلكتروني موجود مسبقاً'
        });
      }
      
      // تشفير كلمة المرور
      const hashedPassword = await bcrypt.hash(customerData.password, 12);
      
      // إدراج العميل الجديد
      const insertQuery = `
        INSERT INTO customers (
          username, email, password_hash, full_name, phone,
          city, country, street_address, latitude, longitude
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      
      const insertParams = [
        customerData.username,
        customerData.email,
        hashedPassword,
        customerData.full_name,
        customerData.phone,
        customerData.city,
        customerData.country,
        customerData.street_address,
        customerData.latitude || null,
        customerData.longitude || null
      ];
      
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء العميل'
        });
      }
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء العميل بنجاح',
        data: { id: insertResult.data.insertId }
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

// PUT /api/customers/:id/location - تحديث بيانات الموقع للعميل
router.put('/:id/location',
  verifyToken,
  checkUserType(['user', 'customer']),
  validateParams(commonSchemas.id),
  validate(customerSchemas.updateLocation),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { city, street_address, country, latitude, longitude } = req.validatedData;
      const { userType, userId } = req.user;
      
      // إذا كان العميل، تأكد من أنه يحدث بياناته فقط
      if (userType === 'customer' && parseInt(userId) !== parseInt(id)) {
        return res.status(403).json({
          success: false,
          message: 'غير مسموح لك بتحديث بيانات عميل آخر'
        });
      }
      
      // التحقق من وجود العميل
      const checkQuery = 'SELECT id, full_name FROM customers WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'العميل غير موجود'
        });
      }
      
      // إعداد البيانات للتحديث
      const updateFields = [];
      const updateParams = [];
      
      updateFields.push('city = ?', 'street_address = ?');
      updateParams.push(city, street_address);
      
      if (country !== undefined) {
        updateFields.push('country = ?');
        updateParams.push(country);
      }
      
      if (latitude !== undefined && longitude !== undefined) {
        updateFields.push('latitude = ?', 'longitude = ?');
        updateParams.push(latitude, longitude);
      }
      
      updateFields.push('updated_at = NOW()');
      updateParams.push(id);
      
      // تنفيذ التحديث
      const updateQuery = `UPDATE customers SET ${updateFields.join(', ')} WHERE id = ?`;
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث بيانات الموقع'
        });
      }
      
      res.json({
        success: true,
        message: `تم تحديث بيانات الموقع للعميل ${checkResult.data[0].full_name} بنجاح`
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
// PUT /api/customers/:id - تحديث بيانات العميل
router.put('/:id',
  verifyToken,
  validateParams(commonSchemas.id),
  validate(customerSchemas.update),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const updateData = req.validatedData;
      
      // التحقق من وجود العميل
      const checkQuery = 'SELECT id FROM customers WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'العميل غير موجود'
        });
      }
      
      // بناء استعلام التحديث
      const updateFields = [];
      const updateParams = [];
      
      Object.keys(updateData).forEach(key => {
        if (updateData[key] !== undefined) {
          updateFields.push(`${key} = ?`);
          updateParams.push(updateData[key]);
        }
      });
      
      if (updateFields.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'لا توجد بيانات للتحديث'
        });
      }
      
      updateFields.push('updated_at = NOW()');
      updateParams.push(id);
      
      const updateQuery = `UPDATE customers SET ${updateFields.join(', ')} WHERE id = ?`;
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث بيانات العميل'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تحديث بيانات العميل بنجاح'
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

// DELETE /api/customers/:id - حذف عميل
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      // التحقق من وجود العميل
      const checkQuery = 'SELECT id, full_name FROM customers WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'العميل غير موجود'
        });
      }
      
      // حذف العميل (سيتم حذف الطلبات والمحادثات تلقائياً بسبب CASCADE)
      const deleteQuery = 'DELETE FROM customers WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف العميل'
        });
      }
      
      res.json({
        success: true,
        message: `تم حذف العميل ${checkResult.data[0].full_name} بنجاح`
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

// GET /api/customers/:id/orders - طلبات العميل
router.get('/:id/orders',
  verifyToken,
  validateParams(commonSchemas.id),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { page, limit } = req.validatedQuery;
      
      const baseQuery = `
        SELECT 
          o.id, o.order_number, o.total_amount,
          os.name as status, os.color as status_color,
          o.created_at, o.customer_notes, o.admin_notes,
          COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as paid_amount,
          o.total_amount - COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as remaining_amount
        FROM orders o
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN payments p ON o.id = p.order_id
        WHERE o.customer_id = ?
        GROUP BY o.id, o.order_number, o.total_amount, os.name, os.color, o.created_at, o.customer_notes, o.admin_notes
      `;
      
      const countQuery = 'SELECT COUNT(*) as total FROM orders WHERE customer_id = ?';
      
      const result = await getPaginatedData(baseQuery + ' ORDER BY o.created_at DESC', countQuery, [id], page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد طلبات العميل'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد طلبات العميل بنجاح',
        data: result.data.map(order => ({
          ...order,
          total_amount: parseFloat(order.total_amount),
          paid_amount: parseFloat(order.paid_amount),
          remaining_amount: parseFloat(order.remaining_amount)
        })),
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

module.exports = router;