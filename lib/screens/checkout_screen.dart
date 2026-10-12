import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';

const _couponCode = 'BEMVINDO10';

/// Finalização em uma única tela, como no original, até o passo
/// imediatamente anterior ao pagamento.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressKey = GlobalKey();
  DateTime? _birthDate;
  bool _birthError = false;
  int _payment = 0;
  bool _coupon = false;
  bool _breakdown = false;

  static const _payments = [
    (Icons.pix, 'Pix', 'Aprovação na hora'),
    (Icons.credit_card, 'Cartão de crédito', 'Visa final 1234 · até 6x sem juros'),
    (Icons.account_balance_wallet_outlined, 'PayPal', 'Você conclui na conta PayPal'),
  ];

  double get _couponValue => _coupon ? cart.subtotal * 0.10 : 0;
  double get _total => cart.subtotal - _couponValue + cart.shipping;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      helpText: 'Data de nascimento',
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthDate = picked;
      _birthError = false;
    });
    toast(context, 'Data de nascimento salva');
  }

  Future<void> _editCoupon() async {
    final ok = await showDialog<bool>(context: context, builder: (_) => const _CouponDialog());
    if (ok != true || !mounted) return;
    setState(() => _coupon = true);
    toast(context, 'Cupom $_couponCode aplicado');
  }

  void _continue() {
    // H5/H9: a pendência é apontada onde pode ser resolvida.
    if (_birthDate == null) {
      setState(() => _birthError = true);
      Scrollable.ensureVisible(_addressKey.currentContext!, duration: const Duration(milliseconds: 250));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Fim do protótipo'),
        content: Text('O fluxo termina aqui, no passo anterior ao pagamento de ${brl(_total)} via ${_payments[_payment].$2}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Revisar pedido')),
          TextButton(onPressed: () => goToTab(context, 0), child: const Text('Voltar à loja')),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? color, bool strong = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: strong ? 16 : 14, fontWeight: strong ? FontWeight.w700 : FontWeight.w400))),
          Text(value, style: TextStyle(fontSize: strong ? 16 : 14, fontWeight: strong ? FontWeight.w700 : FontWeight.w400, color: color)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        final items = cart.selected.toList();
        final born = _birthDate;
        return Scaffold(
          appBar: AppBar(title: Text('Finalizar (${cart.selectedCount})')),
          body: ListView(
            children: [
              const SizedBox(height: 8),
              // H4/H9: o aviso da data de nascimento aparece uma vez, com a
              // ação ao lado (no original são dois avisos e nenhum botão).
              Section(
                key: _addressKey,
                title: 'Endereço de entrega',
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.location_on_outlined, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Maria Souza  ·  (41) 99999-0000', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text('Rua das Flores, 123 — Curitiba, PR — 80000-000', style: TextStyle(color: muted, fontSize: 13)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  if (born == null)
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4EF),
                        border: Border.all(color: _birthError ? promo : const Color(0xFFFFD9CC), width: _birthError ? 1.5 : 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(children: [
                        const Icon(Icons.info_outline, size: 20, color: promo),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Falta sua data de nascimento, exigida em compras internacionais.', style: TextStyle(fontSize: 13)),
                        ),
                        TextButton(onPressed: _pickBirthDate, child: const Text('Adicionar', style: TextStyle(color: ink, fontWeight: FontWeight.w700))),
                      ]),
                    )
                  else
                    Row(children: [
                      const Icon(Icons.check_circle, size: 18, color: good),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nascimento: ${born.day.toString().padLeft(2, '0')}/${born.month.toString().padLeft(2, '0')}/${born.year}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton(onPressed: _pickBirthDate, child: const Text('Alterar', style: TextStyle(color: ink))),
                    ]),
                ]),
              ),
              // H8: sem "8 restantes" e "Última chance!".
              Section(
                title: 'Itens',
                child: Column(children: [
                  for (final it in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 72, child: ProductImage(it.product, ratio: 1)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(it.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(it.variant, style: const TextStyle(color: muted, fontSize: 13)),
                            const SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Price(it.product.price, size: 16)),
                              QtyStepper(value: it.qty, onChanged: (v) => cart.setQty(it, v)),
                            ]),
                          ]),
                        ),
                      ]),
                    ),
                ]),
              ),
              // H2/H4: "Frete grátis" em português e três linhas de envio
              // reunidas em uma.
              Section(
                title: 'Envio',
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.local_shipping_outlined, size: 22),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Entrega padrão', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Chega entre 17 e 25 de outubro', style: TextStyle(color: muted, fontSize: 13)),
                      Text('Reembolso em caso de extravio ou dano', style: TextStyle(color: muted, fontSize: 13)),
                    ]),
                  ),
                  Text(cart.shipping == 0 ? 'Frete grátis' : brl(cart.shipping),
                      style: TextStyle(fontWeight: FontWeight.w700, color: cart.shipping == 0 ? good : ink)),
                ]),
              ),
              // H4/H8: três formas de pagamento distintas (o original repete
              // o mesmo cartão e o Pix em linhas separadas).
              Section(
                title: 'Forma de pagamento',
                child: RadioGroup<int>(
                  groupValue: _payment,
                  onChanged: (v) => setState(() => _payment = v!),
                  child: Column(children: [
                    for (var i = 0; i < _payments.length; i++)
                      RadioListTile<int>(
                        value: i,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: ink,
                        title: Text(_payments[i].$2, style: const TextStyle(fontSize: 15)),
                        subtitle: Text(_payments[i].$3, style: const TextStyle(color: muted)),
                        secondary: Icon(_payments[i].$1, color: ink),
                      ),
                  ]),
                ),
              ),
              Section(
                title: 'Resumo',
                child: Column(children: [
                  InkWell(
                    onTap: _coupon ? () => setState(() => _coupon = false) : _editCoupon,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(children: [
                        const Icon(Icons.confirmation_number_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_coupon ? 'Cupom $_couponCode' : 'Cupom de desconto')),
                        Text(_coupon ? 'Remover' : 'Adicionar', style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
                      ]),
                    ),
                  ),
                  const Divider(height: 16),
                  // Chunking: quatro linhas no lugar das onze do original;
                  // o detalhamento fica a um toque (divulgação progressiva).
                  _row('Produtos', brl(cart.fullPrice)),
                  _row('Descontos', '- ${brl(cart.discount + _couponValue)}', color: promo),
                  if (_breakdown) ...[
                    Padding(padding: const EdgeInsets.only(left: 12), child: _row('Promoções', '- ${brl(cart.discount)}')),
                    if (_coupon) Padding(padding: const EdgeInsets.only(left: 12), child: _row('Cupom', '- ${brl(_couponValue)}')),
                  ],
                  _row('Frete', cart.shipping == 0 ? 'Grátis' : brl(cart.shipping), color: cart.shipping == 0 ? good : null),
                  if (_breakdown) Padding(padding: const EdgeInsets.only(left: 12), child: _row('Impostos (ICMS e importação)', 'Inclusos')),
                  const Divider(height: 16),
                  _row('Total', brl(_total), strong: true),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: ink),
                      onPressed: () => setState(() => _breakdown = !_breakdown),
                      child: Text(_breakdown ? 'Ocultar detalhes' : 'Ver detalhes do valor', style: const TextStyle(decoration: TextDecoration.underline)),
                    ),
                  ),
                ]),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Row(children: [
                  Icon(Icons.verified_user_outlined, size: 18, color: good),
                  SizedBox(width: 8),
                  Expanded(child: Text('Pagamento seguro · Devolução gratuita em até 20 dias', style: TextStyle(color: muted, fontSize: 13))),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: line))),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(children: [
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Total', style: TextStyle(color: muted, fontSize: 12)),
                    Price(_total, size: 22),
                  ]),
                  const SizedBox(width: 20),
                  // H2: o rótulo diz o que acontece a seguir ("Continuar
                  // compra" não dizia).
                  Expanded(child: FilledButton(onPressed: items.isEmpty ? null : _continue, child: const Text('IR PARA PAGAMENTO'))),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CouponDialog extends StatefulWidget {
  const _CouponDialog();

  @override
  State<_CouponDialog> createState() => _CouponDialogState();
}

class _CouponDialogState extends State<_CouponDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {
    final code = _controller.text.trim().toUpperCase();
    if (code == _couponCode) {
      Navigator.pop(context, true);
      return;
    }
    // H9: erro em linguagem simples, com o que fazer em seguida.
    setState(() => _error = code.isEmpty ? 'Digite o código do cupom.' : 'Cupom "$code" não existe. Confira o código e tente de novo.');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Cupom de desconto'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        onSubmitted: (_) => _apply(),
        decoration: InputDecoration(
          labelText: 'Código',
          helperText: 'No protótipo, use $_couponCode',
          errorText: _error,
          errorMaxLines: 2,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(onPressed: _apply, child: const Text('Aplicar')),
      ],
    );
  }
}
