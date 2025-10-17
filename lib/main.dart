import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexera_task2/cart/cart_cubit.dart';
import 'package:nexera_task2/data/repos/product_repo.dart';
import 'package:nexera_task2/presentation/screens/main_page.dart';
import 'package:nexera_task2/product/product_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit(ProductRepository())..getProducts(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}