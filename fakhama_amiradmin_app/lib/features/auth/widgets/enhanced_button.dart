import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnhancedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;

  const EnhancedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
    this.padding,
    this.icon,
  });

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height ?? 50.h,
              decoration: BoxDecoration(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(10.r),
                gradient: widget.gradient ?? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6366F1), // اللون الرئيسي لتطبيق فوترة
                    const Color(0xFF8B5CF6), // اللون الثانوي لتطبيق فوترة
                  ],
                ),
                color: widget.gradient == null
                    ? widget.backgroundColor ?? Theme.of(context).primaryColor
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: (widget.backgroundColor ??
                            Theme.of(context).primaryColor)
                        .withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(10.r),
                  child: Padding(
                    padding:
                        widget.padding ?? EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: widget.isLoading
                          ? SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.textColor ?? Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.icon != null) ...[
                                  widget.icon!,
                                  SizedBox(width: 8.w),
                                ],
                                Text(
                                  widget.text,
                                  style: TextStyle(
                                    color: widget.textColor ?? Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
