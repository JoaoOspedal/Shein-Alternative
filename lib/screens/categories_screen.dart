import 'package:flutter/material.dart';

import '../widgets.dart';
import 'home_screen.dart';
import 'list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(tooltip: 'Buscar', icon: const Icon(Icons.search), onPressed: () => push(context, const ListScreen(autofocus: true))),
        ],
      ),
      body: ListView(children: [
        const SizedBox(height: 8),
        Section(
          title: 'Masculino',
          child: const CategoryGrid(),
        ),
        Material(
          color: Colors.white,
          child: ListTile(
            title: const Text('Todos os produtos', style: TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => push(context, const ListScreen()),
          ),
        ),
      ]),
    );
  }
}
