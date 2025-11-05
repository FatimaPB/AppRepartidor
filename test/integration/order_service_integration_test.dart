// test/integration/order_service_integration_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../../lib/models/order_model.dart';
import '../config.dart';
 void main() {
  group('OrderService Integration', () {
    String? token;

    setUpAll(() async {
      // Login para obtener token
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': 'gabriel@test.com',
          'contrasena': 'GABjua123\$',
          'origen': 'mobile',
        }),
      );
      final data = jsonDecode(response.body);
      token = data['token'];
    });

    test('fetchOrders retorna lista de órdenes', () async {
      final response = await http.get(
        Uri.parse('$baseUrl/envios/pendientes'),
        headers: {'Authorization': 'Bearer $token'},
      );

      expect(response.statusCode, 200);

      final body = jsonDecode(response.body);
      final orders = (body['pedidos'] as List).map((json) => Order.fromJson(json)).toList();

      expect(orders.isNotEmpty, true);
      print('Órdenes recibidas: ${orders.length}');
    });

    test('fetchOrderDetail retorna detalle de orden', () async {
      final responseOrders = await http.get(
        Uri.parse('$baseUrl/envios/pendientes'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final orders = (jsonDecode(responseOrders.body)['pedidos'] as List);

      final firstOrderId = orders[0]['id'];

      final responseDetail = await http.get(
        Uri.parse('$baseUrl/envios/$firstOrderId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      expect(responseDetail.statusCode, 200);

      final detail = OrderDetail.fromJson(jsonDecode(responseDetail.body));
      expect(detail.id, firstOrderId);
      expect(detail.products.isNotEmpty, true);
    });
  });
}
