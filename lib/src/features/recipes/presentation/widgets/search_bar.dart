import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';

class RecipeSearchBar extends ConsumerWidget {
  const RecipeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).update(value);
          },
          decoration: InputDecoration(
            hintText: 'Search for ingredients or recipes...',
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2D3142)),
            suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).update('');
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
