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
  String? _size;
  bool _sizeError = false;
  bool _moreDetails = false;

  void _addToCart() {
    // H5/H9: o botão fica sempre ativo; sem tamanho, a tela mostra onde
    // está a pendência em vez de falhar em silêncio.
    if (_size == null) {
      setState(() => _sizeError = true);
      Scrollable.ensureVisible(_sizeKey.currentContext!, duration: const Duration(milliseconds: 250), alignment: 0.3);
      return;
    }
    cart.add(widget.product, _size!);
    // H1: confirmação da ação, com atalho para o próximo passo.
    toast(context, 'Adicionado ao carrinho', action: 'VER CARRINHO', onAction: () => goToTab(context, 2));
  }

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
      body: ListView(
        children: [
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
              Row(children: [
                const Icon(Icons.star, size: 18, color: Color(0xFFFACF19)),
                const SizedBox(width: 4),
                Text('${p.rating.toStringAsFixed(1).replaceAll('.', ',')}  ·  ${p.reviews} avaliações', style: const TextStyle(fontSize: 13)),
              ]),
            ]),
          ),
          Section(
            key: _sizeKey,
            title: 'Tamanho',
            // H10: uma única ajuda de medidas (o original tem duas entradas).
            trailing: InkWell(
              onTap: _sizeGuide,
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.straighten, size: 18),
                SizedBox(width: 4),
                Text('Guia de tamanhos', style: TextStyle(fontSize: 13, decoration: TextDecoration.underline)),
              ]),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 10, children: [
                for (final s in sizes)
                  Semantics(
                    button: true,
                    selected: _size == s,
                    label: 'Tamanho $s',
                    child: InkWell(
                      onTap: () => setState(() {
                        _size = s;
                        _sizeError = false;
                      }),
                      child: Container(
                        width: 60,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _size == s ? Colors.white : surface,
                          border: Border.all(color: _size == s ? ink : (_sizeError ? promo : surface), width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
              ]),
              if (_sizeError)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(children: [
                    Icon(Icons.error_outline, size: 18, color: promo),
                    SizedBox(width: 6),
                    Text('Escolha um tamanho para adicionar ao carrinho.', style: TextStyle(color: promo, fontSize: 13)),
                  ]),
                ),
            ]),
          ),
          // H2: prazo em datas, sem "60% de probabilidade de entrega".
          Section(
            title: 'Entrega e garantias',
            child: Column(children: [
              _info(Icons.local_shipping_outlined, 'Frete grátis acima de ${brl(Cart.freeShippingFrom)}', subtitle: 'Chega entre 17 e 25 de outubro', color: good),
              const Divider(),
              _info(Icons.assignment_return_outlined, 'Devolução gratuita em até 20 dias'),
              const Divider(),
              _info(Icons.verified_user_outlined, 'Pagamento seguro e dados protegidos'),
            ]),
          ),
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
            child: SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => SizedBox(width: 112, child: ProductCard(related[i])),
              ),
            ),
          ),
        ],
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
