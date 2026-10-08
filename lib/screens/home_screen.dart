import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'list_screen.dart';
import 'product_screen.dart';

/// Home enxuta: 1 busca, 1 destaque, 5 categorias, 1 grade curta.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SHEIN', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 4)), actions: const [CartButton()]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GestureDetector(
            onTap: () => _open(context, const ListScreen()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [Icon(Icons.search, color: Colors.black54), SizedBox(width: 10), Text('Buscar produtos', style: TextStyle(color: Colors.black54))]),
            ),
          ),
          gap,
          // Único destaque (em vez de vários banners rotativos).
          GestureDetector(
            onTap: () => _open(context, const ListScreen()),
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFFE8C9C4), borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.bottomLeft,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nova coleção', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('Ver peças da estação  →'),
                ],
              ),
            ),
          ),
          gap,
          const SectionTitle('Categorias'),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ActionChip(
                label: Text(categories[i]),
                backgroundColor: Colors.white,
                onPressed: () => _open(context, ListScreen(category: categories[i])),
              ),
            ),
          ),
          gap,
          SectionTitle('Em destaque', trailing: TextButton(onPressed: () => _open(context, const ListScreen()), child: const Text('Ver tudo'))),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72,
            children: [for (final p in products.take(4)) ProductCard(p, onTap: () => _open(context, ProductScreen(p)))],
          ),
        ],
      ),
    );
  }
}
