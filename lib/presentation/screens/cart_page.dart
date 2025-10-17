import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexera_task2/cart/cart_cubit.dart';
import 'package:nexera_task2/cart/cart_state.dart';
import 'package:nexera_task2/data/models/cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.cartItems.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = state.cartItems[index];
                    return _buildCartItem(context, cartItem);
                  },
                ),
              ),
              _buildTotalSection(context, state),
              SafeArea(child: SizedBox()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemModel cartItem) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Image.network(
          cartItem.product.thumbnail,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
          },
        ),
        title: Text(
          cartItem.product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${cartItem.product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    context.read<CartCubit>().updateQuantity(
                      cartItem.product.id,
                      cartItem.quantity - 1,
                    );
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.read<CartCubit>().updateQuantity(
                      cartItem.product.id,
                      cartItem.quantity + 1,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          '\$${cartItem.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Items:', style: TextStyle(fontSize: 16)),
              Text(
                state.totalItems.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${state.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCheckoutDialog(context, state.totalPrice);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Checkout', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to clear all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartCubit>().clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cart cleared!')));
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context, double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thank you for your purchase!'),
              const SizedBox(height: 16),
              Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: Colors.black, fontSize: 11),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<CartCubit>().clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: const Text(
                'Confirm Order',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        );
      },
    );
  }
}
