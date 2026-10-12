import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'product_screen.dart';

/// H7: compra rápida a partir do card. O painel sobe sobre a lista com o
/// resumo do produto e as mesmas escolhas da tela de produto.
Future<void> showQuickView(BuildContext context, Product product) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    sheetAnimationStyle: const AnimationStyle(
      duration: Duration(milliseconds: 320),
      reverseDuration: Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ),
    builder: (_) => _QuickView(product),
  );
}

class _QuickView extends StatefulWidget {
  final Product product;
  const _QuickView(this.product);

  @override
  State<_QuickView> createState() => _QuickViewState();
}

class _QuickViewState extends State<_QuickView> {
  String _color = colorOptions.first.$1;
  String? _size;
  bool _sizeError = false;

  void _addToCart() {
    if (_size == null) {
      setState(() => _sizeError = true);
      return;
    }
    cart.add(widget.product, _size!, _color);
    // O painel fecha antes de o atalho ser usado, então a navegação é
    // guardada aqui.
    final nav = Navigator.of(context);
    toast(context, 'Adicionado ao carrinho', action: 'VER CARRINHO', onAction: () {
      nav.popUntil((r) => r.isFirst);
      tabIndex.value = 2;
    });
    nav.pop();
  }

  void _openDetails() {
    final nav = Navigator.of(context)..pop();
    nav.push(MaterialPageRoute(builder: (_) => ProductScreen(widget.product)));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // H8: uma foto ao lado do resumo, já que não há galeria.
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(width: 120, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: ProductImage(p))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.star, size: 16, color: star),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text('${p.ratingLabel}  ·  ${p.soldLabel}',
                            maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12)),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Price(p.price, size: 22),
                      OffTag(p.off),
                      OldPrice(p.oldPrice),
                    ]),
                    if (p.national) const Padding(padding: EdgeInsets.only(top: 8), child: NationalTag()),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: _openDetails,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('Ver detalhes', style: TextStyle(fontSize: 13, decoration: TextDecoration.underline)),
                          Icon(Icons.chevron_right, size: 18),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ),
              // H3: saída visível, além do toque fora e do gesto de arrastar.
              IconButton(tooltip: 'Fechar', icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ]),
            const SizedBox(height: 16),
            ColorPicker(value: _color, onChanged: (c) => setState(() => _color = c)),
            const SizedBox(height: 16),
            const Text('Tamanho', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizePicker(
              value: _size,
              error: _sizeError,
              onChanged: (s) => setState(() {
                _size = s;
                _sizeError = false;
              }),
            ),
          ]),
        ),
      ),
      Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: line))),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Row(children: [
              FavoriteButton(p),
              const SizedBox(width: 4),
              Expanded(child: FilledButton(onPressed: _addToCart, child: const Text('ADICIONAR AO CARRINHO'))),
            ]),
          ),
        ),
      ),
    ]);
  }
}
