const mysql = require('mysql2/promise');
require('dotenv').config();

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
  reconnectOnError: true
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
    
    // تأكد من أن جميع المعاملات من النوع الصحيح
    const sanitizedParams = params.map(param => {
      if (typeof param === 'string') return param;
      if (typeof param === 'number') return param;
      if (param === null || param === undefined) return null;
      return String(param);
    });
    
    const [rows, fields] = await connection.execute(query, sanitizedParams);
    return { success: true, data: rows, fields };
  } catch (error) {
    console.error('خطأ في تنفيذ الاستعلام:', error.message);
    console.error('الاستعلام:', query);
    console.error('المعاملات:', params);
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

// دالة pagination محسنة (الحل النهائي)
const getPaginatedData = async (baseQuery, countQuery, params = [], page = 1, limit = 10) => {
  try {
    // تأكد من أن page و limit هما أرقام صحيحة
    const actualPage = parseInt(page) || 1;
    const actualLimit = parseInt(limit) || 10;
    const offset = (actualPage - 1) * actualLimit;
    
    console.log('=== Pagination Debug ===');
    console.log('Page:', actualPage, 'Limit:', actualLimit, 'Offset:', offset);
    console.log('Original params:', params);
    
    // الحصول على العدد الكلي أولاً
    const countResult = await executeQuery(countQuery, params);
    if (!countResult.success) {
      throw new Error(`Count query failed: ${countResult.error}`);
    }
    
    const totalItems = countResult.data[0]?.total || 0;
    const totalPages = Math.ceil(totalItems / actualLimit);
    
    console.log('Total items:', totalItems, 'Total pages:', totalPages);
    
    // بناء الاستعلام النهائي مع LIMIT و OFFSET
    // إضافة LIMIT و OFFSET مباشرة إلى الاستعلام بدلاً من استخدام المعاملات
    const finalQuery = `${baseQuery} LIMIT ${actualLimit} OFFSET ${offset}`;
    
    // console.log('Final query:', finalQuery);
    // console.log('Final params:', params); // نفس المعاملات الأصلية فقط
    
    // تنفيذ استعلام البيانات
    const dataResult = await executeQuery(finalQuery, params);
    
    if (!dataResult.success) {
      throw new Error(`Data query failed: ${dataResult.error}`);
    }
    
    console.log('Results count:', dataResult.data.length);
    console.log('=== End Pagination Debug ===');
    
    return {
      success: true,
      data: dataResult.data,
      pagination: {
        currentPage: actualPage,
        totalPages,
        totalItems,
        itemsPerPage: actualLimit,
        hasNextPage: actualPage < totalPages,
        hasPrevPage: actualPage > 1
      }
    };
  } catch (error) {
    console.error('getPaginatedData error:', error.message);
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