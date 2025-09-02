import 'package:flutter/material.dart';

enum StatusRequest {
  none, // حالة مبدئية أو فارغة
  loading, // حالة تحميل
  success, // نجاح العملية
  failure, // فشل العملية بشكل عام
  serverfailure, // فشل الخادم (مثل 500 أو 502)
  serverException, // استثناء في الخادم (مثل خطأ غير متوقع)
  offlinefailure, // فشل بسبب عدم الاتصال بالإنترنت
  badrequest, // طلب غير صالح (400)
  unauthorized, // غير مصرح (401)
  paymentrequired, // يتطلب الدفع (402)
  forbidden, // محظور (403)
  notfound, // غير موجود (404)
  servererror, // خطأ داخلي في الخادم (500)
  notimplemented, // غير مدعوم (501)
  badgateway, // بوابة سيئة (502)
  serviceunavailable, // الخدمة غير متاحة (503)
}

extension StatusRequestExtension on StatusRequest {
  String get text {
    switch (this) {
      case StatusRequest.none:
        return "No status";
      case StatusRequest.loading:
        return "Loading...";
      case StatusRequest.success:
        return "Success";
      case StatusRequest.failure:
        return "Operation failed";
      case StatusRequest.serverfailure:
        return "Server failure";
      case StatusRequest.serverException:
        return "Server exception";
      case StatusRequest.offlinefailure:
        return "No internet connection";
      case StatusRequest.badrequest:
        return "Bad request (400)";
      case StatusRequest.unauthorized:
        return "Unauthorized (401)";
      case StatusRequest.paymentrequired:
        return "Payment required (402)";
      case StatusRequest.forbidden:
        return "Forbidden (403)";
      case StatusRequest.notfound:
        return "Not found (404)";
      case StatusRequest.servererror:
        return "Server error (500)";
      case StatusRequest.notimplemented:
        return "Not implemented (501)";
      case StatusRequest.badgateway:
        return "Bad gateway (502)";
      case StatusRequest.serviceunavailable:
        return "Service unavailable (503)";
      default:
        return "Unknown status";
    }
  }

  IconData get icon {
    switch (this) {
      case StatusRequest.none:
        return Icons.info_outline; // أيقونة معلومات
      case StatusRequest.loading:
        return Icons.hourglass_top; // أيقونة تحميل
      case StatusRequest.success:
        return Icons.check_circle_outline; // أيقونة نجاح
      case StatusRequest.failure:
        return Icons.error_outline; // أيقونة خطأ عام
      case StatusRequest.serverfailure:
        return Icons.cloud_off; // أيقونة فشل الخادم
      case StatusRequest.serverException:
        return Icons.warning_amber; // أيقونة تحذير
      case StatusRequest.offlinefailure:
        return Icons.signal_wifi_off; // أيقونة عدم اتصال بالإنترنت
      case StatusRequest.badrequest:
        return Icons.report_problem; // أيقونة مشكلة
      case StatusRequest.unauthorized:
        return Icons.lock_outline; // أيقونة غير مصرح
      case StatusRequest.paymentrequired:
        return Icons.payment; // أيقونة دفع
      case StatusRequest.forbidden:
        return Icons.block; // أيقونة محظور
      case StatusRequest.notfound:
        return Icons.search_off; // أيقونة غير موجود
      case StatusRequest.servererror:
        return Icons.dangerous; // أيقونة خطأ داخلي
      case StatusRequest.notimplemented:
        return Icons.build; // أيقونة غير مدعوم
      case StatusRequest.badgateway:
        return Icons.cloud_off; // أيقونة بوابة سيئة
      case StatusRequest.serviceunavailable:
        return Icons.cloud_off; // أيقونة خدمة غير متاحة
      default:
        return Icons.error_outline; // أيقونة خطأ افتراضية
    }
  }
  // إضافة دوال للمقارنة مع حالات الطلب

  /// التحقق مما إذا كانت الحالة تمثل خطأ
  bool get isError {
    return this == StatusRequest.failure ||
        this == StatusRequest.serverfailure ||
        this == StatusRequest.serverException ||
        this == StatusRequest.offlinefailure ||
        this == StatusRequest.badrequest ||
        this == StatusRequest.unauthorized ||
        this == StatusRequest.paymentrequired ||
        this == StatusRequest.forbidden ||
        this == StatusRequest.notfound ||
        this == StatusRequest.servererror ||
        this == StatusRequest.notimplemented ||
        this == StatusRequest.badgateway ||
        this == StatusRequest.serviceunavailable;
  }

  /// التحقق مما إذا كانت الحالة تمثل خطأ في الخادم
  bool get isServerError {
    return this == StatusRequest.serverfailure ||
        this == StatusRequest.serverException ||
        this == StatusRequest.servererror ||
        this == StatusRequest.notimplemented ||
        this == StatusRequest.badgateway ||
        this == StatusRequest.serviceunavailable;
  }

  /// التحقق مما إذا كانت الحالة تمثل خطأ في الاتصال
  bool get isConnectionError {
    return this == StatusRequest.offlinefailure;
  }

  /// التحقق مما إذا كانت الحالة تمثل خطأ في التفويض
  bool get isAuthError {
    return this == StatusRequest.unauthorized ||
        this == StatusRequest.forbidden;
  }

  /// التحقق مما إذا كانت الحالة تمثل نجاح العملية
  bool get isSuccess {
    return this == StatusRequest.success;
  }

  /// التحقق مما إذا كانت الحالة تمثل تحميل
  bool get isLoading {
    return this == StatusRequest.loading;
  }

  /// التحقق مما إذا كانت الحالة تمثل حالة مبدئية
  bool get isNone {
    return this == StatusRequest.none;
  }

  /// مقارنة الحالة مع مجموعة من الحالات
  bool isOneOf(List<StatusRequest> statuses) {
    return statuses.contains(this);
  }

  /// الحصول على رسالة خطأ مناسبة بناءً على نوع الخطأ
  String get errorMessage {
    if (isConnectionError) {
      return "تحقق من اتصالك بالإنترنت وحاول مرة أخرى";
    } else if (isAuthError) {
      return "غير مصرح لك بالوصول إلى هذا المحتوى";
    } else if (this == StatusRequest.notfound) {
      return "المحتوى المطلوب غير موجود";
    } else if (isServerError) {
      return "حدث خطأ في الخادم، يرجى المحاولة لاحقاً";
    } else {
      return "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى";
    }
  }
}

class FailureWithMessage {
  final StatusRequest status;
  final dynamic message;
  FailureWithMessage(this.status, this.message);
}
// /// فئة لفحص نوع البيانات وحالة الطلب
// class DataTypeResult {
//   final dynamic data;
//   final StatusRequest status;

//   DataTypeResult({required this.data, this.status = StatusRequest.none});

//   /// إنشاء نتيجة ناجحة
//   factory DataTypeResult.success(dynamic data) {
//     return DataTypeResult(data: data, status: StatusRequest.success);
//   }

//   /// إنشاء نتيجة فاشلة
//   factory DataTypeResult.failure([String? message]) {
//     return DataTypeResult(
//         data: message ?? "Operation failed", status: StatusRequest.failure);
//   }

//   /// إنشاء نتيجة خطأ اتصال
//   factory DataTypeResult.offline() {
//     return DataTypeResult(
//         data: "No internet connection", status: StatusRequest.offlinefailure);
//   }

//   /// إنشاء نتيجة خطأ خادم
//   factory DataTypeResult.serverError([String? message]) {
//     return DataTypeResult(
//         data: message ?? "Server error", status: StatusRequest.servererror);
//   }

//   /// فحص إذا كانت البيانات قائمة
//   bool get isList => data is List;

//   /// فحص إذا كانت البيانات خريطة
//   bool get isMap => data is Map;

//   /// فحص إذا كانت البيانات نص
//   bool get isString => data is String;

//   /// فحص إذا كانت البيانات رقم
//   bool get isNumber => data is num;

//   /// فحص إذا كانت البيانات فارغة
//   bool get isEmpty {
//     if (data == null) return true;
//     if (isList) return (data as List).isEmpty;
//     if (isMap) return (data as Map).isEmpty;
//     if (isString) return (data as String).isEmpty;
//     return false;
//   }

//   /// فحص إذا كانت الحالة ناجحة
//   bool get isSuccess => status == StatusRequest.success;

//   /// فحص إذا كانت الحالة فاشلة
//   bool get isFailure => status.isError;

//   /// فحص إذا كانت الحالة تحميل
//   bool get isLoading => status == StatusRequest.loading;

//   /// فحص إذا كانت الحالة خطأ اتصال
//   bool get isOffline => status == StatusRequest.offlinefailure;

//   /// فحص إذا كانت الحالة خطأ خادم
//   bool get isError => status.isServerError || status.isError;

//   /// الحصول على قيمة من خريطة باستخدام مفتاح
//   dynamic getValue(String key) {
//     if (isMap) {
//       return (data as Map)[key];
//     }
//     return null;
//   }

//   /// الحصول على قيمة من خريطة باستخدام مفتاح مع قيمة افتراضية
//   T getValueOrDefault<T>(String key, T defaultValue) {
//     if (isMap) {
//       final value = (data as Map)[key];
//       if (value != null && value is T) {
//         return value;
//       }
//     }
//     return defaultValue;
//   }

//   /// الحصول على قائمة من البيانات
//   List<dynamic> get asList {
//     if (isList) return data as List;
//     if (isMap) return [(data as Map)];
//     return [data];
//   }

//   /// الحصول على قائمة من نوع محدد
//   List<T> asTypedList<T>() {
//     if (!isList) return [];

//     try {
//       return (data as List).whereType<T>().toList();
//     } catch (e) {
//       return [];
//     }
//   }

//   /// الحصول على خريطة من البيانات
//   Map<dynamic, dynamic> get asMap {
//     if (isMap) return data as Map;
//     return {};
//   }

//   /// الحصول على خريطة من نوع محدد
//   Map<K, V> asTypedMap<K, V>() {
//     if (!isMap) return {};

//     try {
//       final originalMap = data as Map;
//       final typedMap = <K, V>{};

//       originalMap.forEach((key, value) {
//         if (key is K && value is V) {
//           typedMap[key] = value;
//         }
//       });

//       return typedMap;
//     } catch (e) {
//       return {};
//     }
//   }

//   /// الحصول على نص من البيانات
//   String get asString {
//     if (isString) return data as String;
//     if (data == null) return "";
//     return data.toString();
//   }

//   /// الحصول على رقم من البيانات
//   num? get asNumber {
//     if (isNumber) return data as num;
//     if (isString) {
//       try {
//         return num.parse(data as String);
//       } catch (_) {
//         return null;
//       }
//     }
//     return null;
//   }

//   /// الحصول على رسالة خطأ مناسبة بناءً على الحالة
//   String get errorMessage {
//     if (isString && data.toString().isNotEmpty) {
//       return data.toString();
//     }
//     return status.errorMessage;
//   }

//   /// تنفيذ دالة مختلفة بناءً على حالة النتيجة
//   R when<R>({
//     required R Function(dynamic data) success,
//     required R Function(String message) failure,
//     R Function(String message)? offline,
//     R Function(String message)? serverError,
//     R Function()? loading,
//   }) {
//     if (status == StatusRequest.success) {
//       return success(data);
//     } else if (status == StatusRequest.offlinefailure) {
//       return offline?.call(errorMessage) ?? failure(errorMessage);
//     } else if (status.isServerError) {
//       return serverError?.call(errorMessage) ?? failure(errorMessage);
//     } else if (status == StatusRequest.loading) {
//       return loading?.call() ?? failure("Loading...");
//     } else {
//       return failure(errorMessage);
//     }
//   }

//   /// تحويل البيانات إلى نوع محدد
//   T? to<T>() {
//     if (data is T) {
//       return data as T;
//     }
//     return null;
//   }

//   /// إنشاء نسخة جديدة مع بيانات مختلفة
//   DataTypeResult copyWith({
//     dynamic newData,
//     StatusRequest? newStatus,
//   }) {
//     return DataTypeResult(
//       data: newData ?? data,
//       status: newStatus ?? status,
//     );
//   }
// }
