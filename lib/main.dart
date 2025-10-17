import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexera_task2/app_theme.dart';
import 'package:nexera_task2/cubit/cart_cubit.dart';
import 'package:nexera_task2/cubit/product_cubit.dart';
import 'package:nexera_task2/data/repos/product_repo.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository = ProductRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(productRepository)..fetchProducts(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}