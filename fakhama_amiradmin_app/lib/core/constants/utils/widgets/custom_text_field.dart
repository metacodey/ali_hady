import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:mc_utils/mc_utils.dart';

import '../../../../theme/controller/theme_controller.dart';
import '../assets/fonts.dart';

/// حقل نص مخصص مع دعم كامل للعربية والإنجليزية
class CustomTextField extends StatefulWidget {
  // ===== المعاملات الأساسية =====
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  // ===== إعدادات النص =====
  final bool obscureText;
  final bool readOnly;
  final int maxline;
  final int? minline;
  final int? maxLength;
  final bool isNext;

  // ===== إعدادات التصميم =====
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool showFillColor;
  final bool shadow;
  final BorderRadius? radius;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? paddingLable;

  const CustomTextField({
    super.key,
    // المعاملات الأساسية
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.onChanged,

    // إعدادات النص
    this.obscureText = false,
    this.readOnly = false,
    this.maxline = 1,
    this.minline,
    this.maxLength,
    this.isNext = false,

    // إعدادات التصميم
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.showFillColor = false,
    this.shadow = false,
    this.radius,
    this.borderSide,
    this.padding,
    this.paddingLable,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // ===== إدارة الحالة =====
  late ValueNotifier<ui.TextDirection> _textDirectionNotifier;
  late ValueNotifier<TextAlign> _textAlignNotifier;

  // لتتبع ما إذا كان الـ Widget ما زال mounted
  bool _isListenerAttached = false;

  @override
  void initState() {
    super.initState();
    _initializeTextDirectionAndAlign();
    _attachTextControllerListener();
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إذا تغير الكنترولر، قم بإزالة الـ listener القديم وإضافة الجديد
    if (widget.controller != oldWidget.controller) {
      _removeTextControllerListener(oldWidget.controller);
      _attachTextControllerListener();

      // تحديث اتجاه النص للكنترولر الجديد
      final newText = widget.controller?.text ?? '';
      _updateTextDirection(newText);
    }
  }

  @override
  void dispose() {
    _removeTextControllerListener(widget.controller);
    _disposeNotifiers();
    super.dispose();
  }

  // ===== تهيئة الحالة =====

  void _initializeTextDirectionAndAlign() {
    final initialText = widget.controller?.text ?? '';
    _textDirectionNotifier = ValueNotifier(_getTextDirection(initialText));
    _textAlignNotifier = ValueNotifier(_getTextAlign(initialText));
  }

  void _attachTextControllerListener() {
    if (widget.controller != null && !_isListenerAttached) {
      widget.controller!.addListener(_onTextChanged);
      _isListenerAttached = true;
    }
  }

  void _removeTextControllerListener(TextEditingController? controller) {
    if (controller != null && _isListenerAttached) {
      try {
        controller.removeListener(_onTextChanged);
      } catch (e) {
        // تجاهل الأخطاء إذا كان الكنترولر قد تم التخلص منه بالفعل
        debugPrint('Error removing listener: $e');
      } finally {
        _isListenerAttached = false;
      }
    }
  }

  void _disposeNotifiers() {
    try {
      _textDirectionNotifier.dispose();
      _textAlignNotifier.dispose();
    } catch (e) {
      debugPrint('Error disposing notifiers: $e');
    }
  }

  // ===== معالجة التغييرات =====

  void _onTextChanged() {
    if (!mounted) return;

    final text = widget.controller?.text ?? '';
    _updateTextDirection(text);
  }

  void _updateTextDirection(String text) {
    if (!mounted) return;

    try {
      final newDirection = _getTextDirection(text);
      final newAlign = _getTextAlign(text);

      if (_textDirectionNotifier.value != newDirection) {
        _textDirectionNotifier.value = newDirection;
      }

      if (_textAlignNotifier.value != newAlign) {
        _textAlignNotifier.value = newAlign;
      }
    } catch (e) {
      debugPrint('Error updating text direction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تسمية الحقل
        if (_shouldShowLabel) _buildLabel(),

        // حقل النص الرئيسي
        _buildTextFieldContainer(),
      ],
    );
  }

  // ===== بناء العناصر =====

  bool get _shouldShowLabel => widget.label != null && widget.label!.isNotEmpty;

  Widget _buildLabel() {
    return Padding(
      padding: widget.paddingLable ?? EdgeInsets.zero,
      child: Row(
        children: [
          McText(
            txt: widget.label!,
            fontSize: 14.sp,
            blod: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldContainer() {
    return Container(
      decoration:
          widget.shadow ? McTextFieldTheme.inputBoxDecorationShaddow() : null,
      child: _buildTextFieldWithDirection(),
    );
  }

  Widget _buildTextFieldWithDirection() {
    return ValueListenableBuilder<ui.TextDirection>(
      valueListenable: _textDirectionNotifier,
      builder: (context, direction, _) {
        return ValueListenableBuilder<TextAlign>(
          valueListenable: _textAlignNotifier,
          builder: (context, align, _) => _buildTextFormField(direction, align),
        );
      },
    );
  }

  Widget _buildTextFormField(ui.TextDirection direction, TextAlign align) {
    return TextFormField(
      // إعدادات أساسية
      controller: widget.controller,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,

      // إعدادات النص
      maxLines: widget.maxline,
      minLines: widget.minline,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.isNext ? TextInputAction.next : null,
      onFieldSubmitted: _handleFieldSubmitted,
      // اتجاه النص
      textDirection: direction,
      // textAlign: align, // معلق لتجنب التضارب مع textDirection

      // معالجات الأحداث
      validator: widget.validator,
      onChanged: _handleTextChanged,
      onTapOutside: _handleTapOutside,

      // التصميم
      style: _getTextStyle(),
      decoration: _getInputDecoration(),
    );
  }

  // ===== معالجات الأحداث =====

  void _handleTextChanged(String value) {
    widget.onChanged?.call(value);
    // تحديث اتجاه النص سيتم تلقائياً عبر الـ listener
  }

// معالج جديد للانتقال بين الحقول
  void _handleFieldSubmitted(String value) {
    if (widget.isNext) {
      FocusScope.of(context).nextFocus();
    } else {
      // إلغاء التركيز إذا كان الحقل الأخير
      FocusScope.of(context).unfocus();
    }
  }

  void _handleTapOutside(PointerDownEvent event) {
    // تحقق من أن الـ FocusNode ما زال صالحاً قبل استخدامه
    if (widget.focusNode != null && widget.focusNode!.canRequestFocus) {
      widget.focusNode!.unfocus();
    } else {
      // استخدم الطريقة العامة إذا لم يكن لدينا focusNode صالح
      FocusScope.of(context).unfocus();
    }
  }

  // ===== تحديد الأنماط =====

  TextStyle _getTextStyle() {
    return TextStyle(
      fontSize: 14.sp,
      color: _getTextColor(),
    );
  }

  Color _getTextColor() {
    if (widget.fillColor == Colors.white) {
      return Colors.black;
    }

    final themeController = Get.find<ThemeController>();
    return themeController.darkTheme ? Colors.white : Colors.black;
  }

  InputDecoration _getInputDecoration() {
    return McTextFieldTheme.textInputDecoration(
      hintText: widget.hintText ?? '',
      hintStyle: _getHintStyle(),
      fillColor: widget.fillColor,
      showFilColor: widget.showFillColor,
      labelStyle: _getLabelStyle(),
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon,
      borderRadius: widget.radius ?? BorderRadius.circular(40),
      borderSide: widget.borderSide ?? _getDefaultBorderSide(),
      contentPadding: widget.padding ?? _getDefaultPadding(),
    );
  }

  TextStyle _getHintStyle() {
    final brightness = Theme.of(context).brightness;
    final hintColor =
        brightness == Brightness.dark ? Colors.grey[500] : Colors.grey[700];

    return TextStyle(color: hintColor);
  }

  TextStyle _getLabelStyle() {
    return TextStyle(
      fontSize: 14.sp,
      fontFamily: AppFontFamilies.cairoFont,
      color: Theme.of(context).disabledColor,
      fontWeight: FontWeight.bold,
    );
  }

  BorderSide _getDefaultBorderSide() {
    return const BorderSide(color: Colors.black, width: 1);
  }

  EdgeInsets _getDefaultPadding() {
    return EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h);
  }

  // ===== تحديد اتجاه النص =====

  ui.TextDirection _getTextDirection(String? text) {
    if (text == null || text.isEmpty) {
      return ui.TextDirection.rtl; // افتراضي للعربية
    }

    try {
      final firstChar = text.characters.first;
      final isArabic = _isArabicCharacter(firstChar);
      return isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr;
    } catch (e) {
      debugPrint('Error determining text direction: $e');
      return ui.TextDirection.rtl;
    }
  }

  TextAlign _getTextAlign(String? text) {
    if (text == null || text.isEmpty) {
      return TextAlign.right; // افتراضي للعربية
    }

    try {
      final firstChar = text.characters.first;
      final isArabic = _isArabicCharacter(firstChar);
      return isArabic ? TextAlign.right : TextAlign.left;
    } catch (e) {
      debugPrint('Error determining text align: $e');
      return TextAlign.right;
    }
  }

  bool _isArabicCharacter(String character) {
    // نطاق أوسع للأحرف العربية والفارسية والأردية
    return RegExp(
            r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(character);
  }
}

// ===== إضافات للتحسين =====

/// مساعد لإنشاء CustomTextField مع إعدادات مختلفة
class CustomTextFieldBuilder {
  static Widget email({
    TextEditingController? controller,
    String? label,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      label: label ?? 'البريد الإلكتروني',
      hintText: 'example@email.com',
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      isNext: true,
    );
  }

  static Widget password({
    TextEditingController? controller,
    String? label,
    String? Function(String?)? validator,
    bool obscureText = true,
  }) {
    return CustomTextField(
      controller: controller,
      label: label ?? 'كلمة المرور',
      hintText: '••••••••',
      obscureText: obscureText,
      validator: validator,
    );
  }

  static Widget number({
    TextEditingController? controller,
    String? label,
    String? hintText,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: TextInputType.number,
      validator: validator,
      maxLength: maxLength,
    );
  }

  static Widget multiline({
    TextEditingController? controller,
    String? label,
    String? hintText,
    int maxLines = 3,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      maxline: maxLines,
      minline: 2,
      validator: validator,
    );
  }
}

/// مدير لحالة عدة حقول نص
class TextFieldsManager {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  TextEditingController getController(String key) {
    return _controllers.putIfAbsent(key, () => TextEditingController());
  }

  FocusNode getFocusNode(String key) {
    return _focusNodes.putIfAbsent(key, () => FocusNode());
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _controllers.clear();
    _focusNodes.clear();
  }

  void clearAll() {
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }
}
