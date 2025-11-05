import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // ---------------- MODIFICACIÓN ----------------
  // Ahora _storage y _client se pueden inyectar para pruebas unitarias
  final FlutterSecureStorage _storage;
  final http.Client _client;
  // ----------------------------------------------

  final String baseUrl = 'https://api-libreria.vercel.app/api'; // reemplaza por tu backend

  // ---------------- MODIFICACIÓN ----------------
  // Constructor opcional para pruebas unitarias
  AuthService({FlutterSecureStorage? storage, http.Client? client})
      : _storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? http.Client();
  // ----------------------------------------------

  Future<Map<String, dynamic>> login(String correo, String contrasena) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await _client.post( // ⚡ Cambiado de http.post a _client.post
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': correo,
        'contrasena': contrasena,
        'origen': 'mobile',
      }),
    );

    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await _storage.write(key: 'token', value: data['token']);
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
      return {'message': 'Respuesta no válida del servidor', 'error': e.toString()};
    }
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    print('🔑 Token leído de storage: $token');
    return token;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    print('🚪 Token eliminado, usuario desconectado');
  }

  Future<Map<String, dynamic>?> getPerfil() async {
    final token = await _storage.read(key: 'token');

    if (token == null) {
      print('❌ No hay token almacenado');
      return null;
    }

    final url = Uri.parse('http://192.168.1.80:3000/api/perfil-movil');
    print('➡️ Enviando token en header: $token');

    final response = await _client.get( // ⚡ Cambiado de http.get a _client.get
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ Perfil obtenido: $data');
      return data;
    } else {
      print('❌ Error al obtener perfil: ${response.body}');
      return null;
    }
  }
}
