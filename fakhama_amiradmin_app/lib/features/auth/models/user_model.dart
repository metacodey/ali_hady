// ignore_for_file: public_member_api_docs, sort_constructors_first
// models/user_model.dart

import 'package:fakhama_amiradmin_app/features/auth/models/financial_summary.dart';
import 'package:mc_utils/mc_utils.dart';

class ConversationsSummary {
  final int totalConversations;
  final int openConversations;
  final int pendingConversations;
  final int closedConversations;
  final int unreadMessagesFromCustomer;
  final DateTime? lastMessageDate;
  final bool hasActiveConversations;
  final bool hasPendingConversations;
  final bool needsAdminAttention;

  ConversationsSummary({
    required this.totalConversations,
    required this.openConversations,
    required this.pendingConversations,
    required this.closedConversations,
    required this.unreadMessagesFromCustomer,
    this.lastMessageDate,
    required this.hasActiveConversations,
    required this.hasPendingConversations,
    required this.needsAdminAttention,
  });

  factory ConversationsSummary.fromJson(Map<String, dynamic> json) {
    return ConversationsSummary(
      totalConversations: int.tryParse(json['total_conversations'].toString()) ?? 0,
      openConversations: int.tryParse(json['open_conversations'].toString()) ?? 0,
      pendingConversations: int.tryParse(json['pending_conversations'].toString()) ?? 0,
      closedConversations: int.tryParse(json['closed_conversations'].toString()) ?? 0,
      unreadMessagesFromCustomer: int.tryParse(json['unread_messages_from_customer'].toString()) ?? 0,
      lastMessageDate: DateTime.tryParse(json['last_message_date'].toString()),
      hasActiveConversations: json['has_active_conversations'] == true,
      hasPendingConversations: json['has_pending_conversations'] == true,
      needsAdminAttention: json['needs_admin_attention'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_conversations': totalConversations,
      'open_conversations': openConversations,
      'pending_conversations': pendingConversations,
      'closed_conversations': closedConversations,
      'unread_messages_from_customer': unreadMessagesFromCustomer,
      'last_message_date': lastMessageDate?.toIso8601String(),
      'has_active_conversations': hasActiveConversations,
      'has_pending_conversations': hasPendingConversations,
      'needs_admin_attention': needsAdminAttention,
    };
  }
}

class UserModel with CustomDropdownListFilter {
  final int? id;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final String? city;
  final String? country;
  final String? streetAddress;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final String? token;
  final DateTime? createdAt;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? lastLogin;

  // البيانات المالية الجديدة
  final int? totalOrders;
  final double? totalAmount;
  final double? totalPaid;
  final double? remainingAmount;
  final FinancialSummary? financialSummary;

  // بيانات المحادثات الجديدة
  final int? totalConversations;
  final int? openConversations;
  final int? pendingConversations;
  final int? closedConversations;
  final int? unreadMessagesFromCustomer;
  final DateTime? lastMessageDate;
  final ConversationsSummary? conversationsSummary;

  UserModel({
    this.id,
    this.username = "",
    this.email = "",
    required this.fullName,
    required this.phone,
    this.city,
    this.country,
    this.streetAddress,
    this.latitude,
    this.longitude,
    required this.isActive,
    this.createdAt,
    this.token,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.lastLogin,
    this.totalOrders,
    this.totalAmount,
    this.totalPaid,
    this.remainingAmount,
    this.financialSummary,
    this.totalConversations,
    this.openConversations,
    this.pendingConversations,
    this.closedConversations,
    this.unreadMessagesFromCustomer,
    this.lastMessageDate,
    this.conversationsSummary,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      country: json['country'],
      streetAddress: json['street_address'],
      latitude: double.tryParse(json['latitude'].toString()),
      longitude: double.tryParse(json['longitude'].toString()),
      isActive: json['is_active'] == 1 ? true : false,
      createdAt: DateTime.tryParse(json['created_at'].toString()),
      token: json['token'],
      emailVerified: json['email_verified'] == 1 ? true : false,
      phoneVerified: json['phone_verified'] == 1 ? true : false,
      lastLogin: DateTime.tryParse(json['last_login'].toString()),
      totalOrders: int.tryParse(json['total_orders'].toString()),
      totalAmount: double.tryParse(json['total_amount'].toString()),
      totalPaid: double.tryParse(json['total_paid'].toString()),
      remainingAmount: double.tryParse(json['remaining_amount'].toString()),
      financialSummary: json['financial_summary'] != null
          ? FinancialSummary.fromJson(json['financial_summary'])
          : null,
      totalConversations: int.tryParse(json['total_conversations'].toString()),
      openConversations: int.tryParse(json['open_conversations'].toString()),
      pendingConversations: int.tryParse(json['pending_conversations'].toString()),
      closedConversations: int.tryParse(json['closed_conversations'].toString()),
      unreadMessagesFromCustomer: int.tryParse(json['unread_messages_from_customer'].toString()),
      lastMessageDate: DateTime.tryParse(json['last_message_date'].toString()),
      conversationsSummary: json['conversations_summary'] != null
          ? ConversationsSummary.fromJson(json['conversations_summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "full_name": fullName,
      "phone": phone,
      "city": city,
      "country": country,
      "street_address": streetAddress,
      "latitude": latitude,
      "longitude": longitude,
      "is_active": isActive,
      "created_at": createdAt?.toIso8601String(),
      'token': token,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'last_login': lastLogin?.toIso8601String(),
      'total_orders': totalOrders,
      'total_amount': totalAmount,
      'total_paid': totalPaid,
      'remaining_amount': remainingAmount,
      'financial_summary': financialSummary?.toJson(),
      'total_conversations': totalConversations,
      'open_conversations': openConversations,
      'pending_conversations': pendingConversations,
      'closed_conversations': closedConversations,
      'unread_messages_from_customer': unreadMessagesFromCustomer,
      'last_message_date': lastMessageDate?.toIso8601String(),
      'conversations_summary': conversationsSummary?.toJson(),
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? fullName,
    String? phone,
    String? city,
    String? country,
    String? streetAddress,
    double? latitude,
    double? longitude,
    bool? isActive,
    String? token,
    DateTime? createdAt,
    bool? emailVerified,
    bool? phoneVerified,
    DateTime? lastLogin,
    int? totalOrders,
    double? totalAmount,
    double? totalPaid,
    double? remainingAmount,
    FinancialSummary? financialSummary,
    int? totalConversations,
    int? openConversations,
    int? pendingConversations,
    int? closedConversations,
    int? unreadMessagesFromCustomer,
    DateTime? lastMessageDate,
    ConversationsSummary? conversationsSummary,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      country: country ?? this.country,
      streetAddress: streetAddress ?? this.streetAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      lastLogin: lastLogin ?? this.lastLogin,
      totalOrders: totalOrders ?? this.totalOrders,
      totalAmount: totalAmount ?? this.totalAmount,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      financialSummary: financialSummary ?? this.financialSummary,
      totalConversations: totalConversations ?? this.totalConversations,
      openConversations: openConversations ?? this.openConversations,
      pendingConversations: pendingConversations ?? this.pendingConversations,
      closedConversations: closedConversations ?? this.closedConversations,
      unreadMessagesFromCustomer: unreadMessagesFromCustomer ?? this.unreadMessagesFromCustomer,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      conversationsSummary: conversationsSummary ?? this.conversationsSummary,
    );
  }

  @override
  String toString() {
    //choose varible that you want to display in drop down btn
    return fullName;
  }

  @override
  bool filter(String query) {
    //choos varible that you want to search by it
    return fullName.toLowerCase().contains(query.toLowerCase());
  }
}
