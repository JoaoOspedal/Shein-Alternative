import 'package:flutter/material.dart';

import 'data.dart';
import 'screens/cart_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets.dart';

void main() => runApp(const SheinAlternativeApp());

/// Protótipo adaptado da interface da Shein para o usuário ocidental.
/// A aparência segue o app original; a escolha do que permanece em cada tela
/// segue as 10 heurísticas de Nielsen (ver docs/decisoes_heuristicas.md).
class SheinAlternativeApp extends StatelessWidget {
  const SheinAlternativeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shein Alternative',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: ink, primary: ink, surface: Colors.white),
        scaffoldBackgroundColor: surface,
        splashFactory: InkRipple.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontFamily: 'Roboto', color: ink, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ink,
            side: const BorderSide(color: ink),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
      ),
      home: const RootShell(),
    );
  }
}

class RootShell extends StatelessWidget {
  const RootShell({super.key});

  static const _screens = [HomeScreen(), CategoriesScreen(), CartScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([tabIndex, cart]),
      builder: (context, _) => Scaffold(
        body: IndexedStack(index: tabIndex.value, children: _screens),
        // H8/H4: quatro destinos. "Tendências" saiu por repetir o conteúdo da Loja.
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: line))),
          child: BottomNavigationBar(
            currentIndex: tabIndex.value,
            onTap: (i) => tabIndex.value = i,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: ink,
            unselectedItemColor: muted,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Loja'),
              const BottomNavigationBarItem(icon: Icon(Icons.manage_search), label: 'Categorias'),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: cart.count > 0,
                  backgroundColor: promo,
                  label: Text('${cart.count}'),
                  child: Icon(tabIndex.value == 2 ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                ),
                label: 'Carrinho',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}
