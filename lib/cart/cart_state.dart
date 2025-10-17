import 'package:equatable/equatable.dart';
import 'package:nexera_task2/data/models/cart_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> cartItems;

  const CartState({this.cartItems = const []});

  double get totalPrice {
    return cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  int get totalItems {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }

  @override
  List<Object> get props => [cartItems];
}