import 'package:flutter/material.dart';

class AnimatedCircularProgress extends StatefulWidget {
  const AnimatedCircularProgress({super.key});

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.repeat(); // Loop forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return CircularProgressIndicator(
            value: _progressAnimation.value, // 👈 Controlled value from 0 to 1
            strokeWidth: 6.0,
            color: Theme.of(context).colorScheme.primary,
          );
        },
      ),
    );
  }
}
