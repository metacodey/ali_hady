// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mc_utils/mc_utils.dart';

class ConversationModel with CustomDropdownListFilter {
  final int? id;
  final String subject;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String customerName;
  final String customerEmail;
  final String? assignedUser;
  final int unreadMessages;
  final int userId;

  final String lastMessage;

  ConversationModel({
    this.id,
    required this.subject,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.customerName,
    required this.customerEmail,
    this.assignedUser,
    required this.unreadMessages,
    required this.lastMessage,
    this.userId = 1,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 1,
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      assignedUser: json['assigned_user'],
      unreadMessages: int.tryParse(json['unread_messages'].toString()) ?? 0,
      lastMessage: json['last_message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
      "status": status,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "customer_name": customerName,
      "customer_email": customerEmail,
      "assigned_user": assignedUser,
      "unread_messages": unreadMessages,
      "last_message": lastMessage,
      'user_id': userId
    };
  }

  @override
  String toString() {
    return subject;
  }

  @override
  bool filter(String query) {
    return subject.toLowerCase().contains(query.toLowerCase()) ||
        customerName.toLowerCase().contains(query.toLowerCase()) ||
        lastMessage.toLowerCase().contains(query.toLowerCase());
  }

  // Helper methods
  bool get isOpen => status.toLowerCase() == 'open';
  bool get isClosed => status.toLowerCase() == 'closed';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get hasUnreadMessages => unreadMessages > 0;

  String get statusInArabic {
    switch (status.toLowerCase()) {
      case 'open':
        return 'مفتوحة';
      case 'closed':
        return 'مغلقة';
      case 'pending':
        return 'في الانتظار';
      default:
        return status;
    }
  }

  String get formattedDate {
    if (updatedAt != null) {
      return updatedAt.toString().split(' ')[0];
    }
    return createdAt?.toString().split(' ')[0] ?? '';
  }

  ConversationModel copyWith({
    int? id,
    String? subject,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? customerName,
    String? customerEmail,
    String? assignedUser,
    int? unreadMessages,
    int? userId,
    String? lastMessage,
  }) {
    return ConversationModel(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        customerName: customerName ?? this.customerName,
        customerEmail: customerEmail ?? this.customerEmail,
        assignedUser: assignedUser ?? this.assignedUser,
        unreadMessages: unreadMessages ?? this.unreadMessages,
        lastMessage: lastMessage ?? this.lastMessage,
        userId: userId ?? this.userId);
  }
}
