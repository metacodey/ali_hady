# 🔗 دليل APIs الشامل - نظام إدارة العملاء والطلبات

## 🏠 الخادم الأساسي
```
Base URL: http://localhost:3000
```

---

## 🔐 1. APIs المصادقة (Authentication)

### 1.1 تسجيل دخول العميل
```http
POST /api/auth/customer/login
Content-Type: application/json

Body:
{
  "email": "ahmed@example.com",
  "password": "password123"
}

Response:
{
  "success": true,
  "message": "تم تسجيل الدخول بنجاح",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "email": "ahmed@example.com",
      "full_name": "أحمد محمد علي",
      "type": "customer"
    }
  }
}
```

### 1.2 تسجيل دخول المستخدم/المشرف
```http
POST /api/auth/user/login
Content-Type: application/json

Body:
{
  "email": "admin@company.com",
  "password": "admin123"
}

Response:
{
  "success": true,
  "message": "تم تسجيل الدخول بنجاح",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "email": "admin@company.com",
      "full_name": "مدير النظام",
      "type": "user"
    }
  }
}
```

### 1.3 تسجيل عميل جديد
```http
POST /api/auth/customer/register
Content-Type: application/json

Body:
{
  "username": "ahmed123",
  "email": "ahmed@example.com",
  "password": "password123",
  "full_name": "أحمد محمد علي",
  "phone": "+966501234567",
  "city": "الرياض",
  "street_address": "حي النخيل - شارع الملك فهد",
  "country": "السعودية",
  "latitude": 24.7136,
  "longitude": 46.6753
}
```

### 1.4 التحقق من صحة التوكن
```http
GET /api/auth/verify
Authorization: Bearer <token>

Response:
{
  "success": true,
  "message": "التوكن صالح",
  "data": {
    "user": {
      "id": 1,
      "email": "ahmed@example.com",
      "full_name": "أحمد محمد علي",
      "type": "customer"
    }
  }
}
```

### 1.5 تغيير كلمة المرور
```http
POST /api/auth/change-password
Authorization: Bearer <token>
Content-Type: application/json

Body:
{
  "current_password": "oldPassword123",
  "new_password": "newPassword456"
}
```

### 1.6 استرداد كلمة المرور
```http
POST /api/auth/forgot-password
Content-Type: application/json

Body:
{
  "email": "ahmed@example.com",
  "user_type": "customer"  // أو "user"
}
```

---

## 👥 2. APIs العملاء (Customers)

### 2.1 عرض جميع العملاء (للمشرفين)
```http
GET /api/customers
Authorization: Bearer <user_token>

Query Parameters:
- page: رقم الصفحة (افتراضي: 1)
- limit: عدد العناصر في الصفحة (افتراضي: 10)
- search: نص البحث (اختياري)

مثال:
GET /api/customers?page=1&limit=20&search=أحمد

Response:
{
  "success": true,
  "message": "تم استرداد بيانات العملاء بنجاح",
  "data": [
    {
      "id": 1,
      "username": "ahmed123",
      "email": "ahmed@example.com",
      "full_name": "أحمد محمد علي",
      "phone": "+966501234567",
      "city": "الرياض",
      "is_active": true,
      "created_at": "2025-01-01T10:00:00Z"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 50,
    "itemsPerPage": 10,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

### 2.2 عرض عميل واحد
```http
GET /api/customers/:id
Authorization: Bearer <user_token>

مثال:
GET /api/customers/1

Response:
{
  "success": true,
  "message": "تم استرداد بيانات العميل بنجاح",
  "data": {
    "id": 1,
    "username": "ahmed123",
    "email": "ahmed@example.com",
    "full_name": "أحمد محمد علي",
    "phone": "+966501234567",
    "city": "الرياض",
    "country": "السعودية",
    "street_address": "حي النخيل - شارع الملك فهد",
    "latitude": 24.7136,
    "longitude": 46.6753,
    "is_active": true,
    "created_at": "2025-01-01T10:00:00Z"
  }
}
```

### 2.3 إنشاء عميل جديد
```http
POST /api/customers
Content-Type: application/json

Body:
{
  "username": "sara123",
  "email": "sara@example.com",
  "password": "password123",
  "full_name": "سارة أحمد محمد",
  "phone": "+966502345678",
  "city": "جدة",
  "street_address": "حي الصفا - شارع التحلية",
  "country": "السعودية",
  "latitude": 21.5428,
  "longitude": 39.1728
}
```

### 2.4 تحديث بيانات العميل
```http
PUT /api/customers/:id
Authorization: Bearer <token>
Content-Type: application/json

Body:
{
  "full_name": "أحمد محمد علي المحدث",
  "phone": "+966501111111",
  "city": "الدمام",
  "street_address": "حي الفيصلية - طريق الملك عبدالعزيز"
}
```

### 2.5 حذف عميل
```http
DELETE /api/customers/:id
Authorization: Bearer <user_token>

مثال:
DELETE /api/customers/5
```

### 2.6 طلبات عميل معين
```http
GET /api/customers/:id/orders
Authorization: Bearer <token>

Query Parameters:
- page: رقم الصفحة
- limit: عدد العناصر

مثال:
GET /api/customers/1/orders?page=1&limit=5
```

### 2.7 إحصائيات العملاء
```http
GET /api/customers/dashboard/stats
Authorization: Bearer <user_token>

Response:
{
  "success": true,
  "data": {
    "total_customers": 150,
    "active_customers": 140,
    "new_today": 5,
    "new_this_week": 25
  }
}
```

---

## 📦 3. APIs المنتجات (Products)

### 3.1 عرض جميع المنتجات (للعامة)
```http
GET /api/products

Query Parameters:
- page: رقم الصفحة (افتراضي: 1)
- limit: عدد العناصر (افتراضي: 10)
- search: نص البحث (اختياري)

مثال:
GET /api/products?page=1&limit=12&search=هاتف

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "هاتف ذكي سامسونج",
      "description": "هاتف ذكي بمواصفات عالية",
      "sku": "PHONE001",
      "price": 2500.00,
      "quantity": 10,
      "image": "phone001.jpg",
      "is_active": true,
      "category_name": "إلكترونيات"
    }
  ],
  "pagination": { ... }
}
```

### 3.2 عرض المنتجات للإدارة
```http
GET /api/products/admin
Authorization: Bearer <user_token>

Query Parameters:
- page, limit, search (نفس الأعلى)
```

### 3.3 عرض منتج واحد
```http
GET /api/products/:id

مثال:
GET /api/products/1

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "name": "هاتف ذكي سامسونج",
    "description": "هاتف ذكي بمواصفات عالية مع كاميرا 108 ميجا بكسل",
    "sku": "PHONE001",
    "price": 2500.00,
    "quantity": 10,
    "image": "phone001.jpg",
    "is_active": true,
    "category_name": "إلكترونيات",
    "category_id": 1
  }
}
```

### 3.4 إنشاء منتج جديد
```http
POST /api/products
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "category_id": 1,
  "name": "لابتوب أبل ماك بوك",
  "description": "لابتوب للمحترفين مع معالج M2",
  "sku": "LAP002",
  "price": 8500.00,
  "quantity": 5,
  "image": "macbook_m2.jpg"
}
```

### 3.5 تحديث منتج
```http
PUT /api/products/:id
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "name": "لابتوب أبل ماك بوك برو M2",
  "price": 9000.00,
  "quantity": 8,
  "is_active": true
}
```

### 3.6 حذف منتج
```http
DELETE /api/products/:id
Authorization: Bearer <user_token>

مثال:
DELETE /api/products/5
```

### 3.7 البحث المتقدم في المنتجات
```http
GET /api/products/search/advanced

Query Parameters:
- q: نص البحث
- category: معرف الفئة
- min_price: أقل سعر
- max_price: أعلى سعر
- in_stock: متوفر في المخزن (true/false)
- page: رقم الصفحة
- limit: عدد العناصر

مثال:
GET /api/products/search/advanced?q=هاتف&category=1&min_price=1000&max_price=3000&in_stock=true
```

### 3.8 عرض فئات المنتجات
```http
GET /api/products/categories/list

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "إلكترونيات",
      "description": "أجهزة إلكترونية ومعدات تقنية",
      "image": "electronics.jpg",
      "sort_order": 1
    }
  ]
}
```

### 3.9 إحصائيات المنتجات
```http
GET /api/products/dashboard/stats
Authorization: Bearer <user_token>

Response:
{
  "success": true,
  "data": {
    "total_products": 250,
    "active_products": 230,
    "out_of_stock": 15,
    "low_stock": 25,
    "average_price": 1250.50,
    "total_quantity": 5000
  }
}
```

---

## 🛒 4. APIs الطلبات (Orders)

### 4.1 عرض جميع الطلبات (للمشرفين)
```http
GET /api/orders
Authorization: Bearer <user_token>

Query Parameters:
- page, limit, search

مثال:
GET /api/orders?page=1&limit=15&search=ORD-12345

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "order_number": "ORD-20250101-001",
      "total_amount": 3500.00,
      "created_at": "2025-01-01T12:00:00Z",
      "customer_name": "أحمد محمد علي",
      "customer_phone": "+966501234567",
      "status": "pending",
      "status_color": "#ffc107",
      "items_count": 3
    }
  ],
  "pagination": { ... }
}
```

### 4.2 طلبات العميل المسجل دخوله
```http
GET /api/orders/my
Authorization: Bearer <customer_token>

Query Parameters:
- page, limit

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "order_number": "ORD-20250101-001",
      "total_amount": 3500.00,
      "created_at": "2025-01-01T12:00:00Z",
      "status": "confirmed",
      "status_color": "#17a2b8",
      "items_count": 2
    }
  ]
}
```

### 4.3 تفاصيل طلب واحد
```http
GET /api/orders/:id
Authorization: Bearer <token>

مثال:
GET /api/orders/1

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "order_number": "ORD-20250101-001",
    "total_amount": 3500.00,
    "customer_notes": "توصيل سريع",
    "admin_notes": "طلب مؤكد",
    "created_at": "2025-01-01T12:00:00Z",
    "customer_name": "أحمد محمد علي",
    "customer_email": "ahmed@example.com",
    "customer_phone": "+966501234567",
    "customer_city": "الرياض",
    "status": "confirmed",
    "status_color": "#17a2b8",
    "items": [
      {
        "id": 1,
        "product_name": "هاتف ذكي سامسونج",
        "quantity": 1,
        "unit_price": 2500.00,
        "total_price": 2500.00,
        "product_image": "phone001.jpg",
        "product_sku": "PHONE001"
      },
      {
        "id": 2,
        "product_name": "سماعات بلوتوث",
        "quantity": 2,
        "unit_price": 500.00,
        "total_price": 1000.00,
        "product_image": "headphones.jpg",
        "product_sku": "HEAD001"
      }
    ]
  }
}
```

### 4.4 إنشاء طلب جديد
```http
POST /api/orders
Authorization: Bearer <customer_token>
Content-Type: application/json

Body:
{
  "items": [
    {
      "product_id": 1,
      "quantity": 2
    },
    {
      "product_id": 3,
      "quantity": 1
    }
  ],
  "customer_notes": "أرجو التوصيل في المساء"
}

Response:
{
  "success": true,
  "message": "تم إنشاء الطلب بنجاح",
  "data": {
    "id": 15,
    "order_number": "ORD-20250102-015",
    "total_amount": 4200.00
  }
}
```

### 4.5 تحديث حالة الطلب
```http
PUT /api/orders/:id/status
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "status_id": 3,  // معرف الحالة الجديدة
  "admin_notes": "تم شحن الطلب مع شركة التوصيل"
}
```

### 4.6 حذف طلب
```http
DELETE /api/orders/:id
Authorization: Bearer <user_token>

مثال:
DELETE /api/orders/25
```

### 4.7 إحصائيات الطلبات
```http
GET /api/orders/dashboard/stats
Authorization: Bearer <user_token>

Response:
{
  "success": true,
  "data": {
    "total_orders": 500,
    "today_orders": 15,
    "week_orders": 85,
    "total_revenue": 125000.00,
    "today_revenue": 3500.00,
    "average_order_value": 850.50,
    "pending_orders": 25,
    "delivered_orders": 400
  }
}
```

---

## 💳 5. APIs الدفعات (Payments)

### 5.1 عرض جميع الدفعات
```http
GET /api/payments
Authorization: Bearer <user_token>

Query Parameters:
- page, limit, search

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "amount": 2500.00,
      "payment_method": "نقداً",
      "status": "paid",
      "payment_date": "2025-01-01T14:00:00Z",
      "created_at": "2025-01-01T12:30:00Z",
      "order_number": "ORD-20250101-001",
      "customer_name": "أحمد محمد علي"
    }
  ]
}
```

### 5.2 دفعات طلب معين
```http
GET /api/payments/order/:orderId
Authorization: Bearer <token>

مثال:
GET /api/payments/order/1

Response:
{
  "success": true,
  "data": {
    "order": {
      "id": 1,
      "order_number": "ORD-20250101-001",
      "customer_name": "أحمد محمد علي"
    },
    "payments": [
      {
        "id": 1,
        "amount": 2500.00,
        "payment_method": "نقداً",
        "status": "paid",
        "notes": "تم الدفع عند التسليم",
        "payment_date": "2025-01-01T14:00:00Z"
      }
    ]
  }
}
```

### 5.3 عرض دفعة واحدة
```http
GET /api/payments/:id
Authorization: Bearer <token>

مثال:
GET /api/payments/1
```

### 5.4 إنشاء دفعة جديدة
```http
POST /api/payments
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "order_id": 1,
  "amount": 2500.00,
  "payment_method": "بطاقة ائتمان",
  "notes": "دفعة كاملة"
}

Response:
{
  "success": true,
  "message": "تم إنشاء الدفعة بنجاح",
  "data": {
    "id": 5,
    "order_number": "ORD-20250101-001",
    "amount": 2500.00,
    "remaining_amount": 0.00
  }
}
```

### 5.5 تحديث حالة الدفعة
```http
PUT /api/payments/:id/status
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "status": "paid",  // "pending", "paid", "failed"
  "notes": "تم تأكيد الدفع من البنك"
}
```

### 5.6 حذف دفعة
```http
DELETE /api/payments/:id
Authorization: Bearer <user_token>

مثال:
DELETE /api/payments/10
```

### 5.7 طرق الدفع المتاحة
```http
GET /api/payments/methods/list

Response:
{
  "success": true,
  "data": [
    { "value": "نقداً", "label": "الدفع نقداً عند الاستلام" },
    { "value": "بطاقة ائتمان", "label": "بطاقة ائتمان" },
    { "value": "تحويل بنكي", "label": "تحويل بنكي" },
    { "value": "محفظة إلكترونية", "label": "محفظة إلكترونية" },
    { "value": "شبكة", "label": "بطاقة شبكة" }
  ]
}
```

### 5.8 إحصائيات الدفعات
```http
GET /api/payments/dashboard/stats
Authorization: Bearer <user_token>

Response:
{
  "success": true,
  "data": {
    "total_payments": 300,
    "paid_payments": 250,
    "pending_payments": 40,
    "failed_payments": 10,
    "total_revenue": 185000.00,
    "today_revenue": 5500.00,
    "pending_amount": 15000.00,
    "average_payment": 750.25
  }
}
```

---

## 👨‍💼 6. APIs المستخدمين (Users)

### 6.1 عرض جميع المستخدمين
```http
GET /api/users
Authorization: Bearer <user_token>

Query Parameters:
- page, limit, search

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "username": "admin",
      "email": "admin@company.com",
      "full_name": "مدير النظام",
      "phone": "+966501111111",
      "is_active": true,
      "created_at": "2025-01-01T08:00:00Z",
      "last_login": "2025-01-02T09:30:00Z"
    }
  ]
}
```

### 6.2 الملف الشخصي للمستخدم
```http
GET /api/users/profile
Authorization: Bearer <user_token>

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "username": "admin",
    "email": "admin@company.com",
    "full_name": "مدير النظام",
    "phone": "+966501111111",
    "is_active": true,
    "created_at": "2025-01-01T08:00:00Z",
    "last_login": "2025-01-02T09:30:00Z"
  }
}
```

### 6.3 عرض مستخدم واحد
```http
GET /api/users/:id
Authorization: Bearer <user_token>

مثال:
GET /api/users/2
```

### 6.4 إنشاء مستخدم جديد
```http
POST /api/users
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "username": "support2",
  "email": "support2@company.com",
  "password": "securePassword123",
  "full_name": "موظف الدعم الثاني",
  "phone": "+966503333333"
}
```

### 6.5 تحديث بيانات المستخدم
```http
PUT /api/users/:id
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "full_name": "موظف الدعم المحدث",
  "phone": "+966504444444",
  "is_active": true
}
```

### 6.6 تحديث الملف الشخصي
```http
PUT /api/users/profile/update
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "full_name": "الاسم الجديد",
  "phone": "+966505555555"
}
```

### 6.7 حذف مستخدم
```http
DELETE /api/users/:id
Authorization: Bearer <user_token>

مثال:
DELETE /api/users/5
```

---

## 💬 7. APIs المحادثات (Conversations)

### 7.1 عرض المحادثات (للمشرفين)
```http
GET /api/conversations
Authorization: Bearer <user_token>

Query Parameters:
- page, limit, search

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "subject": "استفسار عن الطلب",
      "status": "open",
      "created_at": "2025-01-01T10:00:00Z",
      "updated_at": "2025-01-01T15:30:00Z",
      "customer_name": "أحمد محمد علي",
      "customer_email": "ahmed@example.com",
      "assigned_user": "موظف الدعم الأول",
      "unread_messages": 2,
      "last_message": "متى سيصل طلبي؟"
    }
  ]
}
```

### 7.2 محادثات العميل
```http
GET /api/conversations/my
Authorization: Bearer <customer_token>

Query Parameters:
- page, limit

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "subject": "استفسار عن الطلب",
      "status": "open",
      "created_at": "2025-01-01T10:00:00Z",
      "updated_at": "2025-01-01T15:30:00Z",
      "assigned_user": "موظف الدعم الأول",
      "unread_messages": 0,
      "last_message": "طلبك في طريقه إليك"
    }
  ]
}
```

### 7.3 عرض محادثة واحدة
```http
GET /api/conversations/:id
Authorization: Bearer <token>

مثال:
GET /api/conversations/1

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "subject": "استفسار عن الطلب",
    "status": "open",
    "created_at": "2025-01-01T10:00:00Z",
    "updated_at": "2025-01-01T15:30:00Z",
    "customer_name": "أحمد محمد علي",
    "customer_email": "ahmed@example.com",
    "assigned_user": "موظف الدعم الأول"
  }
}
```

### 7.4 إنشاء محادثة جديدة
```http
POST /api/conversations
Authorization: Bearer <customer_token>
Content-Type: application/json

Body:
{
  "subject": "استفسار عن المنتج الجديد"
}

Response:
{
  "success": true,
  "message": "تم إنشاء المحادثة بنجاح",
  "data": {
    "id": 5,
    "subject": "استفسار عن المنتج الجديد"
  }
}
```

### 7.5 تخصيص محادثة لمستخدم
```http
PUT /api/conversations/:id/assign
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "user_id": 2  // أو null لإلغاء التخصيص
}
```

### 7.6 تحديث حالة المحادثة
```http
PUT /api/conversations/:id/status
Authorization: Bearer <user_token>
Content-Type: application/json

Body:
{
  "status": "closed"  // "open" أو "closed"
}
```

### 7.7 حذف محادثة
```http
DELETE /api/conversations/:id
Authorization: Bearer <user_token>

مثال:
DELETE /api/conversations/10
```

### 7.8 إحصائيات المحادثات
```http
GET /api/conversations/dashboard/stats
Authorization: Bearer 

Response:
{
  "success": true,
  "data": {
    "total_conversations": 150,
    "open_conversations": 25,
    "closed_conversations": 125,
    "today_conversations": 8,
    "unassigned_conversations": 5,
    "total_unread_messages": 15
  }
}
```

---