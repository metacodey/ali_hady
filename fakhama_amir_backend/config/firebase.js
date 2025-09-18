const admin = require('firebase-admin');
require('dotenv').config();

// إعداد Firebase Admin SDK
const serviceAccount = {
  type: "service_account",
  project_id: process.env.FIREBASE_PROJECT_ID,
  private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
  private_key: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
  client_email: process.env.FIREBASE_CLIENT_EMAIL,
  client_id: process.env.FIREBASE_CLIENT_ID,
  auth_uri: process.env.FIREBASE_AUTH_URI,
  token_uri: process.env.FIREBASE_TOKEN_URI,
  auth_provider_x509_cert_url: process.env.FIREBASE_AUTH_PROVIDER_X509_CERT_URL,
  client_x509_cert_url: process.env.FIREBASE_CLIENT_X509_CERT_URL
};

// تهيئة Firebase Admin
//if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: process.env.FIREBASE_PROJECT_ID
  });
//}

/**
 * إرسال إشعار Firebase إلى عميل واحد
 * @param {string} token - Firebase token للعميل
 * @param {string} title - عنوان الإشعار
 * @param {string} body - محتوى الإشعار
 * @param {object} data - بيانات إضافية (اختيارية)
 * @returns {Promise<object>} نتيجة الإرسال
 */
async function sendNotificationToCustomer(token, title, body, data = {}) {
  try {
    if (!token) {
      console.log('❌ Firebase Token غير متوفر للعميل');
      return {
        success: false,
        error: 'Firebase token غير متوفر'
      };
    }

    const message = {
      notification: {
        title: title,
        body: body
      },
      data: {
        ...data,
        timestamp: new Date().toISOString()
      },
      token: token,
      android: {
        notification: {
          sound: 'default',
          priority: 'high'
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1
          }
        }
      }
    };

    console.log('📤 محاولة إرسال إشعار Firebase...');
    console.log('📱 Token:', token.substring(0, 20) + '...');
    console.log('📋 العنوان:', title);
    console.log('📝 المحتوى:', body);

    const response = await admin.messaging().send(message);
    
    console.log('✅ تم إرسال الإشعار بنجاح!');
    console.log('📨 معرف الرسالة:', response);
    
    return {
      success: true,
      messageId: response,
      message: 'تم إرسال الإشعار بنجاح'
    };

  } catch (error) {
    console.error('❌ خطأ في إرسال إشعار Firebase:', error.message);
    
    // تسجيل تفاصيل الخطأ
    if (error.code) {
      console.error('🔍 كود الخطأ:', error.code);
    }
    
    return {
      success: false,
      error: error.message,
      code: error.code || 'UNKNOWN_ERROR'
    };
  }
}

/**
 * إرسال إشعار إلى عدة عملاء
 * @param {Array} tokens - مصفوفة من Firebase tokens
 * @param {string} title - عنوان الإشعار
 * @param {string} body - محتوى الإشعار
 * @param {object} data - بيانات إضافية (اختيارية)
 * @returns {Promise<object>} نتيجة الإرسال
 */
async function sendNotificationToMultipleCustomers(tokens, title, body, data = {}) {
  try {
    if (!tokens || tokens.length === 0) {
      console.log('❌ لا توجد Firebase Tokens متاحة');
      return {
        success: false,
        error: 'لا توجد tokens متاحة'
      };
    }

    // تصفية الـ tokens الفارغة
    const validTokens = tokens.filter(token => token && token.trim() !== '');
    
    if (validTokens.length === 0) {
      console.log('❌ لا توجد Firebase Tokens صالحة');
      return {
        success: false,
        error: 'لا توجد tokens صالحة'
      };
    }

    const message = {
      notification: {
        title: title,
        body: body
      },
      data: {
        ...data,
        timestamp: new Date().toISOString()
      },
      tokens: validTokens,
      android: {
        notification: {
          sound: 'default',
          priority: 'high'
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1
          }
        }
      }
    };

    console.log(`📤 محاولة إرسال إشعار Firebase إلى ${validTokens.length} عميل...`);
    console.log('📋 العنوان:', title);
    console.log('📝 المحتوى:', body);

    const response = await admin.messaging().sendMulticast(message);
    
    console.log('✅ تم إرسال الإشعارات!');
    console.log(`📊 النتائج: ${response.successCount} نجح، ${response.failureCount} فشل`);
    
    if (response.failureCount > 0) {
      console.log('❌ الأخطاء:');
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          console.log(`   - Token ${idx + 1}: ${resp.error?.message}`);
        }
      });
    }
    
    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
      responses: response.responses,
      message: `تم إرسال ${response.successCount} إشعار بنجاح`
    };

  } catch (error) {
    console.error('❌ خطأ في إرسال إشعارات Firebase:', error.message);
    
    return {
      success: false,
      error: error.message,
      code: error.code || 'UNKNOWN_ERROR'
    };
  }
}

/**
 * إرسال إشعار دفعة جديدة للعميل
 * @param {string} customerToken - Firebase token للعميل
 * @param {object} paymentData - بيانات الدفعة
 * @returns {Promise<object>} نتيجة الإرسال
 */
async function sendPaymentNotification(customerToken, paymentData) {
  const title = '💰 دفعة جديدة';
  const body = `تم إنشاء دفعة جديدة بمبلغ ${paymentData.amount} ريال للطلب ${paymentData.orderNumber}`;
  
  const data = {
    type: 'payment_created',
    payment_id: paymentData.paymentId?.toString() || '',
    order_number: paymentData.orderNumber || '',
    amount: paymentData.amount?.toString() || '',
    payment_method: paymentData.paymentMethod || ''
  };

  console.log('💳 إرسال إشعار دفعة جديدة...');
  return await sendNotificationToCustomer(customerToken, title, body, data);
}

module.exports = {
  sendNotificationToCustomer,
  sendNotificationToMultipleCustomers,
  sendPaymentNotification,
  admin
};