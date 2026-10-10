import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (context, _) {
        final list = products.where(favorites.has).toList();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Favoritos'), actions: const [CartIconButton()]),
          body: list.isEmpty
              ? EmptyState(
                  icon: Icons.favorite_border,
                  title: 'Nenhum favorito ainda',
                  message: 'Toque no coração na página de um produto para salvá-lo aqui.',
                  action: 'Ver produtos',
                  onAction: () => goToTab(context, 0),
                )
              : SingleChildScrollView(padding: const EdgeInsets.fromLTRB(12, 12, 12, 24), child: ProductGrid(list)),
        );
      },
    );
  }
}
