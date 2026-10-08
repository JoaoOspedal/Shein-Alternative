import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final Color color;
  final IconData icon;
  final List<String> sizes;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.color,
    required this.icon,
    this.sizes = const ['P', 'M', 'G', 'GG'],
  });
}

const categories = ['Vestidos', 'Blusas', 'Calças', 'Acessórios', 'Calçados'];

const products = <Product>[
  Product(id: 1, name: 'Vestido midi floral', category: 'Vestidos', price: 89.90, oldPrice: 129.90, rating: 4.7, reviews: 1284, color: Color(0xFFE8C9C4), icon: Icons.checkroom),
  Product(id: 2, name: 'Blusa de linho manga curta', category: 'Blusas', price: 59.90, rating: 4.5, reviews: 612, color: Color(0xFFCFDCD0), icon: Icons.dry_cleaning),
  Product(id: 3, name: 'Calça wide leg alfaiataria', category: 'Calças', price: 119.90, oldPrice: 159.90, rating: 4.6, reviews: 903, color: Color(0xFFC9D2DE), icon: Icons.checkroom),
  Product(id: 4, name: 'Bolsa tote minimalista', category: 'Acessórios', price: 74.90, rating: 4.4, reviews: 287, color: Color(0xFFE3D9C3), icon: Icons.shopping_bag_outlined, sizes: ['Único']),
  Product(id: 5, name: 'Tênis casual branco', category: 'Calçados', price: 139.90, oldPrice: 179.90, rating: 4.8, reviews: 2011, color: Color(0xFFDCDCDC), icon: Icons.snowshoeing, sizes: ['36', '37', '38', '39', '40']),
  Product(id: 6, name: 'Vestido slip cetim', category: 'Vestidos', price: 99.90, rating: 4.3, reviews: 455, color: Color(0xFFD9C8DE), icon: Icons.checkroom),
  Product(id: 7, name: 'Camisa oversized listrada', category: 'Blusas', price: 79.90, rating: 4.6, reviews: 731, color: Color(0xFFC6D8E3), icon: Icons.dry_cleaning),
  Product(id: 8, name: 'Jeans reto cintura alta', category: 'Calças', price: 129.90, rating: 4.7, reviews: 1530, color: Color(0xFFB9C6D6), icon: Icons.checkroom),
];

String brl(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

class CartItem {
  final Product product;
  final String size;
  int qty;
  CartItem(this.product, this.size, [this.qty = 1]);
}

class Cart extends ChangeNotifier {
  final List<CartItem> items = [];

  int get count => items.fold(0, (s, i) => s + i.qty);
  double get subtotal => items.fold(0, (s, i) => s + i.product.price * i.qty);
  double get shipping => items.isEmpty || subtotal >= 199 ? 0 : 14.90;
  double get total => subtotal + shipping;

  void add(Product p, String size) {
    final i = items.indexWhere((e) => e.product.id == p.id && e.size == size);
    if (i >= 0) {
      items[i].qty++;
    } else {
      items.add(CartItem(p, size));
    }
    notifyListeners();
  }

  void changeQty(CartItem item, int delta) {
    item.qty += delta;
    if (item.qty <= 0) items.remove(item);
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}

final cart = Cart();
