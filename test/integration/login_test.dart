import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

void main() {
  group('Login Integration Test', () {

    test('Login exitoso con usuario de prueba', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': 'gabriel@test.com',
          'contrasena': 'GABjua123\$',
          'origen': 'mobile',
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      expect(response.statusCode, 200);

      final data = jsonDecode(response.body);

      // Debe contener token y rol
      expect(data.containsKey('token'), true);
      expect(data['rol'], 'empleado');
      print('Token recibido: ${data['token']}');
    });

    test('Login con contraseña incorrecta falla', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': 'gabriel@test.com',
          'contrasena': 'GABjua123',
          'origen': 'mobile',
        }),
      );

      // Debe devolver status 400 o 403 según tu backend
      expect(response.statusCode, 400);
    });
  });
}
