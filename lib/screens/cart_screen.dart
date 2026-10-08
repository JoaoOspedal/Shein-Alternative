import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Sacola')),
        body: cart.items.isEmpty
            ? const Center(child: Text('Sua sacola está vazia', style: TextStyle(color: Colors.black54)))
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: cart.items.length,
                separatorBuilder: (_, _) => const Divider(height: 32),
                itemBuilder: (_, i) {
                  final it = cart.items[i];
                  return Row(children: [
                    SizedBox(width: 88, height: 104, child: ProductImage(it.product)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(it.product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Tamanho ${it.size}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                        const SizedBox(height: 8),
                        Text(brl(it.product.price), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    Column(children: [
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.changeQty(it, 1)),
                      Text('${it.qty}'),
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cart.changeQty(it, -1)),
                    ]),
                  ]);
                },
              ),
        bottomNavigationBar: cart.items.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _row('Subtotal', brl(cart.subtotal)),
                    _row('Frete', cart.shipping == 0 ? 'Grátis' : brl(cart.shipping)),
                    const SizedBox(height: 4),
                    _row('Total', brl(cart.total), bold: true),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                      child: const Text('Continuar'),
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}

Widget _row(String l, String v, {bool bold = false}) {
  final s = TextStyle(fontSize: bold ? 18 : 15, fontWeight: bold ? FontWeight.w700 : FontWeight.w400);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: s), Text(v, style: s)]),
  );
}
