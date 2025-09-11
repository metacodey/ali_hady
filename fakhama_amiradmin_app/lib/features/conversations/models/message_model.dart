class MessageModel {
  final int id;
  final int conversationId;
  final String message;
  final String senderType; // 'customer' or 'user'
  final int? senderId;
  final bool isRead;
  final DateTime createdAt;
  final String senderName;
  final int? customerId;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.message,
    required this.senderType,
    this.senderId,
    required this.isRead,
    required this.createdAt,
    required this.senderName,
    this.customerId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      conversationId:
          int.tryParse(json['conversation_id']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? 'user',
      senderId: int.tryParse(json['sender_id']?.toString() ?? ''),
      isRead: int.tryParse(json['is_read'].toString()) == 1 ? true : false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      senderName: json['sender_name']?.toString() ?? '',
      customerId: int.tryParse(json['customer_id']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'message': message,
      'sender_type': senderType,
      'sender_id': senderId,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'sender_name': senderName,
      'customer_id': customerId,
    };
  }

  bool get isFromCustomer => senderType == 'customer';
  bool get isFromUser => senderType == 'user';
  // إضافة خاصية لتحديد ما إذا كانت الرسالة من المستخدم الحالي
  bool get isFromMe => senderType == 'user';

  MessageModel copyWith({
    int? id,
    int? conversationId,
    String? message,
    String? senderType,
    int? senderId,
    bool? isRead,
    DateTime? createdAt,
    String? senderName,
    int? customerId,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      message: message ?? this.message,
      senderType: senderType ?? this.senderType,
      senderId: senderId ?? this.senderId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName,
      customerId: customerId ?? this.customerId,
    );
  }
}
