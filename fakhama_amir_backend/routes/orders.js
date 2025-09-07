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

// دالة لتحديد حالة الدفع
const getPaymentStatus = (totalAmount, paidAmount) => {
  const paid = parseFloat(paidAmount) || 0;
  const total = parseFloat(totalAmount) || 0;
  
  if (paid === 0) return 'غير مدفوع';
  if (paid >= total) return 'مدفوع بالكامل';
  return 'دفع جزئي';
};

// GET /api/orders - عرض جميع الطلبات مع معلومات الدفع (للمشرفين)
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
          COUNT(DISTINCT oi.id) as items_count,
          COALESCE(payments_summary.paid_amount, 0) as paid_amount,
          o.total_amount - COALESCE(payments_summary.paid_amount, 0) as remaining_amount
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN order_items oi ON o.id = oi.order_id
        LEFT JOIN (
          SELECT 
            order_id,
            SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as paid_amount
          FROM payments 
          GROUP BY order_id
        ) payments_summary ON o.id = payments_summary.order_id
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
      
      baseQuery += ' GROUP BY o.id, payments_summary.paid_amount ORDER BY o.id DESC';
      
      const result = await getPaginatedData(baseQuery, countQuery, params, page, limit);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات الطلبات'
        });
      }
      
      // إضافة معلومات الدفع لكل طلب
      const ordersWithPayments = result.data.map(order => ({
        ...order,
        total_amount: parseFloat(order.total_amount),
        paid_amount: parseFloat(order.paid_amount),
        remaining_amount: parseFloat(order.remaining_amount),
        payment_status: getPaymentStatus(order.total_amount, order.paid_amount),
        payment_percentage: order.total_amount > 0 ? 
          ((order.paid_amount / order.total_amount) * 100).toFixed(1) : 0
      }));
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات الطلبات بنجاح',
        data: ordersWithPayments,
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
// GET /api/orders/incomplete - عرض الطلبات غير المكتملة الدفع (للمشرفين)
router.get('/incomplete',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const baseQuery = `
        SELECT 
          o.id, o.order_number, o.total_amount, o.created_at,
          c.full_name as customer_name, c.phone as customer_phone,
          os.name as status, os.color as status_color,
          COUNT(DISTINCT oi.id) as items_count,
          COALESCE(payments_summary.paid_amount, 0) as paid_amount,
          o.total_amount - COALESCE(payments_summary.paid_amount, 0) as remaining_amount
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN order_items oi ON o.id = oi.order_id
        LEFT JOIN (
          SELECT 
            order_id,
            SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as paid_amount
          FROM payments 
          GROUP BY order_id
        ) payments_summary ON o.id = payments_summary.order_id
        GROUP BY o.id, payments_summary.paid_amount
        HAVING remaining_amount > 0
        ORDER BY remaining_amount DESC, o.created_at DESC
      `;
      
      const result = await executeQuery(baseQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات الطلبات غير المكتملة'
        });
      }
      
      // إضافة معلومات الدفع لكل طلب
      const incompleteOrders = result.data.map(order => ({
        ...order,
        total_amount: parseFloat(order.total_amount),
        paid_amount: parseFloat(order.paid_amount),
        remaining_amount: parseFloat(order.remaining_amount),
        payment_status: getPaymentStatus(order.total_amount, order.paid_amount),
        payment_percentage: order.total_amount > 0 ? 
          ((order.paid_amount / order.total_amount) * 100).toFixed(1) : 0
      }));
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات الطلبات غير المكتملة بنجاح',
        data: incompleteOrders,
        total_orders: incompleteOrders.length,
        total_outstanding: incompleteOrders.reduce((sum, order) => sum + order.remaining_amount, 0)
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
// GET /api/orders/status - حالات الطلبات
router.get('/status',
  async (req, res) => {
    try {
      const query = "SELECT * FROM `order_statuses` ORDER BY sort_order;";
      const result = await executeQuery(query);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد حالات الطلبات'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد حالات الطلبات بنجاح',
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

// GET /api/orders/customers - قائمة العملاء
router.get('/customers',
  async (req, res) => {
    try {
      const query = "SELECT id, full_name FROM `customers` WHERE is_active = 1 ORDER BY full_name;";
      const result = await executeQuery(query);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد بيانات العملاء'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد بيانات العملاء بنجاح',
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

// GET /api/orders/my - طلبات العميل المسجل دخوله مع معلومات الدفع
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
          COUNT(DISTINCT oi.id) as items_count,
          COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as paid_amount,
          o.total_amount - COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as remaining_amount
        FROM orders o
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN order_items oi ON o.id = oi.order_id
        LEFT JOIN payments p ON o.id = p.order_id
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
      
      // إضافة معلومات الدفع
      const ordersWithPayments = result.data.map(order => ({
        ...order,
        total_amount: parseFloat(order.total_amount),
        paid_amount: parseFloat(order.paid_amount),
        remaining_amount: parseFloat(order.remaining_amount),
        payment_status: getPaymentStatus(order.total_amount, order.paid_amount),
        payment_percentage: order.total_amount > 0 ? 
          ((order.paid_amount / order.total_amount) * 100).toFixed(1) : 0
      }));
      
      res.json({
        success: true,
        message: 'تم استرداد طلباتك بنجاح',
        data: ordersWithPayments,
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

// GET /api/orders/:id - عرض تفاصيل طلب واحد مع تفاصيل الدفعات
router.get('/:id',
  verifyToken,
  validateParams(commonSchemas.id),
  async (req, res) => {
    try {
      const { id } = req.validatedParams;
      const { userType, userId } = req.user;
      
      // استعلام تفاصيل الطلب مع معلومات الدفع
      let orderQuery = `
        SELECT 
          o.id, o.order_number, o.total_amount, o.customer_notes, o.admin_notes,
          o.created_at, o.updated_at,
          c.id as customer_id, c.full_name as customer_name, c.email as customer_email, 
          c.phone as customer_phone, c.city as customer_city,
          c.street_address as customer_address,
          os.name as status, os.color as status_color,
          COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as paid_amount,
          o.total_amount - COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as remaining_amount
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN payments p ON o.id = p.order_id
        WHERE o.id = ?
      `;
      
      // إذا كان عميل، تأكد من أنه يطلب طلبه فقط
      if (userType === 'customer') {
        orderQuery += ' AND o.customer_id = ?';
      }
      
      orderQuery += ' GROUP BY o.id';
      
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
      
      // استعلام تفاصيل الدفعات
      const paymentsQuery = `
        SELECT 
          id, amount, payment_method, status, notes, payment_date, created_at
        FROM payments 
        WHERE order_id = ?
        ORDER BY created_at DESC
      `;
      
      const paymentsResult = await executeQuery(paymentsQuery, [id]);
      
      if (!paymentsResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد تفاصيل الدفعات'
        });
      }
      
      const order = orderResult.data[0];
      
      const orderData = {
        ...order,
        total_amount: parseFloat(order.total_amount),
        paid_amount: parseFloat(order.paid_amount),
        remaining_amount: parseFloat(order.remaining_amount),
        payment_status: getPaymentStatus(order.total_amount, order.paid_amount),
        payment_percentage: order.total_amount > 0 ? 
          ((order.paid_amount / order.total_amount) * 100).toFixed(1) : 0,
        items: itemsResult.data.map(item => ({
          ...item,
          unit_price: parseFloat(item.unit_price),
          total_price: parseFloat(item.total_price)
        })),
        payments: paymentsResult.data.map(payment => ({
          ...payment,
          amount: parseFloat(payment.amount)
        }))
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
// POST /api/orders - إنشاء طلب جديد (النسخة المُصححة)
router.post('/',
  verifyToken,
  checkUserType(['user']),
  validate(orderSchemas.create),
  async (req, res) => {
    try {
      const { items, customer_notes, customer_id } = req.validatedData;
      
      // التحقق من وجود العميل
      const customerQuery = 'SELECT id, full_name FROM customers WHERE id = ? AND is_active = 1';
      const customerResult = await executeQuery(customerQuery, [customer_id]);
      
      if (!customerResult.success || customerResult.data.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'العميل غير موجود أو غير نشط'
        });
      }
      
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
      
      // إنشاء الطلب - أولاً إدراج الطلب للحصول على ID
      const orderNumber = generateOrderNumber();
      
      const insertOrderQuery = `
        INSERT INTO orders (customer_id, order_number, total_amount, customer_notes)
        VALUES (?, ?, ?, ?)
      `;
      
      const orderResult = await executeQuery(insertOrderQuery, [
        customer_id, 
        orderNumber, 
        totalAmount, 
        customer_notes || null
      ]);
      
      if (!orderResult.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في إنشاء الطلب'
        });
      }
      
      const orderId = orderResult.data.insertId;
      
      // ثانياً: إدراج عناصر الطلب وتحديث المخزون
      const queries = [];
      
      // إدراج عناصر الطلب
      orderItems.forEach(item => {
        queries.push({
          query: `
            INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, total_price)
            VALUES (?, ?, ?, ?, ?, ?)
          `,
          params: [orderId, item.product_id, item.product_name, item.quantity, item.unit_price, item.total_price]
        });
      });
      
      // تحديث كمية المنتجات
      // orderItems.forEach(item => {
      //   queries.push({
      //     query: 'UPDATE products SET quantity = quantity - ? WHERE id = ?',
      //     params: [item.quantity, item.product_id]
      //   });
      // });
      
      // تنفيذ العمليات المتبقية
      if (queries.length > 0) {
        const transactionResult = await executeTransaction(queries);
        
        if (!transactionResult.success) {
          // في حالة فشل إدراج العناصر، احذف الطلب
          await executeQuery('DELETE FROM orders WHERE id = ?', [orderId]);
          return res.status(500).json({
            success: false,
            message: 'خطأ في إضافة عناصر الطلب'
          });
        }
      }
      
      res.status(201).json({
        success: true,
        message: 'تم إنشاء الطلب بنجاح',
        data: {
          id: orderId,
          order_number: orderNumber,
          total_amount: totalAmount,
          customer_name: customerResult.data[0].full_name
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
      
      // حذف الطلب (سيتم حذف العناصر والدفعات تلقائياً بسبب CASCADE)
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

// GET /api/orders/dashboard/stats - إحصائيات الطلبات مع معلومات الدفع
router.get('/dashboard/stats',
  verifyToken,
  checkUserType(['user']),
  async (req, res) => {
    try {
      const statsQuery = `
        SELECT 
          COUNT(*) as total_orders,
          COUNT(CASE WHEN DATE(o.created_at) = CURDATE() THEN 1 END) as today_orders,
          COUNT(CASE WHEN DATE(o.created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as week_orders,
          SUM(o.total_amount) as total_revenue,
          SUM(CASE WHEN DATE(o.created_at) = CURDATE() THEN o.total_amount ELSE 0 END) as today_revenue,
          AVG(o.total_amount) as average_order_value,
          COUNT(CASE WHEN o.status_id = 1 THEN 1 END) as pending_orders,
          COUNT(CASE WHEN o.status_id = 5 THEN 1 END) as delivered_orders,
          SUM(COALESCE(p.total_paid, 0)) as total_collected,
          SUM(o.total_amount) - SUM(COALESCE(p.total_paid, 0)) as total_outstanding,
          COUNT(CASE WHEN COALESCE(p.total_paid, 0) = 0 THEN 1 END) as unpaid_orders,
          COUNT(CASE WHEN COALESCE(p.total_paid, 0) > 0 AND COALESCE(p.total_paid, 0) < o.total_amount THEN 1 END) as partially_paid_orders,
          COUNT(CASE WHEN COALESCE(p.total_paid, 0) >= o.total_amount THEN 1 END) as fully_paid_orders
        FROM orders o
        LEFT JOIN (
          SELECT 
            order_id,
            SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as total_paid
          FROM payments 
          GROUP BY order_id
        ) p ON o.id = p.order_id
      `;
      
      const result = await executeQuery(statsQuery);
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد إحصائيات الطلبات'
        });
      }
      
      const stats = result.data[0];
      
      // تنسيق الإحصائيات
      const formattedStats = {
        orders: {
          total: stats.total_orders,
          today: stats.today_orders,
          this_week: stats.week_orders,
          pending: stats.pending_orders,
          delivered: stats.delivered_orders
        },
        revenue: {
          total: parseFloat(stats.total_revenue || 0),
          today: parseFloat(stats.today_revenue || 0),
          average_order_value: parseFloat(stats.average_order_value || 0),
          collected: parseFloat(stats.total_collected || 0),
          outstanding: parseFloat(stats.total_outstanding || 0),
          collection_rate: stats.total_revenue > 0 ? 
            ((stats.total_collected / stats.total_revenue) * 100).toFixed(1) : 0
        },
        payments: {
          unpaid_orders: stats.unpaid_orders,
          partially_paid_orders: stats.partially_paid_orders,
          fully_paid_orders: stats.fully_paid_orders
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

// GET /api/orders/unpaid - قائمة الطلبات غير المدفوعة
router.get('/unpaid/list',
  verifyToken,
  checkUserType(['user']),
  validateQuery(commonSchemas.pagination),
  async (req, res) => {
    try {
      const { page, limit } = req.validatedQuery;
      
      const baseQuery = `
        SELECT 
          o.id, o.order_number, o.total_amount, o.created_at,
          c.full_name as customer_name, c.phone as customer_phone,
          os.name as status, os.color as status_color,
          COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as paid_amount,
          o.total_amount - COALESCE(SUM(CASE WHEN p.status = 'paid' THEN p.amount ELSE 0 END), 0) as remaining_amount
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN order_statuses os ON o.status_id = os.id
        LEFT JOIN payments p ON o.id = p.order_id
        GROUP BY o.id
        HAVING remaining_amount > 0
      `;
      
      const countQuery = `
        SELECT COUNT(*) as total FROM (
          ${baseQuery}
        ) as unpaid_orders
      `;
      
      const result = await getPaginatedData(
        baseQuery + ' ORDER BY remaining_amount DESC, o.created_at DESC', 
        countQuery, 
        [], 
        page, 
        limit
      );
      
      if (!result.success) {
        return res.status(500).json({
          success: false,
          message: 'خطأ في استرداد قائمة الطلبات غير المدفوعة'
        });
      }
      
      res.json({
        success: true,
        message: 'تم استرداد قائمة الطلبات غير المدفوعة بنجاح',
        data: result.data.map(order => ({
          ...order,
          total_amount: parseFloat(order.total_amount),
          paid_amount: parseFloat(order.paid_amount),
          remaining_amount: parseFloat(order.remaining_amount),
          payment_status: getPaymentStatus(order.total_amount, order.paid_amount)
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