import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../widgets.dart';
import 'favorites_screen.dart';
import 'list_screen.dart';

// Proporção do banner original; a faixa de destaque do carrossel a mantém.
const _bannerRatio = 738 / 262;
const _headerHeight = 92.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  int _dept = 1; // Masculino, como nos prints.

  bool get _showcase => _dept <= 1;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// 0 enquanto o carrossel está atrás do cabeçalho, 1 depois de rolar.
  double _solid(double width) {
    if (!_showcase) return 1;
    if (!_scroll.hasClients) return 0;
    final banner = width / _bannerRatio;
    return ((_scroll.offset - banner * 0.4) / (banner * 0.6)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + _headerHeight;
    return Stack(children: [
      Positioned.fill(
        child: _showcase
            ? _Showcase(controller: _scroll, headerHeight: top)
            : Padding(
                padding: EdgeInsets.only(top: top),
                child: _Unavailable(departments[_dept], onBack: () => setState(() => _dept = 1)),
              ),
      ),
      Positioned(top: 0, left: 0, right: 0, child: ListenableBuilder(listenable: _scroll, builder: (context, _) => _header(context))),
    ]);
  }

  // H1/H4: sobre o carrossel o cabeçalho é transparente com ícones brancos;
  // ao rolar, volta ao fundo branco com ícones pretos das outras telas.
  Widget _header(BuildContext context) {
    final t = _solid(MediaQuery.sizeOf(context).width);
    final fg = Color.lerp(Colors.white, ink, t)!;
    final dim = Color.lerp(Colors.white.withValues(alpha: 0.85), muted, t)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: t < 0.5 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Container(
        color: Colors.white.withValues(alpha: t),
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SizedBox(
          height: _headerHeight,
          child: Column(children: [
            // Do cabeçalho original ficam mensagens, busca e favoritos. Saem o
            // check-in diário, a busca por foto e o termo pré-preenchido.
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Row(children: [
                IconButton(
                  tooltip: 'Mensagens',
                  iconSize: 28,
                  color: fg,
                  icon: const Icon(Icons.mail_outline),
                  onPressed: () => push(context, const _MessagesScreen()),
                ),
                Expanded(child: SearchBox(borderColor: fg, onTap: () => push(context, const ListScreen(autofocus: true)))),
                IconButton(
                  tooltip: 'Favoritos',
                  iconSize: 28,
                  color: fg,
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () => push(context, const FavoritesScreen()),
                ),
              ]),
            ),
            const Spacer(),
            // H4: só departamentos nas abas ("Envio Nacional" era um filtro
            // misturado entre eles).
            Row(children: [
              for (var i = 0; i < departments.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _dept = i),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(departments[i],
                          style: TextStyle(fontSize: 15, fontWeight: i == _dept ? FontWeight.w700 : FontWeight.w400, color: i == _dept ? fg : dim)),
                      const SizedBox(height: 4),
                      Container(height: 3, width: 28, color: i == _dept ? fg : Colors.transparent),
                    ]),
                  ),
                ),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _Showcase extends StatefulWidget {
  final ScrollController controller;
  final double headerHeight;
  const _Showcase({required this.controller, required this.headerHeight});

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> {
  static final _pool = products.skip(4).toList();
  static final _filters = <(String, bool Function(Product))>[
    ('Todos', (_) => true),
    ('Em oferta', (p) => p.onSale),
    ('Envio nacional', (p) => p.national),
    for (final c in {for (final p in _pool) p.category}) (c, (p) => p.category == c),
  ];

  String _filter = _filters.first.$1;

  @override
  Widget build(BuildContext context) {
    final offers = products.take(4).toList();
    final test = _filters.firstWhere((f) => f.$1 == _filter).$2;
    final best = _pool.where(test).take(6).toList();
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.zero,
      children: [
        _Carousel(headerHeight: widget.headerHeight),
        const SizedBox(height: 8),
        Section(
          title: 'Categorias',
          trailing: _SeeAll(onTap: () => tabIndex.value = 1),
          child: const CategoryGrid(),
        ),
        Section(
          title: 'Super Ofertas',
          trailing: _SeeAll(onTap: () => push(context, const ListScreen())),
          child: ProductStrip(offers),
        ),
        Section(
          title: 'Mais vendidos',
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // H7: refinar a vitrine sem sair da página inicial.
            FilterPills<String>(
              options: [for (final f in _filters) (f.$1, f.$1)],
              value: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 16),
            ProductGrid(best),
          ]),
        ),
      ],
    );
  }
}

class _Slide {
  final String image;
  final String label;
  final String? kicker;
  final String? title;
  final String? category;
  const _Slide(this.image, this.label, {this.kicker, this.title, this.category});
}

const _slides = [
  // O banner original já traz o texto na imagem.
  _Slide('banner', 'Loja de tendências, até 50% OFF'),
  _Slide('p5', 'Camisetas com até 62% OFF', kicker: 'TREINO', title: 'Camisetas com\naté 62% OFF', category: 'Camisetas'),
  _Slide('p7', 'Jaquetas e moletons para o inverno', kicker: 'INVERNO', title: 'Jaquetas e\nmoletons', category: 'Jaquetas'),
];

/// Carrossel do topo. A imagem desfocada preenche o fundo até a borda da
/// tela, por trás do cabeçalho; o destaque ocupa a faixa de baixo.
///
/// H3: a troca automática é lenta, para enquanto o usuário toca ou arrasta e
/// respeita a preferência do sistema por menos animação. H1: os pontos
/// mostram quantos banners há e qual está à vista.
class _Carousel extends StatefulWidget {
  final double headerHeight;
  const _Carousel({required this.headerHeight});

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  static const _interval = Duration(seconds: 5);

  final _pages = PageController(initialPage: _slides.length * 1000);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _resume();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  void _resume() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      // Fora da aba Loja a animação fica suspensa.
      if (!mounted || !TickerMode.valuesOf(context).enabled || MediaQuery.disableAnimationsOf(context)) return;
      _pages.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stage = MediaQuery.sizeOf(context).width / _bannerRatio;
    return SizedBox(
      height: widget.headerHeight + stage,
      child: Stack(fit: StackFit.expand, children: [
        Listener(
          onPointerDown: (_) => _timer?.cancel(),
          onPointerUp: (_) => _resume(),
          onPointerCancel: (_) => _resume(),
          child: PageView.builder(
            controller: _pages,
            onPageChanged: (i) => setState(() => _index = i % _slides.length),
            itemBuilder: (_, i) => _SlideView(_slides[i % _slides.length], stage: stage),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: ExcludeSemantics(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var i = 0; i < _slides.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: i == _index ? 1 : 0.6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  final double stage;
  const _SlideView(this.slide, {required this.stage});

  // Funde a borda da imagem nítida com o fundo desfocado.
  Widget _fade(Widget child, {required Alignment from, required Alignment to}) => ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (r) =>
            LinearGradient(begin: from, end: to, colors: const [Colors.transparent, Colors.white], stops: const [0, 0.3]).createShader(r),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final asset = 'assets/images/${slide.image}.png';
    return Semantics(
      button: true,
      label: '${slide.label}. Comprar agora',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => push(context, ListScreen(category: slide.category)),
        child: Stack(fit: StackFit.expand, children: [
          ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24, tileMode: TileMode.clamp),
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),
          if (slide.title == null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: stage,
              child: _fade(Image.asset(asset, fit: BoxFit.cover, filterQuality: FilterQuality.medium), from: Alignment.topCenter, to: Alignment.bottomCenter),
            )
          else ...[
            // Contraste para o texto branco sobre a foto desfocada.
            ColoredBox(color: Colors.black.withValues(alpha: 0.35)),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: stage,
              child: _fade(
                Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.topCenter, filterQuality: FilterQuality.medium),
                from: Alignment.centerLeft,
                to: Alignment.centerRight,
              ),
            ),
            Positioned(
              left: 16,
              right: stage,
              bottom: 16,
              height: stage - 16,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(slide.kicker!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                const SizedBox(height: 2),
                Text(slide.title!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, height: 1.15)),
                const SizedBox(height: 8),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: const Text('COMPRE AGORA', style: TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
              ]),
            ),
          ],
          // Escurece o topo para os ícones brancos do cabeçalho.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                stops: const [0, 0.7],
              ),
            ),
          ),
        ]),
      ),
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

class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mensagens')),
        body: const EmptyState(
          icon: Icons.mail_outline,
          title: 'Nenhuma mensagem',
          message: 'Avisos sobre pedidos e entregas aparecem aqui.',
        ),
      );
}
