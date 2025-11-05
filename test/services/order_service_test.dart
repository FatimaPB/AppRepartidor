import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../lib/services/order_service.dart'; // Ajusta según tu proyecto
import '../../lib/models/order_model.dart';

import 'order_service_test.annotations.mocks.dart'; // <-- Importa el MockClient generado

void main() {
  group('OrderService', () {
    late OrderService orderService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      orderService = OrderService();
    });

    test('fetchOrders retorna lista de órdenes si status 200', () async {
      final mockResponse = {
        "pedidos": [
          {
            "id": 1,
            "cliente": "Juan",
            "direccion_envio": "Calle 123",
            "estado": "pendiente",
            "fecha": "2025-10-31"
          },
          {
            "id": 2,
            "cliente": "Maria",
            "direccion_envio": "Av 456",
            "estado": "pendiente",
            "fecha": "2025-10-30"
          }
        ]
      };

      // Configurar el mock
      when(mockClient.get(
        Uri.parse('https://api-libreria.vercel.app/api/envios/pendientes'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      // Reemplazar temporalmente http.get con nuestro mock
      orderService.httpClient = mockClient;

      final orders = await orderService.fetchOrders();

      expect(orders.length, 2);
      expect(orders[0].client, 'Juan');
      expect(orders[1].client, 'Maria');
    });

    test('fetchOrders lanza excepción si status != 200', () async {
      when(mockClient.get(
        Uri.parse('https://api-libreria.vercel.app/api/envios/pendientes'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      orderService.httpClient = mockClient;

      expect(orderService.fetchOrders(), throwsException);
    });

    test('fetchOrderDetail retorna detalle si status 200', () async {
      final mockDetail = {
        "id": 1,
        "cliente": "Juan",
        "direccion_envio": "Calle 123",
        "productos": [
          {"nombre": "Producto1", "cantidad": 2, "precio_unitario": 50.0}
        ],
        "total": 100.0
      };

      when(mockClient.get(
        Uri.parse('https://api-libreria.vercel.app/api/envios/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockDetail), 200));

      orderService.httpClient = mockClient;

      final detail = await orderService.fetchOrderDetail(1);

      expect(detail.id, 1);
      expect(detail.client, 'Juan');
      expect(detail.products.length, 1);
      expect(detail.total, 100.0);
    });

    test('fetchOrderDetail lanza excepción si status != 200', () async {
      when(mockClient.get(
        Uri.parse('https://api-libreria.vercel.app/api/envios/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 404));

      orderService.httpClient = mockClient;

      expect(orderService.fetchOrderDetail(1), throwsException);
    });
  });
}
