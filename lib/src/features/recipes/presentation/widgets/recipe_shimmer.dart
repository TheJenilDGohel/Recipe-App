import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecipeListShimmer extends StatelessWidget {
  const RecipeListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: const RecipeCardShimmer(),
        );
      },
    );
  }
}

class RecipeCardShimmer extends StatelessWidget {
  const RecipeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class RecipeDetailShimmer extends StatelessWidget {
  const RecipeDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 380, color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 200, height: 32, color: Colors.white),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(width: 80, height: 32, color: Colors.white),
                    const SizedBox(width: 12),
                    Container(width: 80, height: 32, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 32),
                Container(width: 150, height: 24, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 150, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
