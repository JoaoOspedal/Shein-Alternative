import 'package:flutter/material.dart';

import 'data.dart';
import 'screens/cart_screen.dart';

const gap = SizedBox(height: 24);

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (_, _) => IconButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
        icon: Badge(
          isLabelVisible: cart.count > 0,
          label: Text('${cart.count}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final Product product;
  final double? height;
  const ProductImage(this.product, {super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: product.color, borderRadius: BorderRadius.circular(16)),
      child: Center(child: Icon(product.icon, size: 56, color: Colors.black38)),
    );
  }
}

class PriceText extends StatelessWidget {
  final Product product;
  const PriceText(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(brl(product.price), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      if (product.oldPrice case final old?) ...[
        const SizedBox(width: 8),
        Text(brl(old), style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black45, fontSize: 13)),
      ],
    ]);
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard(this.product, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ProductImage(product)),
          const SizedBox(height: 10),
          Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          PriceText(product),
        ],
      ),
    );
  }
}

/// Indicador de etapas do checkout (3 etapas = chunking).
class StepHeader extends StatelessWidget {
  final int current; // 0..2
  const StepHeader(this.current, {super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Endereço', 'Entrega', 'Revisão'];
    return Row(
      children: List.generate(3, (i) {
        final active = i <= current;
        return Expanded(
          child: Column(children: [
            Container(height: 3, margin: const EdgeInsets.symmetric(horizontal: 2), color: active ? Colors.black : Colors.black12),
            const SizedBox(height: 6),
            Text(labels[i],
                style: TextStyle(fontSize: 12, fontWeight: i == current ? FontWeight.w700 : FontWeight.w400, color: active ? Colors.black : Colors.black45)),
          ]),
        );
      }),
    );
  }
}
