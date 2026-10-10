import 'package:flutter/material.dart';

import 'data.dart';
import 'screens/product_screen.dart';

// Paleta da Shein: preto e branco, com laranja reservado a preço/desconto
// e verde a benefícios (frete, segurança).
const ink = Color(0xFF222222);
const promo = Color(0xFFFA6338);
const good = Color(0xFF198055);
const muted = Color(0xFF767676);
const surface = Color(0xFFF6F6F6);
const line = Color(0xFFE5E5E5);

void push(BuildContext context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

void goToTab(BuildContext context, int index) {
  Navigator.of(context).popUntil((r) => r.isFirst);
  tabIndex.value = index;
}

void toast(BuildContext context, String message, {String? action, VoidCallback? onAction}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4),
      action: action == null ? null : SnackBarAction(label: action, onPressed: onAction ?? () {}),
    ));
}

/// Preço no estilo da Shein: "R$" e centavos menores que a parte inteira.
class Price extends StatelessWidget {
  final double value;
  final double size;
  const Price(this.value, {super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    final parts = value.toStringAsFixed(2).split('.');
    final small = TextStyle(fontSize: size * 0.68);
    return Text.rich(
      TextSpan(
        style: TextStyle(color: promo, fontSize: size, fontWeight: FontWeight.w700, height: 1.1),
        children: [
          TextSpan(text: 'R\$', style: small),
          TextSpan(text: parts[0]),
          TextSpan(text: ',${parts[1]}', style: small),
        ],
      ),
    );
  }
}

class OldPrice extends StatelessWidget {
  final double value;
  const OldPrice(this.value, {super.key});

  @override
  Widget build(BuildContext context) => Text(brl(value),
      style: const TextStyle(color: muted, fontSize: 12, decoration: TextDecoration.lineThrough, decorationColor: muted));
}

class OffTag extends StatelessWidget {
  final int percent;
  const OffTag(this.percent, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(border: Border.all(color: promo), borderRadius: BorderRadius.circular(3)),
        child: Text('-$percent%', style: const TextStyle(color: promo, fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

class ProductImage extends StatelessWidget {
  final Product product;
  final double ratio;
  const ProductImage(this.product, {super.key, this.ratio = 3 / 4});

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: ratio,
        child: Image.asset(product.asset, fit: BoxFit.cover, filterQuality: FilterQuality.medium),
      );
}

/// Card de produto: imagem, nome, preço e desconto — sem selos sobrepostos.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => push(context, ProductScreen(product)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(product),
          const SizedBox(height: 8),
          Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Price(product.price),
          const SizedBox(height: 2),
          Text('${product.off}% OFF', style: const TextStyle(color: promo, fontSize: 12)),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<Product> items;
  const ProductGrid(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        mainAxisExtent: 320,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => ProductCard(items[i]),
    );
  }
}

/// Bloco branco sobre o fundo cinza, como as seções do app original.
class Section extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Widget child;
  const Section({super.key, this.title, this.trailing, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: Text(title!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                ?trailing,
              ],
            ),
          ),
        child,
      ],
    );
  }
}

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (_, _) => IconButton(
        tooltip: 'Carrinho',
        onPressed: () => goToTab(context, 2),
        icon: Badge(
          isLabelVisible: cart.count > 0,
          backgroundColor: promo,
          label: Text('${cart.count}'),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final Product product;
  const FavoriteButton(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (_, _) {
        final on = favorites.has(product);
        return IconButton(
          tooltip: on ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
          iconSize: 28,
          icon: Icon(on ? Icons.favorite : Icons.favorite_border, color: on ? promo : ink),
          onPressed: () {
            favorites.toggle(product);
            toast(context, on ? 'Removido dos favoritos' : 'Salvo nos favoritos');
          },
        );
      },
    );
  }
}

/// H4: o mesmo controle de quantidade no carrinho e no checkout
/// (o original usa lista suspensa em um e botões −/+ no outro).
class QtyStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const QtyStepper({super.key, required this.value, required this.onChanged});

  Widget _btn(IconData icon, String tip, VoidCallback? onTap) => InkWell(
        onTap: onTap,
        child: Tooltip(
          message: tip,
          child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 18, color: onTap == null ? line : ink)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: line), borderRadius: BorderRadius.circular(4)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _btn(Icons.remove, 'Diminuir', value > 1 ? () => onChanged(value - 1) : null),
        SizedBox(width: 28, child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600))),
        _btn(Icons.add, 'Aumentar', value < 10 ? () => onChanged(value + 1) : null),
      ]),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? action;
  final VoidCallback? onAction;
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56, color: muted),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: muted)),
          if (action != null) ...[
            const SizedBox(height: 20),
            SizedBox(width: 220, child: FilledButton(onPressed: onAction, child: Text(action!))),
          ],
        ]),
      ),
    );
  }
}

/// Campo de busca com o botão preto característico do app original.
class SearchBox extends StatelessWidget {
  final VoidCallback onTap;
  const SearchBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Buscar produtos',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(border: Border.all(color: ink, width: 1.5), borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            const SizedBox(width: 10),
            const Expanded(child: Text('Buscar produtos', style: TextStyle(color: muted, fontSize: 15))),
            Container(
              width: 48,
              decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(4)),
              child: const Center(child: Icon(Icons.search, color: Colors.white, size: 22)),
            ),
          ]),
        ),
      ),
    );
  }
}
