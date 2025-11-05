import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/order_model.dart';

void main() {
  group('Order model', () {
    test('fromJson convierte correctamente un JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'cliente': 'Juan Perez',
        'direccion_envio': 'Calle Falsa 123',
        'estado': 'pendiente',
        'fecha': '2025-10-31'
      };

      final order = Order.fromJson(json);

      expect(order.id, 1);
      expect(order.client, 'Juan Perez');
      expect(order.deliveryAddress, 'Calle Falsa 123');
      expect(order.deliveryStatus, 'pendiente');
      expect(order.date, '2025-10-31');
    });

    test('fromJson lanza error si faltan campos obligatorios', () {
      final json = <String, dynamic>{};
      expect(() => Order.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('OrderProduct model', () {
    test('fromJson convierte correctamente un JSON', () {
      final json = <String, dynamic>{
        'nombre': 'Libro A',
        'cantidad': 2,
        'precio_unitario': '15.5',
        'imagen': 'url_imagen'
      };

      final product = OrderProduct.fromJson(json);

      expect(product.name, 'Libro A');
      expect(product.quantity, 2);
      expect(product.price, 15.5);
      expect(product.image, 'url_imagen');
    });

    test('fromJson usa valores por defecto si faltan campos', () {
      final json = <String, dynamic>{};
      final product = OrderProduct.fromJson(json);

      expect(product.name, '');
      expect(product.quantity, 0);
      expect(product.price, 0);
      expect(product.image, null);
    });
  });

  group('OrderDetail model', () {
    test('fromJson convierte correctamente un JSON con productos', () {
      final json = <String, dynamic>{
        'id': 1,
        'cliente': 'Juan Perez',
        'direccion_envio': 'Calle Falsa 123',
        'productos': [
          <String, dynamic>{'nombre': 'Libro A', 'cantidad': 2, 'precio_unitario': '15.5'},
          <String, dynamic>{'nombre': 'Libro B', 'cantidad': 1, 'precio_unitario': 20}
        ],
        'total': '51.0'
      };

      final orderDetail = OrderDetail.fromJson(json);

      expect(orderDetail.id, 1);
      expect(orderDetail.client, 'Juan Perez');
      expect(orderDetail.deliveryAddress, 'Calle Falsa 123');
      expect(orderDetail.products.length, 2);
      expect(orderDetail.products[0].name, 'Libro A');
      expect(orderDetail.products[0].price, 15.5);
      expect(orderDetail.products[1].name, 'Libro B');
      expect(orderDetail.products[1].price, 20);
      expect(orderDetail.total, 51.0);
    });

    test('fromJson usa valores por defecto si faltan campos', () {
      final json = <String, dynamic>{};
      final orderDetail = OrderDetail.fromJson(json);

      expect(orderDetail.id, 0);
      expect(orderDetail.client, '');
      expect(orderDetail.deliveryAddress, '');
      expect(orderDetail.products, []);
      expect(orderDetail.total, 0);
    });
  });
}
