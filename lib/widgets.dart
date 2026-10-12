import 'package:flutter/material.dart';

import 'data.dart';
import 'screens/product_screen.dart';
import 'screens/quick_view.dart';

// Paleta da Shein: preto e branco, com laranja reservado a preço/desconto
// e verde a benefícios (frete, segurança).
const ink = Color(0xFF222222);
const promo = Color(0xFFFA6338);
const good = Color(0xFF198055);
const muted = Color(0xFF767676);
const surface = Color(0xFFF6F6F6);
const line = Color(0xFFE5E5E5);
const star = Color(0xFFFACF19);

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

class Stars extends StatelessWidget {
  final double value;
  final double size;
  const Stars(this.value, {super.key, this.size = 18});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Nota ${value.toStringAsFixed(1).replaceAll('.', ',')} de 5',
        excludeSemantics: true,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 1; i <= 5; i++)
            Icon(value >= i - 0.25 ? Icons.star : (value >= i - 0.75 ? Icons.star_half : Icons.star_border), size: size, color: star),
        ]),
      );
}

/// H2/H6: "Envio nacional" por extenso, no lugar da bandeira sobre a foto.
class NationalTag extends StatelessWidget {
  const NationalTag({super.key});

  @override
  Widget build(BuildContext context) => const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.local_shipping_outlined, size: 14, color: good),
        SizedBox(width: 4),
        Flexible(
          child: Text('Envio nacional',
              maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: good, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ]);
}

/// Mini carrinho do card: abre a compra rápida sem sair da lista.
class QuickAddButton extends StatelessWidget {
  final Product product;
  const QuickAddButton(this.product, {super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        child: Tooltip(
          message: 'Compra rápida',
          child: Material(
            color: surface,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showQuickView(context, product),
              child: const SizedBox(width: 40, height: 40, child: Icon(Icons.add_shopping_cart, size: 20, color: ink)),
            ),
          ),
        ),
      );
}

/// Card de produto: imagem, nome, vendidos, preço, desconto e envio nacional
/// em texto — sem selos sobrepostos à foto.
class ProductCard extends StatelessWidget {
  /// Largura dos cards nas faixas horizontais.
  static const compactWidth = 132.0;

  /// Altura do bloco de texto abaixo da imagem (3:4).
  static const infoHeight = 116.0;
  static double heightFor(double width) => width * 4 / 3 + infoHeight;

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
          const SizedBox(height: 2),
          Text(product.soldLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 4),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Price(product.price),
                const SizedBox(height: 2),
                Text('${product.off}% OFF', style: const TextStyle(color: promo, fontSize: 12)),
              ]),
            ),
            QuickAddButton(product),
          ]),
          if (product.national) const Padding(padding: EdgeInsets.only(top: 4), child: NationalTag()),
        ],
      ),
    );
  }
}

/// Faixa horizontal de cards compactos.
class ProductStrip extends StatelessWidget {
  final List<Product> items;
  const ProductStrip(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ProductCard.heightFor(ProductCard.compactWidth),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => SizedBox(width: ProductCard.compactWidth, child: ProductCard(items[i])),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<Product> items;
  const ProductGrid(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;
    return LayoutBuilder(
      builder: (_, box) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: gap,
          mainAxisSpacing: 20,
          mainAxisExtent: ProductCard.heightFor((box.maxWidth - gap) / 2),
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => ProductCard(items[i]),
      ),
    );
  }
}

/// Opção de variação (cor ou tamanho) com o mesmo estado de seleção.
class _Choice extends StatelessWidget {
  final String label;
  final bool selected;
  final bool error;
  final VoidCallback onTap;
  final Widget child;
  const _Choice({required this.label, required this.selected, this.error = false, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            constraints: const BoxConstraints(minWidth: 60),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: selected ? Colors.white : surface,
              border: Border.all(color: selected ? ink : (error ? promo : surface), width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(widthFactor: 1, child: child),
          ),
        ),
      );
}

/// H6: a amostra vem com o nome da cor, que também aparece no título.
class ColorPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const ColorPicker({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(TextSpan(
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        children: [const TextSpan(text: 'Cor: '), TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w400))],
      )),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, children: [
        for (final (name, color) in colorOptions)
          _Choice(
            label: 'Cor $name',
            selected: value == name,
            onTap: () => onChanged(name),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
          ),
      ]),
    ]);
  }
}

class SizePicker extends StatelessWidget {
  final String? value;
  final bool error;
  final ValueChanged<String> onChanged;
  const SizePicker({super.key, required this.value, this.error = false, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 10, runSpacing: 10, children: [
        for (final s in sizes)
          _Choice(
            label: 'Tamanho $s',
            selected: value == s,
            error: error,
            onTap: () => onChanged(s),
            child: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
      ]),
      if (error)
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(children: [
            Icon(Icons.error_outline, size: 18, color: promo),
            SizedBox(width: 6),
            Expanded(child: Text('Escolha um tamanho para adicionar ao carrinho.', style: TextStyle(color: promo, fontSize: 13))),
          ]),
        ),
    ]);
  }
}

/// H4: a mesma faixa de filtros na busca, em "Mais vendidos" e no carrinho.
class FilterPills<T> extends StatelessWidget {
  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final EdgeInsets padding;
  const FilterPills({super.key, required this.options, required this.value, required this.onChanged, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (option, label) = options[i];
          final selected = option == value;
          return Semantics(
            button: true,
            selected: selected,
            child: InkWell(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: selected ? ink : surface,
                child: Center(
                  widthFactor: 1,
                  child: Text(label,
                      style: TextStyle(fontSize: 13, color: selected ? Colors.white : ink, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                ),
              ),
            ),
          );
        },
      ),
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
  final Color borderColor;
  const SearchBox({super.key, required this.onTap, this.borderColor = ink});

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
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: borderColor, width: 1.5), borderRadius: BorderRadius.circular(6)),
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
