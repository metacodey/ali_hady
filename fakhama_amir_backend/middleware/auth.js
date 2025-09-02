const jwt = require('jsonwebtoken');
const { executeQuery } = require('../config/database');

// التحقق من صحة التوكن
const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader) {
      return res.status(401).json({
        success: false,
        message: 'مطلوب توكن المصادقة'
      });
    }

    const token = authHeader.split(' ')[1]; // Bearer TOKEN
    
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'صيغة التوكن غير صحيحة'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'انتهت صلاحية التوكن'
      });
    }
    
    return res.status(401).json({
      success: false,
      message: 'توكن غير صالح'
    });
  }
};

// التحقق من نوع المستخدم (عميل أو مستخدم)
const checkUserType = (allowedTypes) => {
  return (req, res, next) => {
    if (!allowedTypes.includes(req.user.userType)) {
      return res.status(403).json({
        success: false,
        message: 'غير مسموح لك بالوصول إلى هذا المورد'
      });
    }
    next();
  };
};

// التحقق من وجود العميل
const verifyCustomer = async (req, res, next) => {
  try {
    const query = 'SELECT id, full_name, email, is_active FROM customers WHERE id = ?';
    const result = await executeQuery(query, [req.user.userId]);
    
    if (!result.success || result.data.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'العميل غير موجود'
      });
    }

    const customer = result.data[0];
    if (!customer.is_active) {
      return res.status(403).json({
        success: false,
        message: 'حساب العميل غير مفعل'
      });
    }

    req.customer = customer;
    next();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'خطأ في التحقق من العميل'
    });
  }
};

// التحقق من وجود المستخدم
const verifyUser = async (req, res, next) => {
  try {
    const query = 'SELECT id, full_name, email, is_active FROM users WHERE id = ?';
    const result = await executeQuery(query, [req.user.userId]);
    
    if (!result.success || result.data.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'المستخدم غير موجود'
      });
    }

    const user = result.data[0];
    if (!user.is_active) {
      return res.status(403).json({
        success: false,
        message: 'حساب المستخدم غير مفعل'
      });
    }

    req.currentUser = user;
    next();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'خطأ في التحقق من المستخدم'
    });
  }
};

// التحقق من ملكية المورد للعميل
const verifyOwnership = (resourceIdParam = 'id', ownershipQuery) => {
  return async (req, res, next) => {
    try {
      const resourceId = req.params[resourceIdParam];
      const customerId = req.user.userId;
      
      const result = await executeQuery(ownershipQuery, [resourceId, customerId]);
      
      if (!result.success || result.data.length === 0) {
        return res.status(403).json({
          success: false,
          message: 'غير مسموح لك بالوصول إلى هذا المورد'
        });
      }
      
      next();
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: 'خطأ في التحقق من الملكية'
      });
    }
  };
};

module.exports = {
  verifyToken,
  checkUserType,
  verifyCustomer,
  verifyUser,
  verifyOwnership
};