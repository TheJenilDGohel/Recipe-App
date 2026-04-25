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
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    _controller.forward(from: 0.0);
    ref.read(favoritesProvider.notifier).toggleFavorite(widget.meal);
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
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? const Color(0xFF7C3AED) : Colors.grey,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
