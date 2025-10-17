import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexera_task2/state/cart_state.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    emit(CartLoaded(Cart()));
  }

  void addToCart(Product product) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedCart = currentState.cart.addItem(product);
      emit(CartLoaded(updatedCart));
    }
  }

  void removeFromCart(Product product) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedCart = currentState.cart.removeItem(product);
      emit(CartLoaded(updatedCart));
    }
  }

  void clearFromCart(Product product) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedCart = currentState.cart.clearItem(product);
      emit(CartLoaded(updatedCart));
    }
  }

  void clearCart() {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedCart = currentState.cart.clear();
      emit(CartLoaded(updatedCart));
    }
  }
}