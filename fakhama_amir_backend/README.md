# نظام إدارة العملاء والطلبات

نظام شامل لإدارة العملاء والطلبات مع نظام الدردشة المتكامل باستخدام Node.js وMySQL.

## 📋 المميزات

- ✅ **إدارة العملاء**: تسجيل، تسجيل دخول، إدارة البيانات والمواقع الجغرافية
- ✅ **إدارة المنتجات**: إضافة، تعديل، حذف المنتجات مع الفئات
- ✅ **نظام الطلبات**: إنشاء طلبات، تتبع الحالات، إدارة العناصر
- ✅ **نظام الدفعات**: تسجيل ومتابعة المدفوعات
- ✅ **نظام الدردشة**: محادثات فورية بين العملاء والمشرفين
- ✅ **المصادقة والأمان**: JWT tokens، تشفير كلمات المرور
- ✅ **Pagination**: عرض البيانات بصفحات منظمة
- ✅ **البحث والتصفية**: بحث متقدم في جميع البيانات

## 🛠️ التقنيات المستخدمة

- **Node.js** - بيئة التشغيل
- **Express.js** - إطار العمل الخلفي
- **MySQL** - قاعدة البيانات
- **JWT** - المصادقة
- **bcryptjs** - تشفير كلمات المرور
- **Joi** - التحقق من صحة البيانات
- **CORS** - السماح بالوصول من مصادر متعددة

## 🚀 التثبيت والتشغيل

### 1. متطلبات النظام
```bash
- Node.js (v14 أو أحدث)
- MySQL (v5.7 أو أحدث)
- npm أو yarn
```

### 2. تحميل المشروع
```bash
git clone <repository-url>
cd customer-management-system
```

### 3. تثبيت المكتبات
```bash
npm install
```

### 4. إعداد قاعدة البيانات
```bash
# تشغيل ملف SQL لإنشاء قاعدة البيانات والجداول
mysql -u root -p < database_setup.sql
```

### 5. إعداد متغيرات البيئة
```bash
# نسخ ملف البيئة وتعديله
cp .env.example .env

# تعديل الملف بالمعلومات الصحيحة:
# - بيانات قاعدة البيانات
# - مفتاح JWT السري
# - إعدادات أخرى
```

### 6. تشغيل الخادم
```bash
# للتطوير
npm run dev

# للإنتاج
npm start
```

الخادم سيعمل على `http://localhost:3000`

## 📁 هيكل المشروع

```
customer-management-system/
├── config/
│   └── database.js          # إعداد قاعدة البيانات
├── middleware/
│   ├── auth.js              # المصادقة
│   └── validation.js        # التحقق من البيانات
├── routes/
│   ├── auth.js              # مسارات المصادقة
│   ├── customers.js         # مسارات العملاء
│   ├── products.js          # مسارات المنتجات
│   ├── orders.js            # مسارات الطلبات
│   ├── payments.js          # مسارات الدفعات
│   ├── users.js             # مسارات المستخدمين
│   ├── conversations.js     # مسارات المحادثات
│   └── messages.js          # مسارات الرسائل
├── uploads/                 # مجلد الملفات المرفوعة
├── .env                     # متغيرات البيئة
├── server.js               # الملف الرئيسي
└── package.json            # معلومات المشروع
```

## 🔐 المصادقة

النظام يدعم نوعين من المستخدمين:
- **عملاء** (customers): يمكنهم تسجيل الدخول وإدارة طلباتهم والدردشة
- **مشرفين** (users): يمكنهم إدارة النظام بالكامل

### تسجيل الدخول
```http
POST /api/auth/customer/login
POST /api/auth/user/login

{
  "email": "user@example.com",
  "password": "password123"
}
```

### التحقق من التوكن
```http
GET /api/auth/verify
Authorization: Bearer <token>
```

## 🌐 واجهات برمجة التطبيقات (API)

### العملاء
```http
GET    /api/customers              # عرض جميع العملاء (للمشرفين)
GET    /api/customers/:id          # عرض عميل واحد
POST   /api/customers              # إنشاء عميل جديد
PUT    /api/customers/:id          # تحديث بيانات العميل
DELETE /api/customers/:id          # حذف عميل
GET    /api/customers/:id/orders   # طلبات عميل معين
```

### المنتجات
```http
GET    /api/products               # عرض المنتجات
GET    /api/products/:id           # عرض منتج واحد
POST   /api/products               # إنشاء منتج (للمشرفين)
PUT    /api/products/:id           # تحديث منتج (للمشرفين)
DELETE /api/products/:id           # حذف منتج (للمشرفين)
GET    /api/products/search/advanced # البحث المتقدم
```

### الطلبات
```http
GET    /api/orders                 # عرض جميع الطلبات (للمشرفين)
GET    /api/orders/my              # طلبات العميل المسجل دخوله
GET    /api/orders/:id             # تفاصيل طلب واحد
POST   /api/orders                 # إنشاء طلب جديد (للعملاء)
PUT    /api/orders/:id/status      # تحديث حالة الطلب (للمشرفين)
DELETE /api/orders/:id             # حذف طلب (للمشرفين)
```

### المحادثات والرسائل
```http
GET    /api/conversations          # المحادثات (للمشرفين)
GET    /api/conversations/my       # محادثات العميل
POST   /api/conversations          # إنشاء محادثة جديدة (للعملاء)
GET    /api/messages/conversation/:id # رسائل محادثة معينة
POST   /api/messages               # إرسال رسالة
PUT    /api/messages/:id/read      # تحديد رسالة كمقروءة
```

## 📊 أمثلة على الاستخدام

### إنشاء عميل جديد
```javascript
const response = await fetch('/api/customers', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    username: 'ahmed123',
    email: 'ahmed@example.com',
    password: 'securePassword',
    full_name: 'أحمد محمد علي',
    phone: '+966501234567',
    city: 'الرياض',
    street_address: 'حي النخيل - شارع الملك فهد',
    latitude: 24.7136,
    longitude: 46.6753
  })
});
```

### إنشاء طلب جديد
```javascript
const response = await fetch('/api/orders', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + token
  },
  body: JSON.stringify({
    items: [
      { product_id: 1, quantity: 2 },
      { product_id: 3, quantity: 1 }
    ],
    customer_notes: 'توصيل سريع من فضلك'
  })
});
```

### إرسال رسالة
```javascript
const response = await fetch('/api/messages', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + token
  },
  body: JSON.stringify({
    conversation_id: 1,
    message: 'مرحباً، أريد الاستفسار عن طلبي'
  })
});
```

## 🔧 الإعدادات

### متغيرات البيئة (.env)
```env
# إعدادات الخادم
PORT=3000
NODE_ENV=development

# قاعدة البيانات
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=customer_management_system

# JWT
JWT_SECRET=your_super_secret_key
JWT_EXPIRES_IN=7d

# الملفات
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=5242880

# CORS
CORS_ORIGIN=http://localhost:3001
```

## 📈 المراقبة والصحة

### فحص صحة النظام
```http
GET /
```
سيعيد معلومات عن حالة الخادم ووقت التشغيل.

### الإحصائيات
```http
GET /api/customers/dashboard/stats    # إحصائيات العملاء
GET /api/products/dashboard/stats     # إحصائيات المنتجات
GET /api/orders/dashboard/stats       # إحصائيات الطلبات
GET /api/payments/dashboard/stats     # إحصائيات الدفعات
GET /api/conversations/dashboard/stats # إحصائيات المحادثات
```

## 🛡️ الأمان

- **تشفير كلمات المرور**: باستخدام bcryptjs
- **JWT Tokens**: للمصادقة الآمنة
- **Rate Limiting**: لمنع الهجمات
- **CORS**: للتحكم في الوصول
- **Helmet**: لحماية HTTP headers
- **التحقق من البيانات**: باستخدام Joi

## 🚨 معالجة الأخطاء

النظام يعيد أخطاء منظمة بصيغة JSON:

```json
{
  "success": false,
  "message": "وصف الخطأ باللغة العربية",
  "error": "تفاصيل تقنية (في بيئة التطوير فقط)"
}
```

## 📝 أكواد الحالة

- `200` - نجح الطلب
- `201` - تم إنشاء المورد بنجاح
- `400` - خطأ في البيانات المرسلة
- `401` - غير مصرح له (مطلوب تسجيل دخول)
- `403` - ممنوع (لا توجد صلاحية)
- `404` - المورد غير موجود
- `409` - تعارض (مثل البيانات المكررة)
- `500` - خطأ داخلي في الخادم

## 🤝 المساهمة

مرحب بالمساهمات! يرجى:
1. عمل Fork للمشروع
2. إنشاء فرع للتطوير
3. إضافة التحسينات
4. إرسال Pull Request

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف LICENSE للتفاصيل.

## 🔍 استكشاف الأخطاء

### مشاكل شائعة وحلولها:

**1. خطأ الاتصال بقاعدة البيانات:**
```bash
# تأكد من تشغيل MySQL
sudo service mysql start

# تأكد من بيانات الاتصال في .env
# تأكد من إنشاء قاعدة البيانات
```

**2. خطأ المنفذ محجوز:**
```bash
# تغيير المنفذ في .env
PORT=3001

# أو إيقاف العملية التي تستخدم المنفذ
sudo lsof -t -i tcp:3000 | xargs kill -9
```

**3. خطأ JWT Token:**
```bash
# تأكد من وجود JWT_SECRET في .env
# تأكد من صحة التوكن في طلبات API
```

## 📚 الوثائق الإضافية

### مخطط قاعدة البيانات

قاعدة البيانات تتكون من الجداول التالية:
- `customers` - بيانات العملاء ومواقعهم
- `products` - المنتجات والفئات
- `orders` - الطلبات وحالاتها
- `order_items` - عناصر الطلبات
- `payments` - المدفوعات
- `users` - المشرفين والموظفين
- `conversations` - المحادثات
- `messages` - الرسائل

### العلاقات بين الجداول:
- عميل واحد ← طلبات متعددة
- طلب واحد ← عناصر متعددة + دفعات متعددة
- عميل واحد ← محادثات متعددة
- محادثة واحدة ← رسائل متعددة

## 🧪 الاختبار

لاختبار APIs يمكنك استخدام:

### Postman Collection
```json
{
  "info": {
    "name": "Customer Management System",
    "description": "مجموعة APIs لنظام إدارة العملاء"
  },
  "auth": {
    "type": "bearer",
    "bearer": [{"key": "token", "value": "{{jwt_token}}"}]
  }
}
```

### اختبار سريع بـ cURL:
```bash
# تسجيل دخول عميل
curl -X POST http://localhost:3000/api/auth/customer/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ahmed@example.com","password":"password123"}'

# الحصول على المنتجات
curl -X GET http://localhost:3000/api/products \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 💡 نصائح للتطوير

### أفضل الممارسات:
1. **استخدم HTTPS في الإنتاج**
2. **احفظ النسخ الاحتياطية من قاعدة البيانات دوريًا**
3. **راقب الأداء واستخدام الذاكرة**
4. **استخدم Load Balancer للمواقع عالية الحمل**
5. **فعل Logging مفصل للأخطاء**

### تحسين الأداء:
```javascript
// استخدام Connection Pooling
const pool = mysql.createPool({
  connectionLimit: 10,
  acquireTimeout: 60000,
  timeout: 60000,
  reconnect: true
});

// استخدام Indexes في قاعدة البيانات
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_order_status ON orders(status_id);
```

## 🚀 النشر في الإنتاج

### 1. إعداد الخادم:
```bash
# تحديث النظام
sudo apt update && sudo apt upgrade -y

# تثبيت Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# تثبيت MySQL
sudo apt install mysql-server -y
```

### 2. إعداد البيئة:
```bash
# إنشاء مستخدم للتطبيق
sudo useradd -m -s /bin/bash appuser

# نسخ الملفات
sudo cp -r /path/to/app /opt/customer-management-system
sudo chown -R appuser:appuser /opt/customer-management-system
```

### 3. استخدام PM2 للإدارة:
```bash
# تثبيت PM2
npm install -g pm2

# تشغيل التطبيق
pm2 start server.js --name "customer-management-system"

# حفظ العمليات
pm2 save
pm2 startup
```

### 4. إعداد Nginx كـ Reverse Proxy:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🔄 التحديثات والنسخ

### إنشاء نسخة احتياطية:
```bash
# نسخة من قاعدة البيانات
mysqldump -u root -p customer_management_system > backup_$(date +%Y%m%d).sql

# نسخة من الملفات المرفوعة
tar -czf uploads_backup_$(date +%Y%m%d).tar.gz uploads/
```

### التحديث لنسخة جديدة:
```bash
# إيقاف التطبيق
pm2 stop customer-management-system

# سحب التحديثات
git pull origin main

# تثبيت المكتبات الجديدة
npm install

# تشغيل أي تعديلات على قاعدة البيانات
mysql -u root -p customer_management_system < migrations/update_v2.sql

# إعادة تشغيل التطبيق
pm2 restart customer-management-system
```

## 📞 الدعم والتواصل

إذا واجهت أي مشاكل أو لديك اقتراحات:
- إنشاء Issue في GitHub
- مراجعة الوثائق
- التواصل مع فريق التطوير

## 🎯 الخطط المستقبلية

- [ ] إضافة WebSocket للدردشة الفورية
- [ ] تطبيق محمول بـ React Native
- [ ] نظام التقارير المتقدمة
- [ ] تكامل مع منصات الدفع الإلكتروني
- [ ] نظام الإشعارات عبر SMS والإيميل
- [ ] API للتطبيقات الخارجية
- [ ] لوحة تحكم متقدمة

---

**تم تطوير هذا النظام بواسطة:** Younis  
**تاريخ آخر تحديث:** سبتمبر 2025  
**الإصدار:** 1.0.0

🎉 **شكراً لاستخدام نظام إدارة العملاء والطلبات!**


# 📋 قاعدة البيانات

## 👥 العملاء (Customers)

| اسم المستخدم   | البريد الإلكتروني     | كلمة المرور (hash)       | الاسم الكامل       | رقم الهاتف       | المدينة  | العنوان                                | خط العرض | خط الطول |
|---------------|---------------------|-------------------------|-----------------|----------------|---------|----------------------------------------|----------|-----------|
| ahmed123      | ahmed@example.com   | admin123    | أحمد محمد علي   | +966501234567  | الرياض  | حي النخيل - شارع الملك فهد             | 24.7136  | 46.6753   |
| sara_h        | sara@example.com    | admin123    | سارة حسن        | +966502345678  | جدة     | حي الصفا - شارع التحلية                | 21.5428  | 39.1728   |
| mohammed_s    | mohammed@example.com| admin123    | محمد سالم       | +966503456789  | الدمام  | حي الفيصلية - طريق الملك عبدالعزيز   | 26.4207  | 50.0888   |

## 👨‍💼 المستخدمون (Users)

| اسم المستخدم  | البريد الإلكتروني       | كلمة المرور (hash)       | الاسم الكامل        | رقم الهاتف       |
|--------------|------------------------|-------------------------|------------------|----------------|
| admin        | admin@company.com      | admin123    | مدير النظام       | +966501111111  |
| support1     | support1@company.com   | admin123    | موظف الدعم الأول  | +966502222222  |
| support2     | support2@company.com   | admin123    | موظف الدعم الثاني | +966503333333  |
