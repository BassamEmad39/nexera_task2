import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexera_task2/data/models/cart_model.dart';
import '../../../data/models/product_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(ProductModel product) {
    final List<CartItemModel> updatedCartItems = List.from(state.cartItems);
    final existingItemIndex = updatedCartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      final existingItem = updatedCartItems[existingItemIndex];
      updatedCartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      updatedCartItems.add(CartItemModel(product: product));
    }

    emit(CartState(cartItems: updatedCartItems));
  }

  void removeFromCart(int productId) {
    final List<CartItemModel> updatedCartItems = state.cartItems
        .where((item) => item.product.id != productId)
        .toList();

    emit(CartState(cartItems: updatedCartItems));
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final List<CartItemModel> updatedCartItems = List.from(state.cartItems);
    final existingItemIndex = updatedCartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingItemIndex != -1) {
      final existingItem = updatedCartItems[existingItemIndex];
      updatedCartItems[existingItemIndex] = existingItem.copyWith(
        quantity: quantity,
      );
      emit(CartState(cartItems: updatedCartItems));
    }
  }

  void clearCart() {
    emit(const CartState());
  }

  void addToCartWithQuantity(ProductModel product, int quantity) {
    final List<CartItemModel> updatedCartItems = List.from(state.cartItems);
    final existingItemIndex = updatedCartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      final existingItem = updatedCartItems[existingItemIndex];
      updatedCartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      updatedCartItems.add(CartItemModel(product: product, quantity: quantity));
    }

    emit(CartState(cartItems: updatedCartItems));
  }
}
