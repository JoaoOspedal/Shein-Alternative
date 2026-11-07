import 'package:flutter/material.dart';

import '../widgets.dart';

class Address {
  const Address({
    required this.name,
    required this.phone,
    required this.cep,
    required this.street,
    required this.number,
    this.complement = '',
    required this.city,
    required this.state,
  });

  final String name, phone, cep, street, number, complement, city, state;

  String get contact => '$name  ·  $phone';
  String get line => [
        '$street, $number${complement.isEmpty ? '' : ' ($complement)'}',
        '$city, $state',
        cep,
      ].join(' — ');
}

const defaultAddress = Address(
  name: 'Maria Souza',
  phone: '(41) 99999-0000',
  cep: '80000-000',
  street: 'Rua das Flores',
  number: '123',
  city: 'Curitiba',
  state: 'PR',
);

/// Edição do endereço de entrega. Devolve o novo [Address] ao salvar.
class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, required this.address});

  final Address address;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.address.name);
  late final _phone = TextEditingController(text: widget.address.phone);
  late final _cep = TextEditingController(text: widget.address.cep);
  late final _street = TextEditingController(text: widget.address.street);
  late final _number = TextEditingController(text: widget.address.number);
  late final _complement = TextEditingController(text: widget.address.complement);
  late final _city = TextEditingController(text: widget.address.city);
  late final _state = TextEditingController(text: widget.address.state);

  @override
  void dispose() {
    for (final c in [_name, _phone, _cep, _street, _number, _complement, _city, _state]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(
      context,
      Address(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        cep: _digits(_cep.text).replaceFirstMapped(RegExp(r'^(\d{5})(\d{3})$'), (m) => '${m[1]}-${m[2]}'),
        street: _street.text.trim(),
        number: _number.text.trim(),
        complement: _complement.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim().toUpperCase(),
      ),
    );
  }

  // H9: o erro diz qual campo falta, junto do próprio campo.
  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = true,
    TextInputType? keyboard,
    TextCapitalization caps = TextCapitalization.words,
    int? maxLength,
    String? Function(String value)? check,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          textCapitalization: caps,
          maxLength: maxLength,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: required ? label : '$label (opcional)',
            border: const OutlineInputBorder(),
            counterText: '',
            errorMaxLines: 2,
          ),
          validator: (v) {
            final value = (v ?? '').trim();
            if (value.isEmpty) return required ? 'Preencha o campo $label' : null;
            return check?.call(value);
          },
        ),
      );

  static String _digits(String s) => s.replaceAll(RegExp(r'\D'), '');

  static const _ufs = {
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
    'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
  };

  static final _letters = RegExp(r"^[A-Za-zÀ-ÿ' .-]+$");

  // H9: cada mensagem diz o que está errado e como corrigir.
  static String? _checkName(String v) {
    if (!_letters.hasMatch(v)) return 'Use apenas letras no nome';
    if (v.split(RegExp(r'\s+')).length < 2) return 'Informe nome e sobrenome';
    return null;
  }

  static String? _checkPhone(String v) {
    final d = _digits(v).length;
    if (d < 10 || d > 11 || RegExp(r'[^\d\s()+-]').hasMatch(v)) return 'Telefone inválido. Use DDD + número, ex.: (41) 99999-0000';
    return null;
  }

  static String? _checkCep(String v) =>
      RegExp(r'^\d{5}-?\d{3}$').hasMatch(v) ? null : 'CEP inválido. Use 8 números, ex.: 80000-000';

  static String? _checkNumber(String v) =>
      RegExp(r'^\d{1,6}[A-Za-z]?$').hasMatch(v) || v.toUpperCase() == 'S/N' ? null : 'Use números ou S/N';

  static String? _checkCity(String v) => _letters.hasMatch(v) && v.length >= 2 ? null : 'Cidade inválida';

  static String? _checkUf(String v) => _ufs.contains(v.toUpperCase()) ? null : 'UF inválida';

  static String? _checkStreet(String v) => v.length >= 3 ? null : 'Rua muito curta';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Endereço de entrega')),
      body: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_name, 'Nome completo', check: _checkName),
            _field(_phone, 'Telefone', keyboard: TextInputType.phone, maxLength: 16, check: _checkPhone),
            _field(_cep, 'CEP', keyboard: TextInputType.number, maxLength: 9, check: _checkCep),
            _field(_street, 'Rua', check: _checkStreet),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 110, child: _field(_number, 'Número', caps: TextCapitalization.characters, check: _checkNumber)),
              const SizedBox(width: 12),
              Expanded(child: _field(_complement, 'Complemento', required: false)),
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _field(_city, 'Cidade', check: _checkCity)),
              const SizedBox(width: 12),
              SizedBox(width: 90, child: _field(_state, 'UF', caps: TextCapitalization.characters, maxLength: 2, check: _checkUf)),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: line))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: FilledButton(onPressed: _save, child: const Text('SALVAR ENDEREÇO')),
          ),
        ),
      ),
    );
  }
}
