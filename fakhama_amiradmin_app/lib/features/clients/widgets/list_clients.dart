import 'package:fakhama_amiradmin_app/features/clients/controllers/clients_controller.dart';
import 'package:fakhama_amiradmin_app/features/clients/widgets/item_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class ListClients extends GetView<ClientsController> {
  const ListClients({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: Obx(() {
          var clients = controller.filteredClients;
          var length = clients.length + (controller.hasMoreData.value ? 1 : 0);

          return ListView.builder(
              controller: controller.scroller,
              itemCount: length,
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              itemBuilder: (context, index) {
                if (index == (length) - 1 && controller.hasMoreData.value) {
                  return _buildLoadMoreIndicator();
                }
                if (index >= clients.length) {
                  return const SizedBox.shrink();
                }
                var client = controller.clients[index];
                return ItemClient(
                  client: client,
                  onDelete: () {
                    controller.deleteClient(client.id!);
                  },
                  onChat: () {
                    Get.toNamed(
                      '/chat/home',
                      arguments: client,
                    );
                  },
                  onEdit: () {
                    Get.toNamed(
                      '/client/add',
                      arguments: {'client': client},
                    );
                  },
                  onTap: () {
                    // يمكن إضافة وظيفة للانتقال إلى تفاصيل المستخدم
                    _showClientDetails(context, client);
                  },
                );
              });
        }));
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (!controller.hasMoreData.value) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: Center(
            child: Text(
              'تم عرض جميع العملاء',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      // التحميل التلقائي فقط
      return const SizedBox.shrink();
    });
  }

  void _showClientDetails(BuildContext context, client) {
    // يمكن إضافة صفحة تفاصيل المستخدم هنا
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل العميل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: ${client.fullName}'),
            Text('البريد: ${client.email}'),
            Text('الهاتف: ${client.phone}'),
            if (client.city != null) Text('المدينة: ${client.city}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
