import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/class/statusrequest.dart';
import 'api_services.dart';

/// خدمة التعامل مع طلبات HTTP
/// توفر واجهة موحدة للتعامل مع طلبات الشبكة المختلفة
class ApiClient {
  // ========================= دوال المساعدة الداخلية =========================

  /// تسجيل الأخطاء في مكان واحد للتتبع السهل
  void _logError(String status, String error, {String? url}) {
    log('===================== $status ====================');
    log('============== Error: $error');
    if (url != null) {
      log('=====================Page => $url ====================');
    }
  }

//
  /// فك تشفير محتوى الاستجابة من JSON
  dynamic _decodeResponseBody(String body) {
    try {
      return jsonDecode(body);
    } catch (e) {
      _logError('Error while decoding response body', e.toString());
      return {"error": "Unable to decode response body"};
    }
  }

  /// معالجة الاستجابة وتحويلها إلى النوع المطلوب
  Future<Either<FailureWithMessage, T>> _handleResponse<T>(
      http.Response response,
      {bool returnBytes = false}) async {
    var url = response.request?.url;

    try {
      // معالجة استجابة البايتات إذا طلب ذلك
      if (returnBytes && T == List<int>) {
        return Right(response.bodyBytes as T);
      }

      var decodedBody = _decodeResponseBody(response.body);

      // معالجة رموز الحالة المختلفة
      switch (response.statusCode) {
        case 200: // Success - OK
        case 201: // Created
          return Right(decodedBody);
        case 400: // Bad Request
          _logError('Bad Request', response.body, url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.badrequest, decodedBody));
        case 422:
        case 401: // Unauthorized
          _logError('Unauthorized', response.body, url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.unauthorized, decodedBody));
        case 402: // Payment Required
          _logError('Payment Required', response.body, url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.paymentrequired, decodedBody));
        case 403: // Forbidden
          _logError('Forbidden', response.body, url: url.toString());
          return Left(FailureWithMessage(StatusRequest.forbidden, decodedBody));
        case 404: // Not Found
          _logError('Not Found', response.body, url: url.toString());
          return Left(FailureWithMessage(StatusRequest.notfound, decodedBody));
        case 500: // Internal Server Error
          _logError('Internal Server Error', response.body,
              url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.servererror, decodedBody));
        case 501: // Not Implemented
          _logError('Not Implemented', response.body, url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.notimplemented, decodedBody));
        case 502: // Bad Gateway
          _logError('Bad Gateway', response.body, url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.badgateway, decodedBody));
        case 503: // Service Unavailable
          _logError('Service Unavailable', response.body, url: url.toString());
          return Left(FailureWithMessage(
              StatusRequest.serviceunavailable, decodedBody));
        default:
          _logError('Unknown Error', response.body, url: url.toString());
          return Left(
              FailureWithMessage(StatusRequest.serverfailure, decodedBody));
      }
    } catch (e) {
      _logError('Error while handling response', e.toString(),
          url: url.toString());
      return Left(FailureWithMessage(StatusRequest.failure,
          "Error in decoding response body page=> ${url.toString()}"));
    }
  }

  // ========================= طلبات GET =========================

  /// الحصول على بيانات كخريطة JSON
  /// @param url رابط الطلب
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  /// @param page اسم الصفحة للتسجيل (اختياري)
  Future<Either<FailureWithMessage, Map<String, dynamic>>> fetchJsonData({
    required String url,
    Map<String, String> headers = const {},
    String page = "",
  }) async {
    try {
      var res = await http.get(
        Uri.parse(url),
        headers: {...ApiServices.headers, ...headers},
      ).timeout(const Duration(seconds: 60));

      return await _handleResponse<Map<String, dynamic>>(res);
    } catch (e) {
      _logError(url, e.toString(), url: url);
      return Left(FailureWithMessage(
          StatusRequest.failure, "(Error in getting data) Page =>$url"));
    }
  }

  /// حذف
  /// @param url رابط الطلب
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  /// @param page اسم الصفحة للتسجيل (اختياري)
  Future<Either<FailureWithMessage, Map<String, dynamic>>> deleteData({
    required String url,
    Map<String, String> headers = const {},
    String page = "",
  }) async {
    try {
      var res = await http.delete(
        Uri.parse(url),
        headers: {...ApiServices.headers, ...headers},
      ).timeout(const Duration(seconds: 60));

      return await _handleResponse<Map<String, dynamic>>(res);
    } catch (e) {
      _logError(url, e.toString(), url: url);
      return Left(FailureWithMessage(
          StatusRequest.failure, "(Error in getting data) Page =>$url"));
    }
  }

  /// الحصول على بيانات كسلسلة نصية
  /// @param url رابط الطلب
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  Future<Either<StatusRequest, String>> fetchStringData(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    try {
      var res = await http
          .get(Uri.parse(url), headers: {...ApiServices.headers, ...headers});

      if (res.statusCode == 200 || res.statusCode == 201) {
        return Right(res.body);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } catch (e) {
      log('Error $e');
      return const Left(StatusRequest.serverfailure);
    }
  }

  /// الحصول على بيانات كبايتات (مثل الصور)
  /// @param url رابط الطلب
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  Future<Either<FailureWithMessage, List<int>>> fetchBinaryData({
    required String url,
    Map<String, String> headers = const {},
  }) async {
    try {
      var res = await http.get(
        Uri.parse(url),
        headers: {...ApiServices.headers, ...headers},
      ).timeout(const Duration(seconds: 60));

      return await _handleResponse<List<int>>(res, returnBytes: true);
    } catch (e) {
      _logError(url, e.toString(), url: url);
      return Left(FailureWithMessage(
          StatusRequest.failure, "(Error in getting bytes) Page =>$url"));
    }
  }

  // ========================= طلبات POST =========================

  /// إرسال بيانات JSON
  /// @param url رابط الطلب
  /// @param data البيانات المراد إرسالها
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  /// @param page اسم الصفحة للتسجيل (اختياري)
  Future<Either<FailureWithMessage, T>> sendJsonData<T>({
    required String url,
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    String page = "",
  }) async {
    try {
      var res = await http
          .post(
            Uri.parse(url),
            headers: {...ApiServices.headers, ...headers},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));
      // log('url************************* ${res.body}');
      // log('url******************11******* ${res.bodyBytes}');

      return await _handleResponse<T>(res);
    } catch (e) {
      _logError(url, e.toString(), url: url);
      return Left(FailureWithMessage(
          StatusRequest.offlinefailure, "(Error in sending data) Page =>$url"));
    }
  }

  /// رفع ملف
  /// @param url رابط الطلب
  /// @param imagePath مسار الملف المراد رفعها
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  Future<Either<FailureWithMessage, Map<String, dynamic>>> uploadFile({
    required String url,
    required String file,
    Map<String, String> data = const {},
    Map<String, String> headers = const {},
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({...ApiServices.headers, ...headers});
      request.files.add(await http.MultipartFile.fromPath('backup_file', file,
          filename: file.split('/').last));
      request.fields.addAll(data);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 60));

      var resBody = await response.stream.bytesToString();
      http.Response res = http.Response(resBody, response.statusCode,
          request: response.request);

      return await _handleResponse<Map<String, dynamic>>(res);
    } catch (e) {
      _logError('uploadImage', e.toString(), url: url);
      return Left(FailureWithMessage(
          StatusRequest.failure, "(Error in uploading image) Page =>$url"));
    }
  }

  /// رفع عدة ملفات مع بيانات إضافية
  /// @param url رابط الطلب
  /// @param files قائمة الملفات المراد رفعها
  /// @param data البيانات الإضافية
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  /// @param fileFieldName اسم حقل الملف (افتراضي: 'files')
  Future<Either<FailureWithMessage, Map<String, dynamic>>> uploadMultipleFiles({
    required String url,
    required List<File> files,
    Map<String, String> data = const {},
    Map<String, String> headers = const {},
    String fileFieldName = 'files',
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({...ApiServices.headers, ...headers});

      // إضافة الملفات
      for (int i = 0; i < files.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          '${fileFieldName}[$i]',
          files[i].path,
          filename: files[i].path.split('/').last,
        ));
      }

      // إضافة البيانات الإضافية
      request.fields.addAll(data);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 60));

      var resBody = await response.stream.bytesToString();
      http.Response res = http.Response(resBody, response.statusCode,
          request: response.request);

      return await _handleResponse<Map<String, dynamic>>(res);
    } catch (e) {
      _logError('uploadMultipleFiles', e.toString(), url: url);
      return Left(FailureWithMessage(
          StatusRequest.failure, "(Error in uploading files) Page =>$url"));
    }
  }
  // ========================= طلبات PUT =========================

  /// تحديث بيانات JSON
  /// @param url رابط الطلب
  /// @param data البيانات المراد تحديثها
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  /// @param page اسم الصفحة للتسجيل (اختياري)
  Future<Either<FailureWithMessage, T>> updateJsonData<T>({
    required String url,
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    String page = "",
  }) async {
    try {
      var res = await http
          .put(
            Uri.parse(url),
            headers: {...ApiServices.headers, ...headers},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      return await _handleResponse<T>(res);
    } catch (e) {
      _logError(url, e.toString(), url: url);
      return Left(FailureWithMessage(StatusRequest.offlinefailure,
          "(Error in updating data) Page =>$url"));
    }
  }

  // ========================= طلبات متنوعة =========================

  /// إرسال طلب متعدد الأجزاء (multipart) بطريقة ديناميكية
  /// @param url رابط الطلب
  /// @param data البيانات المراد إرسالها كحقول
  /// @param headers رؤوس الطلب الإضافية (اختياري)
  /// @param method طريقة الطلب (POST, PUT, etc.)
  /// @param page اسم الصفحة للتسجيل (اختياري)
  Future<Either<FailureWithMessage, T>> dynamicData<T>({
    required String url,
    Map<String, String> data = const {},
    Map<String, String> headers = const {},
    String method = "POST",
    String page = "",
  }) async {
    try {
      var req = http.MultipartRequest(method, Uri.parse(url));
      req.headers.addAll({...ApiServices.headers, ...headers});
      req.fields.addAll(data);

      var res = await req.send().timeout(const Duration(seconds: 60));
      final resBody = await res.stream.bytesToString();

      http.Response response =
          http.Response(resBody, res.statusCode, request: res.request);

      return await _handleResponse<T>(response);
    } catch (e) {
      _logError(url, e.toString(), url: url);
      return Left(FailureWithMessage(StatusRequest.offlinefailure,
          "(Error in multipart request) Page =>$url"));
    }
  }
}
