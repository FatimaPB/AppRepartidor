import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum SkeletonType { rectangle, circle }

class Skeleton extends StatelessWidget {
  final double height;
  final double? width;
  final SkeletonType type;

  const Skeleton({
    Key? key,
    required this.height,
    this.width,
    this.type = SkeletonType.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: type == SkeletonType.circle
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(8),
        ),
      ),
    );
  }
}
