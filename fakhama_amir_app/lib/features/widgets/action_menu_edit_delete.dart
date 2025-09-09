import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class ActionMenuEditDelete extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const ActionMenuEditDelete({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
        size: 20.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 18.w),
              SizedBox(width: 8.w),
              Text('edit'.tr),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_rounded, size: 18.w, color: Colors.red),
              SizedBox(width: 8.w),
              Text('delete'.tr, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
