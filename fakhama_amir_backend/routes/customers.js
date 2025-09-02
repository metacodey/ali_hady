const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, customerSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType } = require('../middleware/auth');

// GET /api/customers - عرض جميع العملاء (للمشرفين فقط)
router.get('/', 
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          id, username, email, full_name, phone, city, country,
          is_active, email_verified, phone_verified, created_at, last_login
        FROM customers
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM customers';
      let params = [];
      
      // إضافة البحث إذا كان موجود
      if (search) {
        const searchCondition = ' WHERE full_name LIKE ? OR email LIKE ? OR phone LIKE ?';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam, searchParam];
      }
      
      baseQuery += ' ORDER BY created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات العملاء'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات العملاء بنجاح',
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

// GET /api/customers/:id - عرض عميل واحد
router.get('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      const query = `
        SELECT 
          id, username, email, full_name, phone, 
          city, country, street_address, latitude, longitude,
          profile_image, is_active, email_verified, phone_verified,
          created_at, updated_at, last_login
        FROM customers 
        WHERE id = ?
      `;
      
      const result = await executeQuery(query, [id]);
      
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
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات العميل بنجاح',
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
          o.created_at, o.customer_notes, o.admin_notes
        FROM orders o
        JOIN order_statuses os ON o.status_id = os.id
        WHERE o.customer_id = ?
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

// GET /api/customers/stats - إحصائيات العملاء
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_customers,
          COUNT(CASE WHEN is_active = 1 THEN 1 END) as active_customers,
          COUNT(CASE WHEN DATE(created_at) = CURDATE() THEN 1 END) as new_today,
          COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as new_this_week
        FROM customers
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات العملاء'
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