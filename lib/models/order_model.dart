class Order {
  final int id;
  final String client;
  final String deliveryAddress;
  final String deliveryStatus;
  final String date;

  Order({
    required this.id,
    required this.client,
    required this.deliveryAddress,
    required this.deliveryStatus,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      client: json['cliente'],
      deliveryAddress: json['direccion_envio'],
      deliveryStatus: json['estado'],
      date: json['fecha'],
    );
  }
}



// Detalle del pedido
class OrderDetail {
  final int id;
  final String client;
  final String deliveryAddress;
  final List<OrderProduct> products;
  final double total;

  OrderDetail({
    required this.id,
    required this.client,
    required this.deliveryAddress,
    required this.products,
    required this.total,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] ?? 0,
      client: json['cliente'] ?? '',
      deliveryAddress: json['direccion_envio'] ?? '',
      products: (json['productos'] as List<dynamic>? ?? [])
          .map((p) => OrderProduct.fromJson(p))
          .toList(),
   total: json['total'] is String
          ? double.parse(json['total'])
          : (json['total'] ?? 0).toDouble(),
    );
  }
}

class OrderProduct {
  final String name;
  final int quantity;
  final double price;
  final String? image;

  OrderProduct({
    required this.name,
    required this.quantity,
    required this.price,
    this.image,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      name: json['nombre'] ?? '',
      quantity: json['cantidad'] ?? 0,
       price: json['precio_unitario'] is String
          ? double.parse(json['precio_unitario'])
          : (json['precio_unitario'] ?? 0).toDouble(),
      image: json['imagen'], // opcional
    );
  }
}