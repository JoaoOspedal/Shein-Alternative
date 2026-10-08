import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'product_screen.dart';

class ListScreen extends StatefulWidget {
  final String? category;
  const ListScreen({super.key, this.category});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String? _cat;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _cat = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final list = products
        .where((p) => (_cat == null || p.category == _cat) && p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(_cat ?? 'Todos os produtos'), actions: const [CartButton()]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final c in [null, ...categories])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c ?? 'Todos'),
                      selected: _cat == c,
                      onSelected: (_) => setState(() => _cat = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('Nenhum produto encontrado', style: TextStyle(color: Colors.black54)))
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => ProductCard(list[i], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(list[i])))),
                  ),
          ),
        ],
      ),
    );
  }
}
