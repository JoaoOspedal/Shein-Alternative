import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';

enum _Sort {
  relevance('Mais relevantes'),
  priceAsc('Menor preço'),
  priceDesc('Maior preço'),
  discount('Maior desconto');

  final String label;
  const _Sort(this.label);
}

/// Listagem e busca de produtos.
class ListScreen extends StatefulWidget {
  final String? category;
  final bool autofocus;
  const ListScreen({super.key, this.category, this.autofocus = false});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _controller = TextEditingController();
  String? _cat;
  _Sort _sort = _Sort.relevance;

  @override
  void initState() {
    super.initState();
    _cat = widget.category;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Product> get _results {
    final q = _controller.text.trim().toLowerCase();
    final list = products.where((p) => (_cat == null || p.category == _cat) && p.name.toLowerCase().contains(q)).toList();
    switch (_sort) {
      case _Sort.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
      case _Sort.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
      case _Sort.discount:
        list.sort((a, b) => b.off.compareTo(a.off));
      case _Sort.relevance:
    }
    return list;
  }

  void _clear() => setState(() {
        _controller.clear();
        _cat = null;
      });

  @override
  Widget build(BuildContext context) {
    final list = _results;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(6)),
          child: TextField(
            controller: _controller,
            autofocus: widget.autofocus,
            textInputAction: TextInputAction.search,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: 'Buscar produtos',
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              // H3: limpar a busca com um toque.
              suffixIcon: _controller.text.isEmpty
                  ? const Icon(Icons.search, color: muted)
                  : IconButton(tooltip: 'Limpar busca', icon: const Icon(Icons.close, size: 20), onPressed: () => setState(_controller.clear)),
            ),
          ),
        ),
        actions: const [CartIconButton()],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                for (final c in [null, ...categories.map((c) => c.$1)])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(label: c ?? 'Todos', selected: _cat == c, onTap: () => setState(() => _cat = c)),
                  ),
              ],
            ),
          ),
          // H1: quantos resultados há e como estão ordenados.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
            child: Row(children: [
              Expanded(child: Text('${list.length} ${list.length == 1 ? 'produto' : 'produtos'}', style: const TextStyle(color: muted, fontSize: 13))),
              PopupMenuButton<_Sort>(
                initialValue: _sort,
                onSelected: (s) => setState(() => _sort = s),
                itemBuilder: (_) => [for (final s in _Sort.values) PopupMenuItem(value: s, child: Text(s.label))],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(_sort.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const Icon(Icons.expand_more, size: 20),
                  ]),
                ),
              ),
            ]),
          ),
          Expanded(
            child: list.isEmpty
                // H9: diz o que houve e oferece a saída.
                ? EmptyState(
                    icon: Icons.search_off,
                    title: 'Nenhum produto encontrado',
                    message: 'Confira a grafia ou tente um termo mais geral, como "camiseta".',
                    action: 'Limpar busca e filtros',
                    onAction: _clear,
                  )
                : SingleChildScrollView(padding: const EdgeInsets.fromLTRB(12, 4, 12, 24), child: ProductGrid(list)),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          color: selected ? ink : surface,
          child: Text(label, style: TextStyle(fontSize: 13, color: selected ? Colors.white : ink, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        ),
      );
}
