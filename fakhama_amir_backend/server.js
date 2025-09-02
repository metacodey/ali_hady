const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const path = require('path');
require('dotenv').config();

const { testConnection } = require('./config/database');

// إنشاء التطبيق
const app = express();

// إعدادات الأمان
app.use(helmet());

// إعدادات CORS
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3001',
  credentials: true
}));

// Rate Limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: {
    success: false,
    message: 'تم تجاوز الحد المسموح من الطلبات، حاول مرة أخرى لاحقاً'
  }
});
app.use('/api', limiter);

// middleware لمعالجة البيانات
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// مجلد الملفات الثابتة
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// middleware للتسجيل
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Routes الأساسية
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'مرحباً بك في نظام إدارة العملاء والطلبات',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// استيراد المسارات
const customerRoutes = require('./routes/customers');
const productRoutes = require('./routes/products');
const orderRoutes = require('./routes/orders');
const paymentRoutes = require('./routes/payments');
const userRoutes = require('./routes/users');
const conversationRoutes = require('./routes/conversations');
const messageRoutes = require('./routes/messages');
const authRoutes = require('./routes/auth');

// تسجيل المسارات
app.use('/api/auth', authRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/users', userRoutes);
app.use('/api/conversations', conversationRoutes);
app.use('/api/messages', messageRoutes);

// معالج الأخطاء العام
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'خطأ داخلي في الخادم',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// معالج المسارات غير الموجودة
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'المسار غير موجود',
    path: req.originalUrl
  });
});

// بدء الخادم
const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    // اختبار الاتصال بقاعدة البيانات
    const dbConnected = await testConnection();
    if (!dbConnected) {
      console.error('❌ لا يمكن بدء الخادم بدون اتصال قاعدة البيانات');
      process.exit(1);
    }

    app.listen(PORT, () => {
      console.log(`🚀 الخادم يعمل على المنفذ ${PORT}`);
      console.log(`📱 واجهة برمجة التطبيقات: http://localhost:${PORT}/api`);
      console.log(`🌍 البيئة: ${process.env.NODE_ENV || 'development'}`);
    });
  } catch (error) {
    console.error('❌ خطأ في بدء الخادم:', error.message);
    process.exit(1);
  }
};

startServer();

// معالجة إشارات النظام
process.on('SIGTERM', () => {
  console.log('🔄 إيقاف الخادم...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('\n🔄 إيقاف الخادم...');
  process.exit(0);
});

module.exports = app;
