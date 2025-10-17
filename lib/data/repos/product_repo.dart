import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nexera_task2/core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../../core/network/dio_client.dart';

class ProductRepository {
  final DioClient _dioClient = DioClient();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.products);
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'] ?? [];
        return productsJson.map((json) {
          try {
            return ProductModel.fromJson(json);
          } catch (e) {
            log('Error parsing product: $e');
            return ProductModel(
              id: 0,
              title: 'Error Product',
              description: 'Could not load product',
              price: 0.0,
              discountPercentage: 0.0,
              rating: 0.0,
              stock: 0,
              brand: 'Error',
              category: 'Error',
              thumbnail: '',
              images: [],
            );
          }
        }).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.productById}$id');
      
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load product: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}