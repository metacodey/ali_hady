const express = require('express');
const router = express.Router();
const { executeQuery, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, productSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType } = require('../middleware/auth');

// GET /api/products - عرض جميع المنتجات
router.get('/',
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          p.id, p.name, p.description, p.sku, p.price, p.quantity,
          p.image, p.is_active, p.created_at,
          pc.name as category_name
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        WHERE p.is_active = 1
      `;
      
      let countQuery = `
        SELECT COUNT(*) as total 
        FROM products p 
        WHERE p.is_active = 1
      `;
      
      let params = [];
      
      // إضافة البحث إذا كان موجود
      if (search) {
        const searchCondition = ' AND (p.name LIKE ? OR p.description LIKE ? OR p.sku LIKE ?)';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam, searchParam];
      }
      
      baseQuery += ' ORDER BY p.created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات المنتجات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات المنتجات بنجاح',
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

// GET /api/products/admin - عرض جميع المنتجات للإدارة
router.get('/admin',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          p.id, p.name, p.description, p.sku, p.price, p.quantity,
          p.image, p.is_active, p.created_at, p.updated_at,
          pc.name as category_name
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM products p';
      let params = [];
      
      if (search) {
        const searchCondition = ' WHERE (p.name LIKE ? OR p.description LIKE ? OR p.sku LIKE ?)';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam, searchParam];
      }
      
      baseQuery += ' ORDER BY p.created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات المنتجات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات المنتجات بنجاح',
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

// GET /api/products/:id - عرض منتج واحد
router.get('/:id',
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      const query = `
        SELECT 
          p.id, p.name, p.description, p.sku, p.price, p.quantity,
          p.image, p.is_active, p.created_at, p.updated_at,
          pc.name as category_name, pc.id as category_id
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        WHERE p.id = ?
      `;
      
      const result = await executeQuery(query, [id]);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات المنتج'
        });
      }
      
      if (result.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المنتج غير موجود'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات المنتج بنجاح',
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

// POST /api/products - إنشاء منتج جديد
router.post('/',
  verifyToken,
  checkUserType(['user']),
  validate(productSchemas.create),
  async (req, res) => {
    try {
      const productData = req.validatedData;
      
      // التحقق من عدم وجود SKU مكرر إذا تم تقديمه
      if (productData.sku) {
        const checkQuery = 'SELECT id FROM products WHERE sku = ?';
        const checkResult = await executeQuery(checkQuery, [productData.sku]);
        
        if (!checkResult.success) {
          return res.status(500).json({
            success: false,
            message: 'خطأ في التحقق من البيانات'
          });
        }
        
        if (checkResult.data.length > 0) {
          return res.status(409).json({
            success: false,
            message: 'رمز المنتج (SKU) موجود مسبقاً'
          });
        }
      }
      
      // إدراج المنتج الجديد
      const insertQuery = `
        INSERT INTO products (
          category_id, name, description, sku, price, quantity, image
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      `;
      
      const insertParams = [
        productData.category_id || null,
        productData.name,
        productData.description || null,
        productData.sku || null,
        productData.price,
        productData.quantity,
        productData.image || null
      ];
      
      const insertResult = await executeQuery(insertQuery, insertParams);
      
      if (!insertResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء المنتج'
        });
      }
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء المنتج بنجاح',
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

// PUT /api/products/:id - تحديث منتج
router.put('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  validate(productSchemas.update),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const updateData = req.validatedData;
      
      // التحقق من وجود المنتج
      const checkQuery = 'SELECT id, name FROM products WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المنتج غير موجود'
        });
      }
      
      // التحقق من عدم تكرار SKU إذا تم تحديثه
      if (updateData.sku) {
        const skuCheckQuery = 'SELECT id FROM products WHERE sku = ? AND id != ?';
        const skuCheckResult = await executeQuery(skuCheckQuery, [updateData.sku, id]);
        
        if (!skuCheckResult.success) {
          return res.status(500).json({
            success: false,
            message: 'خطأ في التحقق من البيانات'
          });
        }
        
        if (skuCheckResult.data.length > 0) {
          return res.status(409).json({
            success: false,
            message: 'رمز المنتج (SKU) موجود مسبقاً'
          });
        }
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
      
      const updateQuery = `UPDATE products SET ${updateFields.join(', ')} WHERE id = ?`;
      const updateResult = await executeQuery(updateQuery, updateParams);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث المنتج'
        });
      }
      
      res.json({
        success: true,
        message: 'تم تحديث المنتج بنجاح'
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

// DELETE /api/products/:id - حذف منتج
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      // التحقق من وجود المنتج
      const checkQuery = 'SELECT id, name FROM products WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'المنتج غير موجود'
        });
      }
      
      // التحقق من عدم وجود طلبات مرتبطة بالمنتج
      const orderCheckQuery = 'SELECT COUNT(*) as count FROM order_items WHERE product_id = ?';
      const orderCheckResult = await executeQuery(orderCheckQuery, [id]);
      
      if (!orderCheckResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في التحقق من الطلبات المرتبطة'
        });
      }
      
      if (orderCheckResult.data[0].count > 0) {
        return res.status(409).json({
          success: false,
          message: 'لا يمكن حذف المنتج لوجود طلبات مرتبطة به'
        });
      }
      
      // حذف المنتج
      const deleteQuery = 'DELETE FROM products WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف المنتج'
        });
      }
      
      res.json({
        success: true,
        message: `تم حذف المنتج ${checkResult.data[0].name} بنجاح`
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

// GET /api/products/categories - عرض فئات المنتجات
router.get('/categories/list',
  async (req, res) => {
    try {
      const query = `
        SELECT id, name, description, image, sort_order
        FROM product_categories 
        WHERE is_active = 1 
        ORDER BY sort_order, name
      `;
      
      const result = await executeQuery(query);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد فئات المنتجات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد فئات المنتجات بنجاح',
        data: result.data
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

// GET /api/products/stats - إحصائيات المنتجات
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_products,
          COUNT(CASE WHEN is_active = 1 THEN 1 END) as active_products,
          COUNT(CASE WHEN quantity = 0 THEN 1 END) as out_of_stock,
          COUNT(CASE WHEN quantity > 0 AND quantity <= 5 THEN 1 END) as low_stock,
          AVG(price) as average_price,
          SUM(quantity) as total_quantity
        FROM products
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات المنتجات'
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

// GET /api/products/search - البحث المتقدم في المنتجات
router.get('/search/advanced',
  validateQuery(require('joi').object({
    q: require('joi').string().min(1).max(100).optional(),
    category: require('joi').number().integer().positive().optional(),
    min_price: require('joi').number().positive().optional(),
    max_price: require('joi').number().positive().optional(),
    in_stock: require('joi').boolean().optional(),
    page: require('joi').number().integer().positive().optional().default(1),
    limit: require('joi').number().integer().min(1).max(100).optional().default(10)
  })),
  async (req, res) => {
    try {
      const { q, category, min_price, max_price, in_stock, page, limit } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          p.id, p.name, p.description, p.sku, p.price, p.quantity,
          p.image, p.created_at, pc.name as category_name
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        WHERE p.is_active = 1
      `;
      
      let countQuery = `
        SELECT COUNT(*) as total 
        FROM products p 
        WHERE p.is_active = 1
      `;
      
      let params = [];
      let conditions = [];
      
      if (q) {
        conditions.push('(p.name LIKE ? OR p.description LIKE ?)');
        params.push(`%${q}%`, `%${q}%`);
      }
      
      if (category) {
        conditions.push('p.category_id = ?');
        params.push(category);
      }
      
      if (min_price) {
        conditions.push('p.price >= ?');
        params.push(min_price);
      }
      
      if (max_price) {
        conditions.push('p.price <= ?');
        params.push(max_price);
      }
      
      if (in_stock !== undefined) {
        if (in_stock) {
          conditions.push('p.quantity > 0');
        } else {
          conditions.push('p.quantity = 0');
        }
      }
      
      if (conditions.length > 0) {
        const whereClause = ' AND ' + conditions.join(' AND ');
        baseQuery += whereClause;
        countQuery += whereClause;
      }
      
      baseQuery += ' ORDER BY p.created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في البحث في المنتجات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم البحث في المنتجات بنجاح',
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

module.exports = router;