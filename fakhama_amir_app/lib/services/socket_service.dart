import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:mc_utils/mc_utils.dart';
import '../core/class/preferences.dart';
import 'api/api_services.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find<SocketService>();

  IO.Socket? _socket;
  final RxBool _isConnected = false.obs;
  final RxString _connectionStatus = 'disconnected'.obs;

  bool get isConnected => _isConnected.value;
  String get connectionStatus => _connectionStatus.value;

  // Events
  final RxMap<String, Function> _eventListeners = <String, Function>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  void _initSocket() {
    try {
      final user = Preferences.getDataUser();
      if (user?.token == null) {
        print('❌ No token found, cannot connect to socket');
        return;
      }

      _socket = IO.io(
        ApiServices.serverSocket, // يجب تغييرها لعنوان الخادم الفعلي
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setAuth({'token': user!.token, 'userId': user.id})
            .build(),
      );

      _setupEventListeners();
    } catch (e) {
      print('❌ Error initializing socket: $e');
    }
  }

  void _setupEventListeners() {
    _socket?.onConnect((_) {
      print('🔌 Socket connected (Admin)');
      _isConnected.value = true;
      _connectionStatus.value = 'connected';
    });

    _socket?.onDisconnect((_) {
      print('🔌 Socket disconnected (Admin)');
      _isConnected.value = false;
      _connectionStatus.value = 'disconnected';
    });

    _socket?.onConnectError((error) {
      print('❌ Socket connection error (Admin): $error');
      _connectionStatus.value = 'error';
    });

    _socket?.on('error', (error) {
      print('❌ Socket error (Admin): $error');
    });

    // الاستماع لرسائل العملاء الجديدة
    _socket?.on('new_customer_message', (data) {
      print('📨 New customer message received: $data');
      // يمكن إضافة منطق إضافي هنا للإشعارات
    });
  }

  // الانضمام إلى محادثة
  void joinConversation(int conversationId) {
    if (_socket?.connected == true) {
      _socket?.emit('join_conversation', {'conversationId': conversationId});
      print('📝 Admin joined conversation: $conversationId');
    }
  }

  // مغادرة المحادثة
  void leaveConversation(int conversationId) {
    if (_socket?.connected == true) {
      _socket?.emit('leave_conversation', {'conversationId': conversationId});
      print('📤 Admin left conversation: $conversationId');
    }
  }

  void createConversation({
    required Map<String, dynamic> data,
  }) {
    if (_socket?.connected == true) {
      _socket?.emit('new_conversation_created', data);
    }
  }

  void changeConversationState(Map<String, dynamic> data) {
    if (_socket?.connected == true) {
      _socket?.emit('update_conversation_status', data);
    }
  }

  // إرسال رسالة
  void sendMessage({
    required Map<String, dynamic> data,
  }) {
    if (_socket?.connected == true) {
      _socket?.emit('send_message', data);
    }
  }

  // تحديد الرسالة كمقروءة
  void markMessageAsRead(Map<String, dynamic> data) {
    if (_socket?.connected == true) {
      _socket?.emit('mark_message_read', data);
    }
  }

  // الاستماع للأحداث
  void on(String event, Function callback) {
    _eventListeners[event] = callback;
    _socket?.on(event, (data) => callback(data));
  }

  // إزالة مستمع الحدث
  void off(String event) {
    _eventListeners.remove(event);
    _socket?.off(event);
  }

  // إعادة الاتصال
  void reconnect() {
    _socket?.disconnect();
    _initSocket();
  }

  @override
  void onClose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.onClose();
  }
}
