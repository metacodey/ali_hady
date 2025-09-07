const mysql = require('mysql2/promise');
require('dotenv').config();

// إعداد اتصال قاعدة البيانات
// const dbConfig = {
//   host: process.env.DB_HOST || 'localhost',
//   port: process.env.DB_PORT || 3306,
//   user: process.env.DB_USER || 'root',
//   password: process.env.DB_PASSWORD || '',
//   database: process.env.DB_NAME || 'fakhama_amir',
//   charset: 'utf8mb4',
//   timezone: '+03:00', // توقيت السعودية
//   connectionLimit: 10,
//   acquireTimeout: 60000,
//   timeout: 60000,
//   reconnect: true
// };
// في ملف database.js
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'fakhama_amir',
  charset: 'utf8mb4',
  timezone: '+03:00',
  connectionLimit: 10,
  acquireTimeout: 60000,
  timeout: 60000,
  reconnectOnError: true // بدلاً من reconnect: true
};
// إنشاء pool للاتصالات
const pool = mysql.createPool(dbConfig);

// اختبار الاتصال
const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    console.log('✅ تم الاتصال بقاعدة البيانات بنجاح');
    connection.release();
    return true;
  } catch (error) {
    console.error('❌ خطأ في الاتصال بقاعدة البيانات:', error.message);
    return false;
  }
};

// تنفيذ استعلام مع معالجة الأخطاء
const executeQuery = async (query, params = []) => {
  let connection;
  try {
    connection = await pool.getConnection();
    const [rows, fields] = await connection.execute(query, params);
    return { success: true, data: rows, fields };
  } catch (error) {
    console.error('خطأ في تنفيذ الاستعلام:', error.message);
    return { success: false, error: error.message };
  } finally {
    if (connection) connection.release();
  }
};

// تنفيذ استعلامات متعددة (Transaction)
const executeTransaction = async (queries) => {
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();
    
    const results = [];
    for (const { query, params } of queries) {
      const [rows] = await connection.execute(query, params || []);
      results.push(rows);
    }
    
    await connection.commit();
    return { success: true, data: results };
  } catch (error) {
    await connection.rollback();
    console.error('خطأ في Transaction:', error.message);
    return { success: false, error: error.message };
  } finally {
    connection.release();
  }
};

// دالة للحصول على البيانات مع Pagination
const getPaginatedData = async (baseQuery, countQuery, params = [], page = 1, limit = 10) => {
  try {
    const offset = (page - 1) * limit;
    
    // الحصول على العدد الكلي
    const countResult = await executeQuery(countQuery, params);
    if (!countResult.success) {
      throw new Error(countResult.error);
    }
    
    const totalItems = countResult.data[0]?.total || 0;
    const totalPages = Math.ceil(totalItems / limit);
    
    // الحصول على البيانات مع الحد والإزاحة
    const dataQuery = `${baseQuery} LIMIT ? OFFSET ?`;
    const dataResult = await executeQuery(dataQuery, [...params, limit, offset]);
    
    if (!dataResult.success) {
      throw new Error(dataResult.error);
    }
    
    return {
      success: true,
      data: dataResult.data,
      pagination: {
        currentPage: page,
        totalPages,
        totalItems,
        itemsPerPage: limit,
        hasNextPage: page < totalPages,
        hasPrevPage: page > 1
      }
    };
  } catch (error) {
    return { success: false, error: error.message };
  }
};

module.exports = {
  pool,
  testConnection,
  executeQuery,
  executeTransaction,
  getPaginatedData
};