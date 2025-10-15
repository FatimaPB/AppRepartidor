import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'https://api-libreria.vercel.app/api'; // reemplaza por tu backend

Future<Map<String, dynamic>> login(String correo, String contrasena) async {
  final url = Uri.parse('$baseUrl/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'correo': correo,
      'contrasena': contrasena,
      'origen': 'mobile',
    }),
  );

  // Imprime la respuesta completa para depuración
  print('STATUS CODE: ${response.statusCode}');
  print('BODY: ${response.body}');

  try {
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['token'] != null) {
      // Guardar token seguro
      await _storage.write(key: 'token', value: data['token']);
      
      // Verificación: leer inmediatamente
      final storedToken = await _storage.read(key: 'token');
      if (storedToken != null) {
        print('✅ Token guardado correctamente: $storedToken');
      } else {
        print('❌ No se pudo guardar el token');
      }
    } else {
      print('❌ Login fallido o token no recibido');
    }

    return data;
  } catch (e) {
    // Si falla jsonDecode, retornamos un mapa con error
    return {'message': 'Respuesta no válida del servidor', 'error': e.toString()};
  }
}


  // LEER token
  Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    print('🔑 Token leído de storage: $token');
    return token;
  }

  // LOGOUT
  Future<void> logout() async {
    await _storage.delete(key: 'token');
    print('🚪 Token eliminado, usuario desconectado');
  }
}
