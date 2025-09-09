import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// [McImageNetWork] is a widget for displaying images from network URLs.
/// It includes placeholders while loading, and error handling for when the image fails to load.
/// Supports circular or rectangular image shapes and customizable dimensions.
class McImageNetWork extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final String? pathImgError;
  final BoxFit fit;
  final bool isCircle;
  final BorderRadius? radius;

  /// Constructs an instance of [McImageNetWork] with the provided parameters.
  ///
  /// [url] is the network URL of the image to be displayed.
  /// [height] and [width] define the dimensions of the image.
  /// [fit] specifies how the image should fit within its container.
  /// [isCircle] determines whether the image should be displayed as a circle.
  /// [radius] sets the radius for rounded corners if [isCircle] is false.
  /// [pathImgError] is the asset path for the error image to display if the main image fails to load.
  const McImageNetWork({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isCircle = false,
    this.radius,
    this.pathImgError,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // Apply a circular shape if isCircle is true, otherwise use rectangular with radius
          borderRadius: !isCircle ? radius ?? BorderRadius.circular(10) : null,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          // Set the image as background
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
      ),
      // ignore: sized_box_for_whitespace
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
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
