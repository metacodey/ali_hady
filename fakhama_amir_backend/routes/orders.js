const express = require('express');
const router = express.Router();
const { executeQuery, executeTransaction, getPaginatedData } = require('../config/database');
const { validate, validateParams, validateQuery, orderSchemas, commonSchemas } = require('../middleware/validation');
const { verifyToken, checkUserType, verifyCustomer } = require('../middleware/auth');

// دالة لتوليد رقم طلب فريد
const generateOrderNumber = () => {
  const timestamp = Date.now().toString();
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
  return `ORD-${timestamp.slice(-8)}-${random}`;
};

// GET /api/orders - عرض جميع الطلبات (للمشرفين)
router.get('/',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit, search } = req.validatedQuery;
      
      let baseQuery = `
        SELECT 
          o.id, o.order_number, o.total_amount, o.created_at,
          c.full_name as customer_name, c.phone as customer_phone,
          os.name as status, os.color as status_color,
          COUNT(oi.id) as items_count
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN order_items oi ON o.id = oi.order_id
      `;
      
      let countQuery = `
        SELECT COUNT(DISTINCT o.id) as total 
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
      `;
      
      let params = [];
      
      // إضافة البحث إذا كان موجود
      if (search) {
        const searchCondition = ' WHERE (o.order_number LIKE ? OR c.full_name LIKE ? OR c.phone LIKE ?)';
        baseQuery += searchCondition;
        countQuery += searchCondition;
        const searchParam = `%${search}%`;
        params = [searchParam, searchParam, searchParam];
      }
      
      baseQuery += ' GROUP BY o.id ORDER BY o.created_at DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات الطلبات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات الطلبات بنجاح',
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

// GET /api/orders/my - طلبات العميل المسجل دخوله
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
          o.id, o.order_number, o.total_amount, o.created_at,
          os.name as status, os.color as status_color,
          COUNT(oi.id) as items_count
        FROM orders o
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN order_items oi ON o.id = oi.order_id
        WHERE o.customer_id = ?
      `;
      
      const countQuery = 'SELECT COUNT(*) as total FROM orders WHERE customer_id = ?';
      
      const result = await getPaginatedData(
        baseQuery + ' GROUP BY o.id ORDER BY o.created_at DESC',
        countQuery,
        [customerId],
        page,
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد طلباتك'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد طلباتك بنجاح',
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

// GET /api/orders/:id - عرض تفاصيل طلب واحد
router.get('/:id',
  verifyToken,
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { userType, userId } = req.user;
      
      // استعلام تفاصيل الطلب
      let orderQuery = `
        SELECT 
          o.id, o.order_number, o.total_amount, o.customer_notes, o.admin_notes,
          o.created_at, o.updated_at,
          c.full_name as customer_name, c.email as customer_email, 
          c.phone as customer_phone, c.city as customer_city,
          c.street_address as customer_address,
          os.name as status, os.color as status_color
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN order_statuses os ON o.status_id = os.id
        WHERE o.id = ?
      `;
      
      // إذا كان عميل، تأكد من أنه يطلب طلبه فقط
      if (userType === 'customer') {
        orderQuery += ' AND o.customer_id = ?';
      }
      
      const orderParams = userType === 'customer' ? [id, userId] : [id];
      const orderResult = await executeQuery(orderQuery, orderParams);
      
      if (!orderResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات الطلب'
        });
      }
      
      if (orderResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الطلب غير موجود'
        });
      }
      
      // استعلام عناصر الطلب
      const itemsQuery = `
        SELECT 
          oi.id, oi.product_name, oi.quantity, oi.unit_price, oi.total_price,
          p.image as product_image, p.sku as product_sku
        FROM order_items oi
        LEFT JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = ?
        ORDER BY oi.id
      `;
      
      const itemsResult = await executeQuery(itemsQuery, [id]);
      
      if (!itemsResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد عناصر الطلب'
        });
      }
      
      const orderData = {
        ...orderResult.data[0],
        items: itemsResult.data
      };
      
      res.json({
        success: true,
        message: 'تم استرداد تفاصيل الطلب بنجاح',
        data: orderData
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

// POST /api/orders - إنشاء طلب جديد
router.post('/',
  verifyToken,
  checkUserType(['customer']),
  verifyCustomer,
  validate(orderSchemas.create),
  async (req, res) => {
    try {
      const { items, customer_notes } = req.validatedData;
      const customerId = req.user.userId;
      
      // التحقق من وجود المنتجات وحساب الأسعار
      const productIds = items.map(item => item.product_id);
      const placeholders = productIds.map(() => '?').join(',');
      
      const productsQuery = `
        SELECT id, name, price, quantity 
        FROM products 
        WHERE id IN (${placeholders}) AND is_active = 1
      `;
      
      const productsResult = await executeQuery(productsQuery, productIds);
      
      if (!productsResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في التحقق من المنتجات'
        });
      }
      
      const products = productsResult.data;
      const productMap = {};
      products.forEach(product => {
        productMap[product.id] = product;
      });
      
      // التحقق من صحة العناصر وحساب الإجمالي
      let totalAmount = 0;
      const orderItems = [];
      
      for (const item of items) {
        const product = productMap[item.product_id];
        
        if (!product) {
          return res.status(400).json({
            success: false,
            message: `المنتج ${item.product_id} غير موجود أو غير متاح`
          });
        }
        
        if (product.quantity < item.quantity) {
          return res.status(400).json({
            success: false,
            message: `الكمية المطلوبة من ${product.name} غير متاحة. المتاح: ${product.quantity}`
          });
        }
        
        const itemTotal = product.price * item.quantity;
        totalAmount += itemTotal;
        
        orderItems.push({
          product_id: item.product_id,
          product_name: product.name,
          quantity: item.quantity,
          unit_price: product.price,
          total_price: itemTotal
        });
      }
      
      // إنشاء الطلب
      const orderNumber = generateOrderNumber();
      
      const queries = [
        // إدراج الطلب
        {
          query: `
            INSERT INTO orders (customer_id, order_number, total_amount, customer_notes)
            VALUES (?, ?, ?, ?)
          `,
          params: [customerId, orderNumber, totalAmount, customer_notes || null]
        }
      ];
      
      // إدراج عناصر الطلب
      orderItems.forEach(item => {
        queries.push({
          query: `
            INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, total_price)
            VALUES (LAST_INSERT_ID(), ?, ?, ?, ?, ?)
          `,
          params: [item.product_id, item.product_name, item.quantity, item.unit_price, item.total_price]
        });
      });
      
      // تحديث كمية المنتجات
      orderItems.forEach(item => {
        queries.push({
          query: 'UPDATE products SET quantity = quantity - ? WHERE id = ?',
          params: [item.quantity, item.product_id]
        });
      });
      
      const transactionResult = await executeTransaction(queries);
      
      if (!transactionResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء الطلب'
        });
      }
      
      const orderId = transactionResult.data[0].insertId;
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء الطلب بنجاح',
        data: {
          id: orderId,
          order_number: orderNumber,
          total_amount: totalAmount
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

// PUT /api/orders/:id/status - تحديث حالة الطلب (للمشرفين فقط)
router.put('/:id/status',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  validate(orderSchemas.updateStatus),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { status_id, admin_notes } = req.validatedData;
      
      // التحقق من وجود الطلب
      const checkQuery = 'SELECT id, order_number FROM orders WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الطلب غير موجود'
        });
      }
      
      // التحقق من صحة حالة الطلب
      const statusCheckQuery = 'SELECT id, name FROM order_statuses WHERE id = ?';
      const statusCheckResult = await executeQuery(statusCheckQuery, [status_id]);
      
      if (!statusCheckResult.success || statusCheckResult.data.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'حالة الطلب غير صحيحة'
        });
      }
      
      // تحديث حالة الطلب
      const updateQuery = `
        UPDATE orders 
        SET status_id = ?, admin_notes = ?, updated_at = NOW()
        WHERE id = ?
      `;
      
      const updateResult = await executeQuery(updateQuery, [status_id, admin_notes || null, id]);
      
      if (!updateResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في تحديث حالة الطلب'
        });
      }
      
      res.json({
        success: true,
        message: `تم تحديث حالة الطلب ${checkResult.data[0].order_number} إلى ${statusCheckResult.data[0].name}`
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

// DELETE /api/orders/:id - حذف طلب (للمشرفين فقط)
router.delete('/:id',
  verifyToken,
  checkUserType(['user']),
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      
      // التحقق من وجود الطلب
      const checkQuery = 'SELECT id, order_number FROM orders WHERE id = ?';
      const checkResult = await executeQuery(checkQuery, [id]);
      
      if (!checkResult.success || checkResult.data.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'الطلب غير موجود'
        });
      }
      
      // حذف الطلب (سيتم حذف العناصر تلقائياً بسبب CASCADE)
      const deleteQuery = 'DELETE FROM orders WHERE id = ?';
      const deleteResult = await executeQuery(deleteQuery, [id]);
      
      if (!deleteResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في حذف الطلب'
        });
      }
      
      res.json({
        success: true,
        message: `تم حذف الطلب ${checkResult.data[0].order_number} بنجاح`
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

// GET /api/orders/stats - إحصائيات الطلبات
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_orders,
          COUNT(CASE WHEN DATE(created_at) = CURDATE() THEN 1 END) as today_orders,
          COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as week_orders,
          SUM(total_amount) as total_revenue,
          SUM(CASE WHEN DATE(created_at) = CURDATE() THEN total_amount ELSE 0 END) as today_revenue,
          AVG(total_amount) as average_order_value,
          COUNT(CASE WHEN status_id = 1 THEN 1 END) as pending_orders,
          COUNT(CASE WHEN status_id = 5 THEN 1 END) as delivered_orders
        FROM orders
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات الطلبات'
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