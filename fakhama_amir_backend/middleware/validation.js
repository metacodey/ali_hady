const Joi = require('joi');

// دالة عامة للتحقق من صحة البيانات
const validate = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.body, { abortEarly: false });
    
    if (error) {
      const errors = error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }));
      
      return res.status(400).json({
        success: false,
        message: 'بيانات غير صحيحة',
        errors
      });
    }
    
    req.validatedData = value;
    next();
  };
};

// التحقق من المعاملات (params)
const validateParams = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.params);
    
    if (error) {
      return res.status(400).json({
        success: false,
        message: 'معاملات غير صحيحة',
        error: error.details[0].message
      });
    }
    
    req.validatedParams = value;
    next();
  };
};

// التحقق من Query Parameters
const validateQuery = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.query);
    
    if (error) {
      return res.status(400).json({
        success: false,
        message: 'استعلام غير صحيح',
        error: error.details[0].message
      });
    }
    
    req.validatedQuery = value;
    next();
  };
};

// Schemas للعملاء
const customerSchemas = {
  create: Joi.object({
  username: Joi.string().alphanum().min(3).max(50)
  .default(() => `user${Math.floor(1000 + Math.random() * 9000)}`)
  .messages({
    'string.alphanum': 'اسم المستخدم يجب أن يحتوي على أحرف وأرقام فقط',
    'string.min': 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل',
    'string.max': 'اسم المستخدم لا يجب أن يتجاوز 50 حرف'
  }),

    email: Joi.string().email().max(100).required()
      .messages({
        'string.email': 'البريد الإلكتروني غير صحيح',
        'any.required': 'البريد الإلكتروني مطلوب'
      }),
    password: Joi.string().min(6).max(128).required()
      .messages({
        'string.min': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        'any.required': 'كلمة المرور مطلوبة'
      }),
    full_name: Joi.string().min(2).max(100).required()
      .messages({
        'string.min': 'الاسم الكامل يجب أن يكون حرفين على الأقل',
        'any.required': 'الاسم الكامل مطلوب'
      }),
    phone: Joi.string().pattern(/^\+964[0-9]{9}$/).required()
      .messages({
        'string.pattern.base': 'رقم الهاتف يجب أن يبدأ بـ +964 ويتكون من 13 رقم',
        'any.required': 'رقم الهاتف مطلوب'
      }),
city: Joi.string().min(2).max(50).allow('').optional()
  .messages({
    'string.min': 'المدينة يجب أن تحتوي على حرفين على الأقل',
    'string.max': 'المدينة يجب ألا تتجاوز 50 حرفًا'
  }),

street_address: Joi.string().min(5).max(500).allow('').optional()
  .messages({
    'string.min': 'العنوان يجب أن يحتوي على 5 أحرف على الأقل',
    'string.max': 'العنوان يجب ألا يتجاوز 500 حرف'
  }),

    country: Joi.string().max(50).optional().default('العراق'),
    latitude: Joi.number().min(-90).max(90).optional(),
    longitude: Joi.number().min(-180).max(180).optional()
  }),
  
  update: Joi.object({
    full_name: Joi.string().min(2).max(100).optional(),
    phone: Joi.string().pattern(/^\+964[0-9]{9}$/).optional(),
    city: Joi.string().min(2).max(50).optional().allow(null, ''),
    street_address: Joi.string().min(5).max(500).optional().allow(null, ''),
    country: Joi.string().max(50).optional(),
    latitude: Joi.number().min(-90).max(90).optional(),
    longitude: Joi.number().min(-180).max(180).optional()
  }),
   updateLocation: Joi.object({
    city: Joi.string().min(2).max(50).required()
      .messages({
        'string.min': 'المدينة يجب أن تحتوي على حرفين على الأقل',
        'any.required': 'المدينة مطلوبة'
      }),
    street_address: Joi.string().min(5).max(500).required()
      .messages({
        'string.min': 'العنوان يجب أن يحتوي على 5 أحرف على الأقل',
        'any.required': 'العنوان مطلوب'
      }),
    country: Joi.string().max(50).optional(),
    latitude: Joi.number().min(-90).max(90).optional(),
    longitude: Joi.number().min(-180).max(180).optional()
  }),

  login: Joi.object({
    email: Joi.string().email().required()
      .messages({
        'string.email': 'البريد الإلكتروني غير صحيح',
        'any.required': 'البريد الإلكتروني مطلوب'
      }),
    password: Joi.string().required()
      .messages({
        'any.required': 'كلمة المرور مطلوبة'
      }),
    tokenFirebase: Joi.string().max(2000).optional().allow(null, ''),
  })
};

// Schemas للمنتجات
const productSchemas = {
  create: Joi.object({
    category_id: Joi.number().integer().positive().optional(),
    name: Joi.string().min(2).max(200).required()
      .messages({
        'any.required': 'اسم المنتج مطلوب'
      }),
    description: Joi.string().max(2000).optional().allow(null, ''),
    sku: Joi.string().max(50).optional(),
    price: Joi.number().positive().precision(2).required()
      .messages({
        'any.required': 'سعر المنتج مطلوب',
        'number.positive': 'السعر يجب أن يكون أكبر من صفر'
      }),
    quantity: Joi.number().integer().min(0).optional().default(0),
    image: Joi.string().max(255).optional()
  }),
  
  update: Joi.object({
    category_id: Joi.number().integer().positive().optional(),
    name: Joi.string().min(2).max(200).optional(),
    description: Joi.string().max(2000).optional().allow(null, ''),
    sku: Joi.string().max(50).optional(),
    price: Joi.number().positive().precision(2).optional(),
    quantity: Joi.number().integer().min(0).optional(),
    image: Joi.string().max(255).optional(),
    is_active: Joi.boolean().optional()
  })
};

// Schemas للطلبات
const orderSchemas = {
  create: Joi.object({
    customer_id:Joi.number().integer().positive().optional(),
    items: Joi.array().items(
      Joi.object({
        product_id: Joi.number().integer().positive().required(),
        quantity: Joi.number().integer().positive().required()
      })
    ).min(1).required()
      .messages({
        'array.min': 'يجب أن يحتوي الطلب على منتج واحد على الأقل'
      }),
    customer_notes: Joi.string().max(1000).optional().allow(null, '')
  }),
  
  updateStatus: Joi.object({
    status_id: Joi.number().integer().positive().required(),
    admin_notes: Joi.string().max(1000).optional().allow(null, '')
  })
};

// Schemas للدفعات
const paymentSchemas = {
  create: Joi.object({
    order_id: Joi.number().integer().positive().required(),
    amount: Joi.number().positive().precision(2).required(),
    payment_method: Joi.string().max(50).required(),
    notes: Joi.string().max(500).optional().allow(null, ''),
  }),
  
  updateStatus: Joi.object({
    status: Joi.string().valid('pending', 'paid', 'failed').required(),
    notes: Joi.string().max(500).optional()
  })
};

// Schemas للمحادثات
const conversationSchemas = {
  create: Joi.object({
    subject: Joi.string().max(200).optional().default('محادثة جديدة')
  }),
  createByAdmin: Joi.object({
    subject: Joi.string().max(200).optional().default('محادثة جديدة'),
    customerId: Joi.number().integer().positive().required()
  }),
  // أضف إلى conversationSchemas
customerParams: Joi.object({
  customerId: Joi.number().integer().positive().required()
})
};

// Schemas للرسائل
// في messageSchemas أضف هذين
const messageSchemas = {
  create: Joi.object({
    conversation_id: Joi.number().integer().positive().required(),
    message: Joi.string().min(1).max(2000).required()
      .messages({
        'any.required': 'نص الرسالة مطلوب'
      })
  }),

  // أضف هذا الجديد
  conversationParams: Joi.object({
    conversationId: Joi.number().integer().positive().required()
  }),

  // أضف هذا أيضاً
  markAllRead: Joi.object({
    conversation_id: Joi.number().integer().positive().required()
  })
};
// Schema للمعاملات العامة
const commonSchemas = {
  id: Joi.object({
    id: Joi.number().integer().positive().required()
  }),
  
  pagination: Joi.object({
    page: Joi.number().integer().positive().optional().default(1),
    limit: Joi.number().integer().min(1).max(100).optional().default(10),
    search: Joi.string().max(100).optional()
  })
};

module.exports = {
  validate,
  validateParams,
  validateQuery,
  customerSchemas,
  productSchemas,
  orderSchemas,
  paymentSchemas,
  conversationSchemas,
  messageSchemas,
  commonSchemas
};