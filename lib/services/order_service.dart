import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderService {
  final String baseUrl = 'http://192.168.1.80:3000/api';

  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/envios/pendientes'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        List ordersJson = data['pedidos'];
        return ordersJson.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception(
            'Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }



 // Obtener detalle de un pedido
  Future<OrderDetail> fetchOrderDetail(int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/envios/$orderId'),
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return OrderDetail.fromJson(data);
    } else {
      throw Exception('Failed to load order detail. Status: ${response.statusCode}');
    }
  }
}