import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';

/// Página de produto: imagem, título/preço, tamanho e um único CTA.
class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen(this.product, {super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? _size;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(actions: const [CartButton()]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          ProductImage(p, height: 340),
          gap,
          Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${p.rating}  ·  ${p.reviews} avaliações', style: const TextStyle(color: Colors.black54)),
          ]),
          const SizedBox(height: 12),
          DefaultTextStyle.merge(style: const TextStyle(fontSize: 22), child: PriceText(p)),
          gap,
          const SectionTitle('Tamanho'),
          Wrap(spacing: 8, children: [
            for (final s in p.sizes) ChoiceChip(label: Text(s), selected: _size == s, onSelected: (_) => setState(() => _size = s)),
          ]),
          gap,
          const Text('Frete grátis acima de R\$ 199,00. Devolução em até 30 dias.', style: TextStyle(color: Colors.black54)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: _size == null
                ? null
                : () {
                    cart.add(p, _size!);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text('Adicionado à sacola')));
                  },
            child: Text(_size == null ? 'Selecione um tamanho' : 'Adicionar à sacola'),
          ),
        ),
      ),
    );
  }
}
