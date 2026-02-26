import 'package:flutter/material.dart';

class ShimmerGalleryWidget extends StatelessWidget {
  final Widget headerWidget;

  const ShimmerGalleryWidget({super.key, required this.headerWidget});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerWidget,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _ShimmerSkeletonGallery(),
          ),
        ],
      ),
    );
  }
}

class _ShimmerSkeletonGallery extends StatefulWidget {
  @override
  State<_ShimmerSkeletonGallery> createState() =>
      _ShimmerSkeletonGalleryState();
}

class _ShimmerSkeletonGalleryState extends State<_ShimmerSkeletonGallery>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = brightness == Brightness.light
        ? const Color.fromRGBO(220, 220, 220, 1.0)
        : const Color.fromRGBO(50, 50, 50, 1.0);
    final highlightColor = brightness == Brightness.light
        ? const Color.fromRGBO(245, 245, 245, 1.0)
        : const Color.fromRGBO(80, 80, 80, 1.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2.0 * _controller.value, -0.3),
              end: Alignment(2.0 * _controller.value, 0.3),
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: _buildSkeleton(),
    );
  }

  Widget _buildSkeleton() {
    const skeletonColor = Color.fromRGBO(217, 217, 217, 0.4);
    const memoryAspectRatio = 0.75;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3 * memoryAspectRatio,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              childAspectRatio: memoryAspectRatio,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(14),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 72,
          height: 20,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: 24,
          itemBuilder: (context, index) {
            return Container(
              color: skeletonColor,
            );
          },
        ),
      ],
    );
  }
}
