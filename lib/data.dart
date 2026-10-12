import 'package:flutter/material.dart';

class Product {
  final int id;
  final String brand;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviews;
  final String image;
  final String material;
  final String composition;
  final int sold;
  final bool national;

  const Product({
    required this.id,
    this.brand = 'ROMWE MEN',
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.image,
    this.material = 'Tecido',
    this.composition = '100% Poliéster',
    required this.sold,
    this.national = false,
  });

  int get off => ((1 - price / oldPrice) * 100).round();
  /// Critério do filtro "Em oferta" e do selo de desconto no carrinho.
  bool get onSale => off >= 30;
  String get ratingLabel => rating.toStringAsFixed(1).replaceAll('.', ',');

  /// "+5 mil vendidos": arredondado para baixo, como no original.
  String get soldLabel => '+${sold >= 1000 ? '${sold ~/ 1000} mil' : '${sold ~/ 100 * 100}'} vendidos';
  String get asset => 'assets/images/$image.png';
}

// H2: tamanhos no padrão brasileiro (o original usa S/M/L/XL).
const sizes = ['P', 'M', 'G', 'GG'];

// Ilustrativo: cada produto tem uma só foto, então a cor não troca a imagem.
const colorOptions = <(String, Color)>[
  ('Preto', Color(0xFF222222)),
  ('Cinza', Color(0xFF8A8A8A)),
  ('Vinho', Color(0xFF7A1F2B)),
];

class Review {
  final String user;
  final int stars;
  final String color;
  final String size;
  final String text;
  final int helpful;
  const Review(this.user, this.stars, this.color, this.size, this.text, this.helpful);
}

// Avaliações fictícias, as mesmas para todos os produtos.
const reviews = <Review>[
  Review('5***6', 5, 'Preto', 'P', 'A estampa é de muita qualidade. Compraria de novo!', 3),
  Review('v***7', 5, 'Preto', 'G', 'Tecido bom e acabamento bem feito. Chegou antes do prazo.', 1),
  Review('J***z', 4, 'Vinho', 'GG', 'Gostei do tecido e do caimento. A cor é um pouco mais escura que na foto.', 1),
  Review('x***t', 5, 'Preto', 'P', 'O desenho é muito bonito e a peça é confortável.', 2),
  Review('m***a', 4, 'Cinza', 'M', 'Veste bem e não desbotou depois de lavar.', 0),
];

// Chunking: 8 categorias (7±2) no lugar das 15+ da tela original.
// H2: rótulos naturais ("Jaquetas" em vez de "Roupa de exterior").
const categories = <(String, String)>[
  ('Camisetas', 'cat_camisetas'),
  ('Moletons', 'cat_moletons'),
  ('Suéteres', 'p4'),
  ('Jaquetas', 'cat_jaquetas'),
  ('Jeans', 'cat_jeans'),
  ('Calças', 'cat_calcas'),
  ('Shorts', 'cat_shorts'),
  ('Camisas', 'cat_camisas'),
];

const departments = ['Tudo', 'Masculino', 'Feminino', 'Esporte'];

const products = <Product>[
  Product(id: 1, sold: 12400, national: true, name: 'Camiseta Estampa Gótica', category: 'Camisetas', price: 29.99, oldPrice: 49.99, rating: 4.8, reviews: 4210, image: 'p1', material: 'Malha'),
  Product(id: 2, sold: 5300, name: 'Moletom com Capuz Goth', category: 'Moletons', price: 150.49, oldPrice: 214.99, rating: 4.7, reviews: 1890, image: 'p2', material: 'Moletom'),
  Product(id: 3, sold: 2100, national: true, name: 'Calça Jeans Wide Estampada', category: 'Jeans', price: 180.00, oldPrice: 240.00, rating: 4.6, reviews: 932, image: 'p3', material: 'Jeans', composition: '100% Algodão'),
  Product(id: 4, sold: 3800, name: 'Suéter Estampa Esqueleto', category: 'Suéteres', price: 122.24, oldPrice: 162.99, rating: 4.7, reviews: 1204, image: 'p4', material: 'Tricô'),
  Product(id: 5, sold: 8900, national: true, name: 'Camiseta de Compressão', category: 'Camisetas', price: 38.00, oldPrice: 99.99, rating: 4.5, reviews: 2750, image: 'p5', material: 'Malha', composition: '90% Poliéster, 10% Elastano'),
  Product(id: 6, sold: 740, name: 'Jeans Reto Estampa Vermelha', category: 'Jeans', price: 251.99, oldPrice: 359.99, rating: 4.4, reviews: 318, image: 'p6', material: 'Jeans', composition: '100% Algodão'),
  Product(id: 7, sold: 9600, national: true, name: 'Jaqueta de Moletom com Zíper', category: 'Jaquetas', price: 132.75, oldPrice: 176.99, rating: 4.8, reviews: 3105, image: 'p7', material: 'Moletom'),
  Product(id: 8, sold: 4100, name: 'Camiseta Texturizada', category: 'Camisetas', price: 59.24, oldPrice: 79.99, rating: 4.6, reviews: 1477, image: 'p8', material: 'Malha'),
  Product(id: 9, sold: 7200, name: 'Suéter de Tricô Estampa de Centopeia', category: 'Suéteres', price: 152.99, oldPrice: 204.95, rating: 4.9, reviews: 2380, image: 'p11', material: 'Tricô'),
  Product(id: 10, sold: 1900, national: true, name: 'Moletom com Capuz Estampa Chamas', category: 'Moletons', price: 136.68, oldPrice: 170.85, rating: 4.7, reviews: 760, image: 'p9', material: 'Moletom'),
  Product(id: 11, sold: 4600, name: 'Suéter Estampa Esqueleto Roxo', category: 'Suéteres', price: 132.40, oldPrice: 165.50, rating: 4.8, reviews: 1650, image: 'p10', material: 'Tricô'),
  Product(id: 12, sold: 1300, name: 'Jaqueta com Gola de Pelúcia', category: 'Jaquetas', price: 189.90, oldPrice: 252.99, rating: 4.6, reviews: 540, image: 'cat_jaquetas'),
  Product(id: 13, sold: 3200, national: true, name: 'Calça de Moletom Larga', category: 'Calças', price: 99.90, oldPrice: 133.20, rating: 4.5, reviews: 1120, image: 'cat_calcas', material: 'Moletom'),
  Product(id: 14, sold: 980, name: 'Bermuda Jeans Estampa Estrelas', category: 'Shorts', price: 89.90, oldPrice: 119.90, rating: 4.4, reviews: 410, image: 'cat_shorts', material: 'Jeans', composition: '100% Algodão'),
  Product(id: 15, sold: 2400, national: true, name: 'Camisa Oversized Manga Curta', category: 'Camisas', price: 79.90, oldPrice: 106.50, rating: 4.5, reviews: 890, image: 'cat_camisas'),
  Product(id: 16, sold: 3900, name: 'Camisa Social Slim', category: 'Camisas', price: 94.90, oldPrice: 126.50, rating: 4.7, reviews: 1330, image: 'cat_conjuntos', composition: '100% Algodão'),
];

String brl(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

/// Aba ativa da navegação inferior (0 Loja, 1 Categorias, 2 Carrinho, 3 Perfil).
final tabIndex = ValueNotifier<int>(0);

class CartItem {
  final Product product;
  final String size;
  final String color;
  int qty;
  // H5: itens entram selecionados (no original o total inicia em R$0,00).
  bool selected;
  CartItem(this.product, this.size, this.color, {this.qty = 1, this.selected = true});

  String get variant => '$color · Tamanho $size';
}

class Cart extends ChangeNotifier {
  static const freeShippingFrom = 199.0;
  static const shippingFee = 12.0;

  final List<CartItem> items = [];

  Iterable<CartItem> get selected => items.where((i) => i.selected);
  int get count => items.fold(0, (s, i) => s + i.qty);
  int get selectedCount => selected.fold(0, (s, i) => s + i.qty);
  bool get allSelected => items.isNotEmpty && items.every((i) => i.selected);

  double get subtotal => selected.fold(0, (s, i) => s + i.product.price * i.qty);
  double get fullPrice => selected.fold(0, (s, i) => s + i.product.oldPrice * i.qty);
  double get discount => fullPrice - subtotal;
  double get shipping => subtotal == 0 || subtotal >= freeShippingFrom ? 0 : shippingFee;
  double get missingForFreeShipping => (freeShippingFrom - subtotal).clamp(0, freeShippingFrom).toDouble();

  void add(Product p, String size, String color) {
    final i = items.indexWhere((e) => e.product.id == p.id && e.size == size && e.color == color);
    if (i >= 0) {
      items[i].qty++;
      items[i].selected = true;
    } else {
      items.add(CartItem(p, size, color));
    }
    notifyListeners();
  }

  void setQty(CartItem item, int qty) {
    item.qty = qty.clamp(1, 10);
    notifyListeners();
  }

  void toggle(CartItem item) {
    item.selected = !item.selected;
    notifyListeners();
  }

  void toggleAll() {
    final v = !allSelected;
    for (final i in items) {
      i.selected = v;
    }
    notifyListeners();
  }

  int remove(CartItem item) {
    final i = items.indexOf(item);
    items.removeAt(i);
    notifyListeners();
    return i;
  }

  void insert(int index, CartItem item) {
    items.insert(index.clamp(0, items.length), item);
    notifyListeners();
  }
}

class Favorites extends ChangeNotifier {
  final Set<int> ids = {};

  bool has(Product p) => ids.contains(p.id);

  void toggle(Product p) {
    if (!ids.remove(p.id)) ids.add(p.id);
    notifyListeners();
  }
}

final cart = Cart();
final favorites = Favorites();
