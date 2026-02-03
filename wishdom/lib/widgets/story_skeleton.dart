import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class StorySkeleton extends StatelessWidget {
  const StorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[800]!,
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(100, 20),
                const SizedBox(height: 12),
                _buildShimmerBox(double.infinity, 16),
                const SizedBox(height: 8),
                _buildShimmerBox(200, 16),
                const SizedBox(height: 12),
                _buildShimmerBox(150, 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
