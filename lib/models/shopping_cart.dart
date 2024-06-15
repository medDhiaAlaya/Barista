import 'package:barista/models/product.dart';

class ShoppingCart {
  final List<ShoppingCartItem> items;
  double totalPrice;

  ShoppingCart({
    required this.items,
    required this.totalPrice,
  });

  factory ShoppingCart.fromJson(Map<String, dynamic> data) {
    final List<ShoppingCartItem> itemsList = [];
    for (var element in (data['items'] ?? [])) {
      itemsList.add(ShoppingCartItem.fromJson(element));  
    }
    return ShoppingCart(
      items: itemsList,
      totalPrice: double.tryParse(data['total_price'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()),
      'total_price': totalPrice,
    };
  }
}
class ShoppingCartItem {
  final Product product;
  int quantity;
  double totalPrice;

  ShoppingCartItem({
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory ShoppingCartItem.fromJson(Map<String, dynamic> data) {
    return ShoppingCartItem(
      product: Product.fromJson(data['name'] ?? {}),
      quantity: data['image'] ?? 0,
      totalPrice: double.tryParse(data['total_price'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}
