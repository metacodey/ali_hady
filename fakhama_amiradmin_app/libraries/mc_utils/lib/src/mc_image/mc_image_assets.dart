import 'package:flutter/material.dart';

/// [McImageAssets] is a widget for displaying images from assets.
/// It includes error handling for when the image fails to load
/// and supports circular or rectangular image shapes.
class McImageAssets extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final String? pathImgError;
  final BoxFit fit;
  final Color? color;
  final bool isCircle;
  final Function()? onTap;
  final BorderRadius? radius;

  /// Constructs an instance of [McImageAssets] with the provided parameters.
  ///
  /// [path] is the asset path for the image to be displayed.
  /// [height] and [width] define the dimensions of the image.
  /// [fit] specifies how the image should fit within its container.
  /// [isCircle] determines whether the image should be displayed as a circle.
  /// [radius] sets the radius for rounded corners if [isCircle] is false.
  /// [pathImgError] is the asset path for the error image to display if the main image fails to load.
  const McImageAssets({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isCircle = false,
    this.radius,
    this.pathImgError,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image(
        image: AssetImage(path),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            // Apply a circular shape if isCircle is true, otherwise use rectangular with radius
            borderRadius:
                !isCircle ? radius ?? BorderRadius.circular(10) : null,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            // Set the image as background
            image: DecorationImage(image: AssetImage(path), fit: fit),
            color: color,
          ),
          child: height != null ? null : child,
        ),
        errorBuilder: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            // Apply the same shape and radius settings as for the normal image
            borderRadius:
                !isCircle ? radius ?? BorderRadius.circular(10) : null,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            // Display the error image as background if the main image fails to load
            image: DecorationImage(
              image: AssetImage(pathImgError ?? ""),
              fit: fit,
            ),
          ),
        ),
      ),
    );
  }
}
