import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.discountedPrice * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}

class Cart extends Equatable {
  final List<CartItem> items;

  const Cart({this.items = const []});

  double get totalAmount {
    return items.fold(0, (total, item) => total + item.totalPrice);
  }

  int get totalItems {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  Cart addItem(Product product) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      return Cart(items: updatedItems);
    } else {
      return Cart(items: [...items, CartItem(product: product, quantity: 1)]);
    }
  }

  Cart removeItem(Product product) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(items);
      if (updatedItems[existingIndex].quantity > 1) {
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: updatedItems[existingIndex].quantity - 1,
        );
        return Cart(items: updatedItems);
      } else {
        updatedItems.removeAt(existingIndex);
        return Cart(items: updatedItems);
      }
    }
    return this;
  }

  Cart clearItem(Product product) {
    final updatedItems = items.where((item) => item.product.id != product.id).toList();
    return Cart(items: updatedItems);
  }

  Cart clear() {
    return Cart(items: []);
  }

  @override
  List<Object?> get props => [items];
}