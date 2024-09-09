import 'package:eukay/pages/dashboard/mappers/product_model.dart';

abstract class DashboardRepository {
  Future<List<ProductModel>> fetchProducts();
}
