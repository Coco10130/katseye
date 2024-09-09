import 'package:dio/dio.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/dashboard/repo/dashboard_repository.dart';
import 'package:eukay/uitls/server.dart';

class DashboardRepo extends DashboardRepository {
  final _dio = Dio();

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get("${Server.serverUrl}/api/product/get");

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> productLists = response.data["data"];
        return productLists.map((product) {
          return ProductModel.fromJson(product);
        }).toList();
      } else {
        throw Exception("Failed to fetch products");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["errorMessage"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
