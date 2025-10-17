import 'dart:developer';
import '../models/product_model.dart';
import '../../core/utils/dio_client.dart';
import '../../core/constants/app_constants.dart';

class ProductRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Product>> getProducts() async {
    try {
      log('Fetching products from API...');
      final response = await _dioClient.get(AppConstants.productsEndpoint);

      log('Response status: ${response.statusCode}');
      log('Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data.containsKey('products') && data['products'] is List) {
          final productsData = data['products'] as List;
          log('Found ${productsData.length} products');

          if (productsData.isNotEmpty) {
            log('First product: ${productsData.first}');
          }

          final products = productsData.map((productJson) {
            try {
              return Product.fromJson(productJson);
            } catch (e) {
              log('Error parsing product: $e');
              log('Problematic product data: $productJson');
              return Product(
                id: 0,
                title: 'Error Product',
                description: 'Could not load product',
                price: 0.0,
                discountPercentage: 0.0,
                rating: 0.0,
                stock: 0,
                brand: 'Unknown',
                category: 'Unknown',
                thumbnail: '',
                images: [],
              );
            }
          }).toList();

          return products;
        } else {
          throw Exception(
            'Invalid API response format: products key not found',
          );
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getProducts: $e');
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dioClient.get(
        '${AppConstants.productsEndpoint}/$id',
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getProductById: $e');
      throw Exception('Failed to load product: ${e.toString()}');
    }
  }
}
