import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

final Set<String> _activeMessages = {};

void showSnakBar(
    {required String title,
    required String msg,
    Color color = Colors.green,
    IconData? icon,
    int sec = 2,
    bool canCopy = false}) {
  final uniqueKey = "$title::$sec";
  // إذا كانت الرسالة معروضة حاليًا، لا تعرضها مرة ثانية
  if (_activeMessages.contains(uniqueKey)) return;

  _activeMessages.add(uniqueKey); // أضف الرسالة إلى القائمة المؤقتة

  Get.showSnackbar(
    GetSnackBar(
      titleText: Row(
        children: [
          Icon(icon ?? Icons.info_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (canCopy)
            InkWell(
              child: const Icon(Icons.copy, color: Colors.white, size: 18),
              onTap: () {
                Clipboard.setData(ClipboardData(text: msg));
                Get.snackbar(
                  "Copied".tr,
                  "Message copied to clipboard".tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                  duration: const Duration(seconds: 2),
                );
              },
              // tooltip: 'Copy',
            )
        ],
      ),
      messageText: Text(
        msg,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      backgroundColor: color,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      duration: Duration(seconds: sec),
      snackStyle: SnackStyle.FLOATING,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED ||
            status == SnackbarStatus.CLOSING) {
          _activeMessages.remove(uniqueKey);
        }
      },
    ),
  );
}
