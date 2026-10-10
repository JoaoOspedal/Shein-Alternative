import 'package:flutter/material.dart';

import '../widgets.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(children: [
        const SizedBox(height: 8),
        Material(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.favorite_border, color: ink),
              title: const Text('Favoritos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, const FavoritesScreen()),
            ),
            const Divider(indent: 16),
            // H10: ajuda sempre ao alcance, a partir do perfil.
            ListTile(
              leading: const Icon(Icons.help_outline, color: ink),
              title: const Text('Ajuda'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, const HelpScreen()),
            ),
          ]),
        ),
      ]),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faq = [
    ('Como escolho o tamanho?', 'Na página do produto, toque em "Guia de tamanhos" para ver as medidas de cada tamanho em centímetros.'),
    ('Quando o frete é grátis?', 'Em compras a partir de R\$ 199,00. O carrinho mostra quanto falta para chegar a esse valor.'),
    ('Como devolvo um produto?', 'A devolução é gratuita em até 20 dias após a entrega.'),
    ('Por que pedem a data de nascimento?', 'Ela é exigida para a liberação de compras internacionais e é informada uma única vez, na finalização.'),
    ('Removi um item sem querer. E agora?', 'Logo após a remoção aparece a opção "Desfazer" na parte de baixo da tela.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Ajuda')),
      body: ListView(children: [
        for (final q in _faq)
          ExpansionTile(
            shape: const Border(),
            title: Text(q.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedAlignment: Alignment.centerLeft,
            children: [Text(q.$2, style: const TextStyle(color: muted))],
          ),
      ]),
    );
  }
}
