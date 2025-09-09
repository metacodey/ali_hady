const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { executeQuery } = require('../config/database');
const { validate, customerSchemas } = require('../middleware/validation');

// دالة لتوليد JWT Token
const generateToken = (userId, userType) => {
  return jwt.sign(
    { userId, userType },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
  );
};

// تسجيل دخول العميل
router.post('/customer/login',
  validate(customerSchemas.login),
  async (req, res) => {
    try {
      // console.log(req);
      const { email, password } = req.validatedData;
      
      // البحث عن العميل
      const query = `
        SELECT id, email, password_hash, full_name, is_active, email_verified
        FROM customers 
        WHERE email = ?
      `;
      
      const result = await executeQuery(query, [email]);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في الخادم'
        });
      }
      
      if (result.data.length === 0) {
        return res.status(401).json({
          success: false,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
        });
      }
      
      const customer = result.data[0];
      
      // التحقق من كلمة المرور
      const isPasswordValid = await bcrypt.compare(password, customer.password_hash);
      
      if (!isPasswordValid) {
        return res.status(401).json({
          success: false,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
        });
      }
      
      // التحقق من تفعيل الحساب
      if (!customer.is_active) {
        return res.status(403).json({
          success: false,
          message: 'الحساب غير مفعل، تواصل مع الإدارة'
        });
      }
      
      // تحديث آخر تسجيل دخول
      await executeQuery('UPDATE customers SET last_login = NOW() WHERE id = ?', [customer.id]);
      
      // توليد التوكن
      const token = generateToken(customer.id, 'customer');
      
      res.json({
        success: true,
        message: 'تم تسجيل الدخول بنجاح',
        data: {
          token,
          user: {
            id: customer.id,
            email: customer.email,
            full_name: customer.full_name,
            type: 'customer'
          }
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

// تسجيل دخول المستخدم/المشرف
router.post('/user/login',
  validate(customerSchemas.login), // نفس schema البريد وكلمة المرور
  async (req, res) => {
    try {
      const { email, password } = req.validatedData;
      
      // البحث عن المستخدم
      const query = `
        SELECT id, email, password_hash, full_name, is_active
        FROM users 
        WHERE email = ?
      `;
      
      const result = await executeQuery(query, [email]);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في الخادم'
        });
      }
      
      if (result.data.length === 0) {
        return res.status(401).json({
          success: false,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
        });
      }
      
      const user = result.data[0];
      
      // التحقق من كلمة المرور
      const isPasswordValid = await bcrypt.compare(password, user.password_hash);
      
      if (!isPasswordValid) {
        return res.status(401).json({
          success: false,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
        });
      }
      
      // التحقق من تفعيل الحساب
      if (!user.is_active) {
        return res.status(403).json({
          success: false,
          message: 'الحساب غير مفعل'
        });
      }
      
      // تحديث آخر تسجيل دخول
      await executeQuery('UPDATE users SET last_login = NOW() WHERE id = ?', [user.id]);
      
      // توليد التوكن
      const token = generateToken(user.id, 'user');
      
      res.json({
        success: true,
        message: 'تم تسجيل الدخول بنجاح',
        data: {
          token,
          user: {
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            type: 'user'
          }
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

// تسجيل عميل جديد
router.post('/customer/register',
  validate(customerSchemas.create),
  async (req, res) => {
    try {
      const customerData = req.validatedData;
      
      // التحقق من عدم وجود العميل مسبقاً
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
          message: 'خطأ في إنشاء الحساب'
        });
      }
      
      const customerId = insertResult.data.insertId;
      
      // توليد التوكن للعميل الجديد
      const token = generateToken(customerId, 'customer');
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء الحساب بنجاح',
        data: {
          token,
          user: {
            id: customerId,
            email: customerData.email,
            full_name: customerData.full_name,
            type: 'customer'
          }
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

// التحقق من صحة التوكن
router.get('/verify',
  async (req, res) => {
    try {
      const authHeader = req.headers.authorization;
      
      if (!authHeader) {
        return res.status(401).json({
          success: false,
          message: 'مطلوب توكن المصادقة'
        });
      }

      const token = authHeader.split(' ')[1];
      
      if (!token) {
        return res.status(401).json({
          success: false,
          message: 'صيغة التوكن غير صحيحة'
        });
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      
      // البحث عن المستخدم حسب النوع
      let query, tableName;
      
      if (decoded.userType === 'customer') {
        query = 'SELECT id, email, full_name, is_active FROM customers WHERE id = ?';
        tableName = 'customers';
      } else {
        query = 'SELECT id, email, full_name, is_active FROM users WHERE id = ?';
        tableName = 'users';
      }
      
      const result = await executeQuery(query, [decoded.userId]);
      
      if (!result.success || result.data.length === 0) {
        return res.status(401).json({
          success: false,
          message: 'المستخدم غير موجود'
        });
      }
      
      const user = result.data[0];
      
      if (!user.is_active) {
        return res.status(403).json({
          success: false,
          message: 'الحساب غير مفعل'
        });
      }
      
      res.json({
        success: true,
        message: 'التوكن صالح',
        data: {
          user: {
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            type: decoded.userType
          }
        }
      });
    } catch (error) {
      if (error.name === 'TokenExpiredError') {
        return res.status(401).json({
          success: false,
          message: 'انتهت صلاحية التوكن'
        });
      }
      
      return res.status(401).json({
        success: false,
        message: 'توكن غير صالح'
      });
    }
  }
);

// تغيير كلمة المرور
router.post('/change-password',
  require('../middleware/auth').verifyToken,
  require('../middleware/validation').validate(require('joi').object({
    current_password: require('joi').string().required(),
    new_password: require('joi').string().min(6).max(128).required()
  })),
  async (req, res) => {
    try {
      const { current_password, new_password } = req.validatedData;
      const { userId, userType } = req.user;
      
      // تحديد الجدول والاستعلام حسب نوع المستخدم
      const tableName = userType === 'customer' ? 'customers' : 'users';
      const query = `SELECT password_hash FROM ${tableName} WHERE id = ?`;
      
      const result = await executeQuery(query, [userId]);
      
      if (!result.success || result.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المستخدم غير موجود'
        });
      }
      
      // التحقق من كلمة المرور الحالية
      const isCurrentPasswordValid = await bcrypt.compare(current_password, result.data[0].password_hash);
      
      if (!isCurrentPasswordValid) {
        return res.status(400).json({
          success: false,
          message: 'كلمة المرور الحالية غير صحيحة'
        });
      }
      
      // تشفير كلمة المرور الجديدة
      const hashedNewPassword = await bcrypt.hash(new_password, 12);
      
      // تحديث كلمة المرور
      const updateQuery = `UPDATE ${tableName} SET password_hash = ?, updated_at = NOW() WHERE id = ?`;
      const updateResult = await executeQuery(updateQuery, [hashedNewPassword, userId]);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث كلمة المرور'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تغيير كلمة المرور بنجاح'
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

// استرداد كلمة المرور (إرسال كود التحقق)
router.post('/forgot-password',
  require('../middleware/validation').validate(require('joi').object({
    email: require('joi').string().email().required(),
    user_type: require('joi').string().valid('customer', 'user').required()
  })),
  async (req, res) => {
    try {
      const { email, user_type } = req.validatedData;
      
      // تحديد الجدول حسب نوع المستخدم
      const tableName = user_type === 'customer' ? 'customers' : 'users';
      const query = `SELECT id, full_name FROM ${tableName} WHERE email = ? AND is_active = 1`;
      
      const result = await executeQuery(query, [email]);
      
      // دائماً نُرجع نجح حتى لو لم يكن الإيميل موجود (لحماية الخصوصية)
      res.json({
        success: true,
        message: 'إذا كان الإيميل مسجل لدينا، ستصلك رسالة تحتوي على تعليمات استرداد كلمة المرور'
      });
      
      // إذا كان الإيميل موجود، يمكن هنا إرسال رسالة أو كود تحقق
      // هذا مجرد مثال، في التطبيق الحقيقي نحتاج خدمة إرسال الإيميلات
      if (result.success && result.data.length > 0) {
        console.log(`Password reset requested for: ${email} (${user_type})`);
        // TODO: إرسال رسالة إيميل أو SMS
      }
      
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