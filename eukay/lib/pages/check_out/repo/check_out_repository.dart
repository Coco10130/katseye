import 'package:eukay/pages/check_out/mappers/order_model.dart';

abstract class CheckOutRepository {
  Future<List<OrderModel>> fetchOrders(String token);
  Future<String> checkOutOrders(String token);
}
