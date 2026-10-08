import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';

/// Checkout em 3 etapas (uma decisão por tela), até o passo anterior ao pagamento.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;
  int _shipping = 0;
  final _form = GlobalKey<FormState>();
  final _addr = <String, String>{};

  static const _options = [
    ('Padrão', '5 a 8 dias úteis', 0.0),
    ('Expresso', '2 a 3 dias úteis', 24.90),
  ];

  double get _shipCost => cart.subtotal >= 199 && _shipping == 0 ? 0 : (_shipping == 0 ? cart.shipping : _options[1].$3);

  void _next() {
    if (_step == 0 && !_form.currentState!.validate()) return;
    if (_step == 0) _form.currentState!.save();
    if (_step < 2) {
      setState(() => _step++);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Pronto para pagar'),
          content: const Text('Este protótipo termina aqui, no passo imediatamente anterior ao pagamento.'),
          actions: [TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Voltar ao início'))],
        ),
      );
    }
  }

  Widget _field(String key, String label, {TextInputType? type}) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          keyboardType: type,
          decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
          onSaved: (v) => _addr[key] = v!.trim(),
        ),
      );

  Widget _body() {
    switch (_step) {
      case 0:
        return Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Endereço de entrega'),
            _field('nome', 'Nome completo'),
            _field('cep', 'CEP', type: TextInputType.number),
            _field('rua', 'Rua e número'),
            _field('cidade', 'Cidade'),
          ]),
        );
      case 1:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Forma de entrega'),
          RadioGroup<int>(
            groupValue: _shipping,
            onChanged: (v) => setState(() => _shipping = v!),
            child: Column(children: [
              for (var i = 0; i < _options.length; i++)
                RadioListTile<int>(
                  value: i,
                  contentPadding: EdgeInsets.zero,
                  title: Text(_options[i].$1),
                  subtitle: Text(_options[i].$2),
                  secondary: Text(i == 0 && cart.subtotal >= 199 ? 'Grátis' : brl(i == 0 ? cart.shipping : _options[i].$3)),
                ),
            ]),
          ),
        ]);
      default:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Revisão do pedido'),
          for (final it in cart.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text('${it.qty}× ${it.product.name} (${it.size})', overflow: TextOverflow.ellipsis)),
                Text(brl(it.product.price * it.qty)),
              ]),
            ),
          const Divider(height: 32),
          Text('Entrega: ${_addr['rua'] ?? ''}, ${_addr['cidade'] ?? ''} — CEP ${_addr['cep'] ?? ''}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text('${_options[_shipping].$1} · ${_options[_shipping].$2}', style: const TextStyle(color: Colors.black54)),
          const Divider(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(brl(cart.subtotal + _shipCost), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ]),
        ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step--);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Finalizar compra')),
        body: ListView(padding: const EdgeInsets.all(20), children: [StepHeader(_step), gap, _body()]),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: FilledButton(onPressed: _next, child: Text(_step == 2 ? 'Ir para pagamento' : 'Continuar')),
          ),
        ),
      ),
    );
  }
}
