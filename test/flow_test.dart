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
    await shot(tester, '1_home');

    await tester.drag(find.text('Super Ofertas'), const Offset(0, -520));
    await tester.pumpAndSettle();
    await shot(tester, '2_home_rolada');

    await tester.tap(find.text('Camiseta Estampa Gótica'));
    await tester.pumpAndSettle();
    expect(find.text('ADICIONAR AO CARRINHO'), findsOneWidget);
    await shot(tester, '3_produto');

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
