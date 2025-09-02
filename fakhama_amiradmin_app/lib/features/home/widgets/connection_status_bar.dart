import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/controller/connect_controller.dart';

class ConnectionStatusBar extends StatelessWidget {
  const ConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectController>(
      builder: (connect) {
        if (connect.checkIsConnect) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: connect.checkIsConnect
              ? const Color(0xFF00EE44)
              : const Color(0xFFEE4400),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: connect.checkIsConnect
                ? _buildOnlineStatus()
                : _buildOfflineStatus(),
          ),
        );
      },
    );
  }

  /// حالة الاتصال - متصل
  Widget _buildOnlineStatus() {
    return Center(
      child: Text(
        'online'.tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// حالة الاتصال - غير متصل
  Widget _buildOfflineStatus() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'offline'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 12.w,
            height: 12.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
