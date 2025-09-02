import 'dart:io';
import 'package:flutter/material.dart';

/// [McImageFile] is a widget for displaying images from local file paths.
/// It includes error handling for when the image fails to load
/// and supports circular or rectangular image shapes.
class McImageFile extends StatelessWidget {
  final File file;
  final double? height;
  final double? width;
  final String? pathImgError;
  final BoxFit fit;
  final bool isCircle;
  final BorderRadius? radius;

  /// Constructs an instance of [McImageFile] with the provided parameters.
  ///
  /// [file] is the local file to be displayed as an image.
  /// [height] and [width] define the dimensions of the image.
  /// [fit] specifies how the image should fit within its container.
  /// [isCircle] determines whether the image should be displayed as a circle.
  /// [radius] sets the radius for rounded corners if [isCircle] is false.
  /// [pathImgError] is the asset path for the error image to display if the main image fails to load.
  const McImageFile({
    super.key,
    required this.file,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isCircle = false,
    this.radius,
    this.pathImgError,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: FileImage(file),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // Apply a circular shape if isCircle is true, otherwise use rectangular with radius
          borderRadius: !isCircle ? radius ?? BorderRadius.circular(10) : null,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          // Set the image as background
          image: DecorationImage(image: FileImage(file), fit: fit),
        ),
        child: height != null ? null : child,
      ),
      errorBuilder: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // Apply the same shape and radius settings as for the normal image
          borderRadius: !isCircle ? radius ?? BorderRadius.circular(10) : null,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          // Display the error image as background if the main image fails to load
          image: DecorationImage(
            image: AssetImage(pathImgError ?? ""),
            fit: fit,
          ),
        ),
      ),
    );
  }
}
