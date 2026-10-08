import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const SheinAlternativeApp());

/// Protótipo adaptado da interface da Shein para o usuário ocidental.
/// Diretrizes: menor densidade por tela, espaço negativo, hierarquia visual
/// clara, chunking (máx. ~5-7 grupos por tela) e fluxo de compra simplificado.
class SheinAlternativeApp extends StatelessWidget {
  const SheinAlternativeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1A1A1A);
    return MaterialApp(
      title: 'Shein Alternative',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: ink, primary: ink, surface: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
