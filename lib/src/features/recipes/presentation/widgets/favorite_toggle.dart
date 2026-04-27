import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/meal.dart';
import '../providers/favorites_provider.dart';

class FavoriteToggle extends ConsumerStatefulWidget {
  const FavoriteToggle({
    super.key,
    required this.meal,
    this.size = 24,
  });

  final Meal meal;
  final double size;

  @override
  ConsumerState<FavoriteToggle> createState() => _FavoriteToggleState();
}

class _FavoriteToggleState extends ConsumerState<FavoriteToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (_controller.isAnimating) return;
    
    unawaited(HapticFeedback.mediumImpact());
    
    // Start animation
    await _controller.forward(from: 0.0);
    
    // Only update the global state AFTER the animation feels 'complete' (or mid-way for speed)
    if (mounted) {
      unawaited(ref.read(favoritesProvider.notifier).toggleFavorite(widget.meal));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(isFavoriteProvider(widget.meal.id));

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(isFav), // Stable key ensures correct switching
              color: isFav ? Colors.red : Colors.grey,
              size: widget.size,
            ),
          ),
        ),
      ),
    );
  }
}
