// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mc_utils/mc_utils.dart';
import '../core/class/statusrequest.dart';
import '../core/constants/utils/widgets/snak_bar.dart';
import '../core/controller/connect_controller.dart';
import '../core/functions/handingdatacontroller.dart';

//====================== Helper Functions ======================//
bool get isConnect => Get.find<ConnectController>().checkIsConnect;

void showError(String msg, {bool hideLoading = false}) {
  if (!hideLoading) {
    // if (Get.find<ConnectController>().checkIsConnect) {
    showSnakBar(title: 'Error', msg: msg, color: Colors.red);
    // }
  }
}

void showLoading() {
  EasyLoading.show(
    status: 'loading...',
    dismissOnTap: false,
    maskType: EasyLoadingMaskType.clear,
  );
}

void dismissLoading() {
  EasyLoading.dismiss();
}

// Helper function to format error messages
String _formatErrorMessage(dynamic errorData) {
  if (errorData is Map) {
    String message = errorData['message']?.toString() ?? 'حدث خطأ';
    
    // Check if errors field exists and is a list
    if (errorData.containsKey('errors') && errorData['errors'] is List) {
      List errors = errorData['errors'];
      if (errors.isNotEmpty) {
        List<String> errorMessages = [];
        
        for (var error in errors) {
          if (error is Map && error.containsKey('message')) {
            errorMessages.add('• ${error['message']}');
          }
        }
        
        if (errorMessages.isNotEmpty) {
          message += '\n\nتفاصيل الأخطاء:\n${errorMessages.join('\n')}';
        }
      }
    }
    
    return message;
  }
  
  return errorData?.toString() ?? 'حدث خطأ غير معروف';
}

Future<void> handleRequestfunc<T>({
  required Future<T> Function() apiCall,
  required Function(T data) onSuccess,
  required Function(String message) onError,
  Function(StatusRequest status)? status,
  bool hideLoading = false,
}) async {
  var statusRequest = StatusRequest.loading;
  status?.call(statusRequest);
  if (!hideLoading) showLoading();

  if (!isConnect) {
    _handleOffline(onError, status);
    if (!hideLoading) dismissLoading();
    return;
  }

  try {
    final result = await apiCall();
    if (result is FailureWithMessage) {
      status?.call(result.status);
      // if (result.status.isAuthError) {
      //   Get.find<SettingController>().logout();
      // }
      if (result.message is String) {
        onError(result.message);
        return;
      }
      if (result.message['message'] != null) {
        onError(_formatErrorMessage(result.message));
        return;
      }
      onError(_formatErrorMessage(result.message));

      return;
    }
    // log("**************************${result.toString()}");
    if (result is Map &&
        (result['status'] == 'error' ||
            result['success'] == false ||
            result.keys.where((key) => key == 'error').isNotEmpty)) {
      status?.call(StatusRequest.serviceunavailable);
      
      // Use the new error formatting function
      String errorMessage = _formatErrorMessage(result);
      onError(errorMessage);
      return;
    }
    statusRequest = handlingData(result);
    if (statusRequest.isSuccess) {
      onSuccess(result);
    } else {
      onError(_formatErrorMessage(result));
    }
    status?.call(statusRequest);
  } catch (e) {
    log("=444=============== $e ===========");

    final currentStatus =
        isConnect ? StatusRequest.failure : StatusRequest.offlinefailure;
    onError(!isConnect
        ? StatusRequest.offlinefailure.text
        : StatusRequest.servererror.text);

    status?.call(currentStatus);
  } finally {
    if (!hideLoading) dismissLoading();
  }
}

void _handleOffline(
    Function(String) onError, Function(StatusRequest)? onStatusChange) {
  onError(StatusRequest.offlinefailure.text);
  onStatusChange?.call(StatusRequest.offlinefailure);
}
