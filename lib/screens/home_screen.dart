import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets.dart';
import 'favorites_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _dept = 1; // Masculino, como nos prints.

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // H8: do cabeçalho original ficam a busca e os favoritos. Saem
          // mensagens, check-in diário, busca por foto e o termo pré-preenchido.
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
            child: Row(children: [
              Expanded(child: SearchBox(onTap: () => push(context, const ListScreen(autofocus: true)))),
              IconButton(
                tooltip: 'Favoritos',
                iconSize: 28,
                icon: const Icon(Icons.favorite_border),
                onPressed: () => push(context, const FavoritesScreen()),
              ),
            ]),
          ),
          // H4: só departamentos nas abas ("Envio Nacional" era um filtro
          // misturado entre eles).
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10),
            child: Row(children: [
              for (var i = 0; i < departments.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _dept = i),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(departments[i],
                          style: TextStyle(fontSize: 15, fontWeight: i == _dept ? FontWeight.w700 : FontWeight.w400, color: i == _dept ? ink : muted)),
                      const SizedBox(height: 4),
                      Container(height: 3, width: 28, color: i == _dept ? ink : Colors.transparent),
                    ]),
                  ),
                ),
            ]),
          ),
          Expanded(child: _dept <= 1 ? const _Showcase() : _Unavailable(departments[_dept], onBack: () => setState(() => _dept = 1))),
        ],
      ),
    );
  }
}

class _Showcase extends StatelessWidget {
  const _Showcase();

  @override
  Widget build(BuildContext context) {
    final offers = products.take(4).toList();
    final best = products.skip(4).take(6).toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // H3/H8: um banner fixo no lugar do carrossel automático.
        Semantics(
          button: true,
          label: 'Loja de tendências, até 50% OFF. Comprar agora',
          child: GestureDetector(
            onTap: () => push(context, const ListScreen()),
            // Proporção fixa: o espaço é reservado antes de a imagem carregar.
            child: AspectRatio(
              aspectRatio: 738 / 262,
              child: Image.asset('assets/images/banner.png', fit: BoxFit.cover, filterQuality: FilterQuality.medium),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Section(
          title: 'Categorias',
          trailing: _SeeAll(onTap: () => tabIndex.value = 1),
          child: const CategoryGrid(),
        ),
        Section(
          title: 'Super Ofertas',
          trailing: _SeeAll(onTap: () => push(context, const ListScreen())),
          child: SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: offers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => SizedBox(width: 112, child: ProductCard(offers[i])),
            ),
          ),
        ),
        Section(title: 'Mais vendidos', child: ProductGrid(best)),
      ],
    );
  }
}

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, mainAxisExtent: 92),
      children: [for (final c in categories) CategoryTile(c.$1, c.$2)],
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String name;
  final String image;
  const CategoryTile(this.name, this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => push(context, ListScreen(category: name)),
      child: Column(children: [
        ClipOval(child: Image.asset('assets/images/$image.png', width: 64, height: 64, fit: BoxFit.cover)),
        const SizedBox(height: 6),
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
      ]),
    );
  }
}

class _SeeAll extends StatelessWidget {
  final VoidCallback onTap;
  const _SeeAll({required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Ver tudo', style: TextStyle(fontSize: 13)),
            Icon(Icons.chevron_right, size: 20),
          ]),
        ),
      );
}

class _Unavailable extends StatelessWidget {
  final String name;
  final VoidCallback onBack;
  const _Unavailable(this.name, {required this.onBack});

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: Icons.storefront_outlined,
        title: '$name não está neste protótipo',
        message: 'O protótipo cobre o departamento Masculino.',
        action: 'Ver Masculino',
        onAction: onBack,
      );
}
