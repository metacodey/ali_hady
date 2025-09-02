const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType } = require('../middleware/auth');
const Joi = require('joi');

// Schemas للمستخدمين
const userSchemas = {
  create: Joi.object({
    username: Joi.string().alphanum().min(3).max(50).required(),
    email: Joi.string().email().max(100).required(),
    password: Joi.string().min(6).max(128).required(),
    full_name: Joi.string().min(2).max(100).required(),
    phone: Joi.string().pattern(/^\+966[0-9]{9}$/).optional()
  }),
  
  update: Joi.object({
    full_name: Joi.string().min(2).max(100).optional(),
    phone: Joi.string().pattern(/^\+966[0-9]{9}$/).optional(),
    is_active: Joi.boolean().optional()
  })
};

// GET /api/users - عرض جميع المستخدمين
router.get('/',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          id, username, email, full_name, phone, is_active,
          created_at, updated_at, last_login
        FROM users
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM users';
      let params = [];
      
      if (search) {
        const searchCondition = ' WHERE full_name LIKE ? OR email LIKE ? OR username LIKE ?';
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
          message: 'خطأ في استرداد بيانات المستخدمين'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات المستخدمين بنجاح',
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

// GET /api/users/profile - الملف الشخصي للمستخدم المسجل دخوله
router.get('/profile',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const userId = req.user.userId;
      
      const query = `
        SELECT id, username, email, full_name, phone, is_active, created_at, last_login
        FROM users 
        WHERE id = ?
      `;
      
      const result = await executeQuery(query, [userId]);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد الملف الشخصي'
        });
      }
      
      if (result.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المستخدم غير موجود'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد الملف الشخصي بنجاح',
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

// GET /api/users/:id - عرض مستخدم واحد
router.get('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      const query = `
        SELECT 
          id, username, email, full_name, phone, is_active,
          created_at, updated_at, last_login
        FROM users 
        WHERE id = ?
      `;
      
      const result = await executeQuery(query, [id]);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات المستخدم'
        });
      }
      
      if (result.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المستخدم غير موجود'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات المستخدم بنجاح',
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

// POST /api/users - إنشاء مستخدم جديد
router.post('/',
  verifyToken,
  checkUserType(['user']),
  validate(userSchemas.create),
  async (req, res) => {
    try {
      const userData = req.validatedData;
      
      // التحقق من عدم وجود اسم المستخدم أو البريد مسبقاً
      const checkQuery = 'SELECT id FROM users WHERE username = ? OR email = ?';
      const checkResult = await executeQuery(checkQuery, [userData.username, userData.email]);
      
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
      const hashedPassword = await bcrypt.hash(userData.password, 12);
      
      // إدراج المستخدم الجديد
      const insertQuery = `
        INSERT INTO users (username, email, password_hash, full_name, phone)
        VALUES (?, ?, ?, ?, ?)
      `;
      
      const insertParams = [
        userData.username,
        userData.email,
        hashedPassword,
        userData.full_name,
        userData.phone || null
      ];
      
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء المستخدم'
        });
      }
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء المستخدم بنجاح',
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

// PUT /api/users/:id - تحديث بيانات المستخدم
router.put('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  validate(userSchemas.update),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const updateData = req.validatedData;
      
      // التحقق من وجود المستخدم
      const checkQuery = 'SELECT id, full_name FROM users WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المستخدم غير موجود'
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
      
      const updateQuery = `UPDATE users SET ${updateFields.join(', ')} WHERE id = ?`;
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث بيانات المستخدم'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تحديث بيانات المستخدم بنجاح'
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

// DELETE /api/users/:id - حذف مستخدم
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const currentUserId = req.user.userId;
      
      // منع المستخدم من حذف نفسه
      if (parseInt(id) === currentUserId) {
        return res.status(400).json({
          success: false,
          message: 'لا يمكنك حذف حسابك الخاص'
        });
      }
      
      // التحقق من وجود المستخدم
      const checkQuery = 'SELECT id, full_name FROM users WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المستخدم غير موجود'
        });
      }
      
      // حذف المستخدم
      const deleteQuery = 'DELETE FROM users WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف المستخدم'
        });
      }
      
      res.json({
        success: true,
        message: `تم حذف المستخدم ${checkResult.data[0].full_name} بنجاح`
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

// PUT /api/users/profile - تحديث الملف الشخصي
router.put('/profile/update',
  verifyToken,
  checkUserType(['user']),
  validate(Joi.object({
    full_name: Joi.string().min(2).max(100).optional(),
    phone: Joi.string().pattern(/^\+966[0-9]{9}$/).optional()
  })),
  async (req, res) => {
    try {
      const userId = req.user.userId;
      const updateData = req.validatedData;
      
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
      updateParams.push(userId);
      
      const updateQuery = `UPDATE users SET ${updateFields.join(', ')} WHERE id = ?`;
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث الملف الشخصي'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تحديث الملف الشخصي بنجاح'
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