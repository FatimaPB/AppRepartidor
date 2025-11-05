// test/integration/auth_service_integration_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

void main() {
  group('AuthService Integration', () {
    String? token;

    setUpAll(() async {
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

    test('getPerfil retorna datos de perfil', () async {
      final response = await http.get(
        Uri.parse('$baseUrl/perfil-movil'),
        headers: {'Authorization': 'Bearer $token'},
      );

      expect(response.statusCode, 200);

      final perfil = jsonDecode(response.body);
      expect(perfil.containsKey('nombre'), true);
    });
  });
}
