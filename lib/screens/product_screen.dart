import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'list_screen.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen(this.product, {super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _sizeKey = GlobalKey();
  final _reviewsKey = GlobalKey();
  String _color = colorOptions.first.$1;
  String? _size;
  bool _sizeError = false;
  bool _moreDetails = false;

  void _addToCart() {
    // H5/H9: o botão fica sempre ativo; sem tamanho, a tela mostra onde
    // está a pendência em vez de falhar em silêncio.
    if (_size == null) {
      setState(() => _sizeError = true);
      _scrollTo(_sizeKey);
      return;
    }
    cart.add(widget.product, _size!, _color);
    // H1: confirmação da ação, com atalho para o próximo passo.
    toast(context, 'Adicionado ao carrinho', action: 'VER CARRINHO', onAction: () => goToTab(context, 2));
  }

  void _scrollTo(GlobalKey key) =>
      Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 250), alignment: 0.3);

  void _sizeGuide() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Guia de tamanhos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Table(
            border: const TableBorder(horizontalInside: BorderSide(color: line)),
            children: [
              for (final r in const [
                ['Tamanho', 'Peito (cm)', 'Comprimento (cm)'],
                ['P', '96 – 100', '66'],
                ['M', '101 – 106', '68'],
                ['G', '107 – 112', '70'],
                ['GG', '113 – 118', '72'],
              ])
                TableRow(children: [
                  for (final c in r)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(c, style: TextStyle(fontWeight: r[0] == 'Tamanho' ? FontWeight.w700 : FontWeight.w400)),
                    ),
                ]),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _info(IconData icon, String title, {String? subtitle, Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 22, color: ink),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: color == null ? FontWeight.w400 : FontWeight.w700, color: color ?? ink)),
              if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(subtitle, style: const TextStyle(color: muted, fontSize: 13))),
            ]),
          ),
        ]),
      );

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: muted))),
          Expanded(child: Text(value)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final related = products.where((o) => o.id != p.id && o.category == p.category).followedBy(products.where((o) => o.category != p.category)).take(4).toList();
    return Scaffold(
      // H8: o cabeçalho leva só voltar, buscar e carrinho; "denunciar" foi
      // para o menu, por ser ação rara.
      appBar: AppBar(
        actions: [
          IconButton(tooltip: 'Buscar', icon: const Icon(Icons.search), onPressed: () => push(context, const ListScreen(autofocus: true))),
          const CartIconButton(),
          PopupMenuButton<String>(
            tooltip: 'Mais opções',
            onSelected: (v) => toast(context, v == 'share' ? 'Link do produto copiado' : 'Denúncia registrada. Obrigado por avisar.'),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'share', child: Text('Compartilhar')),
              PopupMenuItem(value: 'report', child: Text('Denunciar produto')),
            ],
          ),
        ],
      ),
      // Coluna inteira montada: os atalhos de rolagem alcançam qualquer seção.
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(color: Colors.white, child: ProductImage(p, ratio: 1)),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Price(p.price, size: 26),
                const SizedBox(width: 8),
                OffTag(p.off),
                const SizedBox(width: 8),
                OldPrice(p.oldPrice),
              ]),
              const SizedBox(height: 12),
              Text(p.brand, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              // H2/H8: nome curto no lugar do título com palavras-chave em série.
              Text(p.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              // H7: a nota leva às avaliações (no original, uma aba "Comentários").
              InkWell(
                onTap: () => _scrollTo(_reviewsKey),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    const Icon(Icons.star, size: 18, color: star),
                    const SizedBox(width: 4),
                    Text(p.ratingLabel, style: const TextStyle(fontSize: 13)),
                    const Text('  ·  ', style: TextStyle(fontSize: 13)),
                    Text('${p.reviews} avaliações', style: const TextStyle(fontSize: 13, decoration: TextDecoration.underline)),
                    Expanded(child: Text('  ·  ${p.soldLabel}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13))),
                  ]),
                ),
              ),
              if (p.national) const Padding(padding: EdgeInsets.only(top: 4), child: NationalTag()),
            ]),
          ),
          // H6: cor e tamanho no mesmo bloco, com os mesmos controles da
          // compra rápida.
          Section(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ColorPicker(value: _color, onChanged: (c) => setState(() => _color = c)),
              const SizedBox(height: 20),
              Row(key: _sizeKey, children: [
                const Expanded(child: Text('Tamanho', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                // H10: uma única ajuda de medidas (o original tem duas entradas).
                InkWell(
                  onTap: _sizeGuide,
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.straighten, size: 18),
                    SizedBox(width: 4),
                    Text('Guia de tamanhos', style: TextStyle(fontSize: 13, decoration: TextDecoration.underline)),
                  ]),
                ),
              ]),
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
          // H2: prazo em datas, sem "60% de probabilidade de entrega".
          Section(
            title: 'Entrega e garantias',
            child: Column(children: [
              _info(Icons.local_shipping_outlined, 'Frete grátis acima de ${brl(Cart.freeShippingFrom)}', subtitle: p.national ? 'Envio nacional · chega entre 15 e 19 de outubro' : 'Chega entre 17 e 25 de outubro', color: good),
              const Divider(),
              _info(Icons.assignment_return_outlined, 'Devolução gratuita em até 20 dias'),
              const Divider(),
              _info(Icons.verified_user_outlined, 'Pagamento seguro e dados protegidos'),
            ]),
          ),
          _Reviews(p, key: _reviewsKey),
          Section(
            title: 'Detalhes',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _detail('Material', p.material),
              _detail('Composição', p.composition),
              if (_moreDetails) ...[
                _detail('Modelagem', 'Regular'),
                _detail('Lavagem', 'À máquina, água fria'),
                _detail('Vendido por', p.brand),
              ],
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _moreDetails = !_moreDetails),
                  child: Text(_moreDetails ? 'Ver menos' : 'Ver mais', style: const TextStyle(color: ink, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
          Section(
            title: 'Você também pode gostar',
            child: ProductStrip(related),
          ),
        ]),
      ),
      // H4/H8: um CTA com rótulo estável ("25% DE DESCONTO!" saiu do botão).
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: line))),
        child: SafeArea(
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
    );
  }
}

/// H8: das avaliações originais ficam a nota, o ajuste do tamanho e os
/// comentários com a variação comprada. Saem as etiquetas de palavras-chave
/// ("sem odores (5)"), o ícone de tradução e o menu "..." de cada comentário.
class _Reviews extends StatefulWidget {
  final Product product;
  const _Reviews(this.product, {super.key});

  @override
  State<_Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<_Reviews> {
  final _helpful = <Review>{};
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Section(
      title: 'Avaliações (${p.reviews})',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(p.ratingLabel, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1)),
          const SizedBox(width: 8),
          Stars(p.rating, size: 22),
        ]),
        const SizedBox(height: 12),
        // H5: o ajuste em uma frase ajuda a acertar o tamanho antes da compra.
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(4)),
          child: const Row(children: [
            Icon(Icons.straighten, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('87% acharam o tamanho fiel', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('3% acharam pequeno · 10% acharam grande', style: TextStyle(color: muted, fontSize: 13)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 4),
        for (final r in _all ? reviews : reviews.take(3)) ...[
          _review(r),
          const Divider(),
        ],
        Center(
          child: TextButton(
            onPressed: () => setState(() => _all = !_all),
            child: Text(_all ? 'Ver menos' : 'Ver mais avaliações', style: const TextStyle(color: ink, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  Widget _review(Review r) {
    final on = _helpful.contains(r);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(r.user, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Stars(r.stars.toDouble(), size: 15),
          const Spacer(),
          Text('${r.color} · Tamanho ${r.size}', style: const TextStyle(color: muted, fontSize: 12)),
        ]),
        const SizedBox(height: 6),
        Text(r.text),
        Align(
          alignment: Alignment.centerRight,
          // H1: o botão muda de estado ao marcar o comentário como útil.
          child: TextButton.icon(
            onPressed: () => setState(() => on ? _helpful.remove(r) : _helpful.add(r)),
            style: TextButton.styleFrom(foregroundColor: on ? ink : muted, visualDensity: VisualDensity.compact),
            icon: Icon(on ? Icons.thumb_up : Icons.thumb_up_outlined, size: 16),
            label: Text('Útil (${r.helpful + (on ? 1 : 0)})', style: TextStyle(fontSize: 13, fontWeight: on ? FontWeight.w700 : FontWeight.w400)),
          ),
        ),
      ]),
    );
  }
}
