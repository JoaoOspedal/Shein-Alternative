import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'checkout_screen.dart';
import 'product_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _remove(BuildContext context, CartItem item) {
    final index = cart.remove(item);
    // H3/H5: remoção direta, com desfazer.
    toast(context, 'Item removido do carrinho', action: 'DESFAZER', onAction: () => cart.insert(index, item));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        if (cart.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Carrinho')),
            body: EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Seu carrinho está vazio',
              message: 'Os produtos que você adicionar aparecem aqui.',
              action: 'Ver produtos',
              onAction: () => tabIndex.value = 0,
            ),
          );
        }
        final missing = cart.missingForFreeShipping;
        return Scaffold(
          appBar: AppBar(title: Text('Carrinho (${cart.count})')),
          body: ListView(
            children: [
              // H1: uma mensagem de frete com progresso, no lugar de duas
              // faixas promocionais concorrentes.
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.local_shipping_outlined, size: 20, color: good),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cart.subtotal == 0
                            ? 'Frete grátis em compras acima de ${brl(Cart.freeShippingFrom)}'
                            : missing > 0
                                ? 'Faltam ${brl(missing)} para o frete grátis'
                                : 'Você ganhou frete grátis',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: missing > 0 ? ink : good),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (cart.subtotal / Cart.freeShippingFrom).clamp(0, 1).toDouble(),
                    minHeight: 4,
                    backgroundColor: line,
                    color: good,
                  ),
                ]),
              ),
              Container(
                color: Colors.white,
                child: Column(children: [
                  InkWell(
                    onTap: cart.toggleAll,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                      child: Row(children: [
                        Checkbox(value: cart.allSelected, onChanged: (_) => cart.toggleAll(), shape: const CircleBorder()),
                        const Text('Selecionar tudo', style: TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                  const Divider(),
                  for (final item in cart.items) _CartRow(item, onRemove: () => _remove(context, item)),
                ]),
              ),
              const SizedBox(height: 16),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: line))),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(children: [
              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Total', style: TextStyle(color: muted, fontSize: 12)),
                Price(cart.subtotal, size: 22),
              ]),
              const SizedBox(width: 20),
              Expanded(
                // H5: sem itens selecionados o botão informa o motivo, em vez
                // de abrir um checkout de R$ 0,00.
                child: FilledButton(
                  onPressed: cart.selectedCount == 0 ? null : () => push(context, const CheckoutScreen()),
                  child: Text(cart.selectedCount == 0 ? 'SELECIONE UM ITEM' : 'FINALIZAR (${cart.selectedCount})'),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

/// H8: do item original ficam imagem, nome, variação, preço e quantidade.
/// Saem "100+ visualizando agora", "8 restantes", "Último dia" e
/// "Economias Aleatórias".
class _CartRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  const _CartRow(this.item, {required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 8, 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Checkbox(value: item.selected, onChanged: (_) => cart.toggle(item), shape: const CircleBorder()),
        ),
        GestureDetector(
          onTap: () => push(context, ProductScreen(p)),
          child: SizedBox(width: 84, child: ProductImage(p, ratio: 1)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
              InkWell(
                onTap: onRemove,
                child: const Tooltip(
                  message: 'Remover item',
                  child: Padding(padding: EdgeInsets.all(6), child: Icon(Icons.delete_outline, size: 22, color: muted)),
                ),
              ),
            ]),
            Text('Tamanho ${item.size}', style: const TextStyle(color: muted, fontSize: 13)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Wrap(crossAxisAlignment: WrapCrossAlignment.end, spacing: 6, children: [Price(p.price), OldPrice(p.oldPrice)]),
              ),
              QtyStepper(value: item.qty, onChanged: (v) => cart.setQty(item, v)),
            ]),
          ]),
        ),
      ]),
    );
  }
}
