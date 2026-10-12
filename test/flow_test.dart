import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shein_alternative/data.dart';
import 'package:shein_alternative/main.dart';

// Com `--dart-define=SHOTS=true --update-goldens` o teste também grava as
// telas do protótipo em docs/telas/.
const shots = bool.fromEnvironment('SHOTS');

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

Future<void> shot(WidgetTester tester, String name) async {
  if (!shots) return;
  await tester.runAsync(() async {
    for (final e in find.byType(Image).evaluate()) {
      await precacheImage((e.widget as Image).image, e);
    }
  });
  await tester.pumpAndSettle();
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('../docs/telas/$name.png'));
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

    await tester.tap(find.text('VER CARRINHO'));
    await tester.pumpAndSettle();
    expect(find.text('Carrinho (1)'), findsOneWidget);
    expect(find.text('FINALIZAR (1)'), findsOneWidget);
    await shot(tester, '5_carrinho');

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

    // Remover e desfazer.
    await tester.tap(find.byTooltip('Remover item'));
    await tester.pumpAndSettle();
    expect(find.text('Seu carrinho está vazio'), findsOneWidget);
    await tester.tap(find.text('DESFAZER'));
    await tester.pumpAndSettle();
    expect(cart.count, 1);

    await tester.tap(find.text('FINALIZAR (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Finalizar (1)'), findsOneWidget);
    await shot(tester, '6_finalizar');

    // Sem data de nascimento o fluxo não avança.
    await tester.tap(find.text('IR PARA PAGAMENTO'));
    await tester.pumpAndSettle();
    expect(find.text('Fim do protótipo'), findsNothing);

    await tester.tap(find.text('Adicionar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nascimento:'), findsOneWidget);

    await tester.drag(find.text('Itens'), const Offset(0, -700));
    await tester.pumpAndSettle();
    await shot(tester, '7_finalizar_resumo');

    await tester.tap(find.text('IR PARA PAGAMENTO'));
    await tester.pumpAndSettle();
    expect(find.text('Fim do protótipo'), findsOneWidget);
  });
}
