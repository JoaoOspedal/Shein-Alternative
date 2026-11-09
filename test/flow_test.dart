import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shein_alternative/data.dart';
import 'package:shein_alternative/main.dart';

// Com `--dart-define=SHOTS=true --update-goldens` o teste também grava as
// telas do protótipo em docs/telas/v2/. As telas da primeira versão ficam
// em docs/telas/ e não são regravadas.
const shots = bool.fromEnvironment('SHOTS');
const shotsDir = '../docs/telas/v2';

Future<void> loadFonts() async {
  final dir = '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  Future<ByteData> read(String f) async => ByteData.view((await File('$dir/$f').readAsBytes()).buffer);
  final roboto = FontLoader('Roboto');
  for (final f in ['roboto-regular.ttf', 'roboto-medium.ttf', 'roboto-bold.ttf']) {
    roboto.addFont(read(f));
  }
  await roboto.load();
  await (FontLoader('MaterialIcons')..addFont(read('materialicons-regular.otf'))).load();
}

Finder field(String label) => find.widgetWithText(TextFormField, label);

/// Rola a lista até deixar o texto no meio da tela, longe da barra do app.
Future<void> center(WidgetTester tester, String text) async {
  await Scrollable.ensureVisible(tester.element(find.text(text)), alignment: 0.5);
  await tester.pumpAndSettle();
}

Future<void> shot(WidgetTester tester, String name) async {
  if (!shots) return;
  await tester.runAsync(() async {
    for (final e in find.byType(Image).evaluate()) {
      await precacheImage((e.widget as Image).image, e);
    }
  });
  await tester.pumpAndSettle();
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$shotsDir/$name.png'));
}

void main() {
  // Fontes reais para que o layout medido seja o mesmo do aparelho.
  setUpAll(loadFonts);

  testWidgets('fluxo de compra até o passo anterior ao pagamento', (tester) async {
    tester.view.physicalSize = const Size(824, 1830);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SheinAlternativeApp());
    expect(find.text('Super Ofertas'), findsOneWidget);
    expect(find.byTooltip('Mensagens'), findsOneWidget);
    await shot(tester, '1_home');

    // O carrossel troca sozinho de banner.
    expect(find.bySemanticsLabel('Camisetas com até 62% OFF. Comprar agora'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Camisetas com até 62% OFF. Comprar agora'), findsOneWidget);
    await shot(tester, '10_home_carrossel');

    await tester.drag(find.text('Super Ofertas'), const Offset(0, -520));
    await tester.pumpAndSettle();
    await shot(tester, '2_home_rolada');

    // Filtros de "Mais vendidos".
    expect(find.text('Camiseta Texturizada'), findsOneWidget);
    await tester.tap(find.text('Em oferta'));
    await tester.pumpAndSettle();
    expect(find.text('Camiseta Texturizada'), findsNothing);
    expect(find.text('Jeans Reto Estampa Vermelha'), findsOneWidget);
    await shot(tester, '11_home_filtro');
    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();

    // Compra rápida pelo mini carrinho do card.
    expect(find.text('+12 mil vendidos'), findsOneWidget);
    await tester.tap(find.byTooltip('Compra rápida').first);
    await tester.pumpAndSettle();
    expect(find.text('Ver detalhes'), findsOneWidget);
    await shot(tester, '8_compra_rapida');

    await tester.tap(find.text('ADICIONAR AO CARRINHO'));
    await tester.pumpAndSettle();
    expect(cart.count, 0);
    expect(find.text('Escolha um tamanho para adicionar ao carrinho.'), findsOneWidget);

    await tester.tap(find.text('Cinza'));
    await tester.tap(find.text('G'));
    await tester.pump();
    await tester.tap(find.text('ADICIONAR AO CARRINHO'));
    await tester.pumpAndSettle();
    expect(find.text('Ver detalhes'), findsNothing);
    expect(cart.items.single.variant, 'Cinza · Tamanho G');
    cart.items.clear();
    ScaffoldMessenger.of(tester.element(find.text('Super Ofertas'))).removeCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Camiseta Estampa Gótica'));
    await tester.pumpAndSettle();
    expect(find.text('ADICIONAR AO CARRINHO'), findsOneWidget);
    await shot(tester, '3_produto');

    // A nota leva às avaliações.
    await tester.tap(find.text('4210 avaliações'));
    await tester.pumpAndSettle();
    expect(find.text('Avaliações (4210)'), findsOneWidget);
    await shot(tester, '9_produto_avaliacoes');
    expect(find.text('m***a'), findsNothing);
    await tester.tap(find.text('Ver mais avaliações'));
    await tester.pump();
    expect(find.text('m***a'), findsOneWidget);
    await tester.tap(find.text('Útil (3)'));
    await tester.pump();
    expect(find.text('Útil (4)'), findsOneWidget);

    // Sem tamanho: nada entra no carrinho e o erro aparece.
    await tester.tap(find.text('ADICIONAR AO CARRINHO'));
    await tester.pumpAndSettle();
    expect(cart.count, 0);
    expect(find.text('Escolha um tamanho para adicionar ao carrinho.'), findsOneWidget);
    await shot(tester, '4_produto_erro_tamanho');

    await tester.tap(find.text('M'));
    await tester.pump();
    await tester.tap(find.text('ADICIONAR AO CARRINHO'));
    await tester.pumpAndSettle();
    expect(cart.count, 1);
    // Notificação no estilo do app, com ícone e atalho para o carrinho.
    expect(find.text('Adicionado ao carrinho'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    await shot(tester, '13_produto_adicionado');

    await tester.tap(find.text('VER CARRINHO'));
    await tester.pumpAndSettle();
    expect(find.text('Carrinho (1)'), findsOneWidget);
    expect(find.text('FINALIZAR (1)'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    await shot(tester, '5_carrinho');

    // A seta volta para a aba de onde o usuário veio.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(tabIndex.value, 0);
    tabIndex.value = 2;
    await tester.pumpAndSettle();
    expect(find.text('Carrinho (1)'), findsOneWidget);

    // O filtro do carrinho aparece a partir de dois itens e não altera o total.
    expect(find.text('Todos (1)'), findsNothing);
    cart.add(products[2], 'G', 'Preto');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Em oferta (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Calça Jeans Wide Estampada'), findsNothing);
    expect(find.text('FINALIZAR (2)'), findsOneWidget);
    await shot(tester, '12_carrinho_filtro');
    cart.remove(cart.items.last);
    await tester.pumpAndSettle();

    // Remover pede confirmação; cancelar mantém o item.
    await tester.tap(find.byTooltip('Remover item'));
    await tester.pumpAndSettle();
    expect(find.text('Remover este item?'), findsOneWidget);
    await shot(tester, '14_carrinho_confirmar_remocao');
    await tester.tap(find.text('CANCELAR'));
    await tester.pumpAndSettle();
    expect(find.text('Remover este item?'), findsNothing);
    expect(cart.count, 1);

    // Confirmar remove, e a notificação permite desfazer.
    await tester.tap(find.byTooltip('Remover item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('REMOVER'));
    await tester.pumpAndSettle();
    expect(find.text('Seu carrinho está vazio'), findsOneWidget);
    expect(find.text('Item removido do carrinho'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    await shot(tester, '15_carrinho_removido');
    await tester.tap(find.text('DESFAZER'));
    await tester.pumpAndSettle();
    expect(cart.count, 1);

    await tester.tap(find.text('FINALIZAR (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Finalizar (1)'), findsOneWidget);
    await shot(tester, '6_finalizar');

    // Edição do endereço, com verificação dos dados.
    await tester.tap(find.text('Alterar'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Endereço de entrega'), findsOneWidget);
    expect(find.text('Maria Souza'), findsOneWidget);
    await shot(tester, '16_endereco');

    await tester.enterText(field('Telefone'), '9999');
    await tester.enterText(field('CEP'), '812');
    await tester.enterText(field('Número'), 'abc');
    await tester.enterText(field('UF'), 'XX');
    await tester.tap(find.text('SALVAR ENDEREÇO'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Endereço de entrega'), findsOneWidget);
    expect(find.text('Telefone inválido. Use DDD + número, ex.: (41) 99999-0000'), findsOneWidget);
    expect(find.text('CEP inválido. Use 8 números, ex.: 80000-000'), findsOneWidget);
    expect(find.text('Use números ou S/N'), findsOneWidget);
    expect(find.text('UF inválida'), findsOneWidget);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await shot(tester, '17_endereco_erros');

    await tester.enterText(field('Telefone'), '(41) 98888-7777');
    await tester.enterText(field('CEP'), '81200100');
    await tester.enterText(field('Rua'), 'Rua XV de Novembro');
    await tester.enterText(field('Número'), '500');
    await tester.enterText(field('UF'), 'pr');
    await tester.tap(find.text('SALVAR ENDEREÇO'));
    await tester.pumpAndSettle();
    expect(find.text('Finalizar (1)'), findsOneWidget);
    expect(find.text('Maria Souza  ·  (41) 98888-7777'), findsOneWidget);
    expect(find.text('Rua XV de Novembro, 500 — Curitiba, PR — 81200-100'), findsOneWidget);
    ScaffoldMessenger.of(tester.element(find.text('Finalizar (1)'))).removeCurrentSnackBar();
    await tester.pumpAndSettle();

    // Entrega agendada: o dia aparece só quando a opção é escolhida.
    expect(find.text('Ter, 21 out'), findsNothing);
    await center(tester, 'Entrega agendada');
    await tester.tap(find.text('Entrega agendada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ter, 21 out'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Frete agendado'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Frete agendado'), findsOneWidget);
    await center(tester, 'Entrega agendada');
    await shot(tester, '18_finalizar_entrega_agendada');
    await center(tester, 'Entrega padrão');
    await tester.tap(find.text('Entrega padrão'));
    await tester.pumpAndSettle();
    expect(find.text('Ter, 21 out'), findsNothing);
    await tester.scrollUntilVisible(find.text('Endereço de entrega'), -300, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    // Sem data de nascimento o fluxo não avança.
    await tester.tap(find.text('IR PARA PAGAMENTO'));
    await tester.pumpAndSettle();
    expect(find.text('Fim do protótipo'), findsNothing);

    await tester.tap(find.text('Adicionar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nascimento:'), findsOneWidget);

    ScaffoldMessenger.of(tester.element(find.text('Finalizar (1)'))).removeCurrentSnackBar();
    await tester.drag(find.text('Itens'), const Offset(0, -700));
    await tester.pumpAndSettle();
    await shot(tester, '7_finalizar_resumo');

    // Ajuda a um toque, abaixo do detalhamento do valor.
    await tester.tap(find.text('Dúvidas sobre o pedido? Fale com a ajuda'));
    await tester.pumpAndSettle();
    expect(find.text('Ajuda'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Finalizar (1)'), findsOneWidget);

    await tester.tap(find.text('IR PARA PAGAMENTO'));
    await tester.pumpAndSettle();
    expect(find.text('Fim do protótipo'), findsOneWidget);
  });
}
