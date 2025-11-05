import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../lib/services/auth_service.dart';
import 'order_service_test.annotations.mocks.dart';

void main() {
  late MockClient mockClient;
  late MockFlutterSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockClient = MockClient();
    mockStorage = MockFlutterSecureStorage();
    authService = AuthService(storage: mockStorage, client: mockClient);
  });

  group('AuthService login', () {
    test('login exitoso guarda token', () async {
      final fakeResponse = {'token': '12345'};
      when(mockClient.post(
        Uri.parse('https://api-libreria.vercel.app/api/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 200));

      when(mockStorage.write(key: 'token', value: '12345')).thenAnswer((_) async => null);
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => '12345');

      final result = await authService.login('correo@test.com', '1234');

      expect(result['token'], '12345');
      verify(mockStorage.write(key: 'token', value: '12345')).called(1);
      verify(mockStorage.read(key: 'token')).called(1);
    });

    test('login falla retorna error', () async {
      when(mockClient.post(
        Uri.parse('https://api-libreria.vercel.app/api/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      final result = await authService.login('correo@test.com', '1234');

      expect(result.containsKey('token'), false);
    });
  });

  group('AuthService getToken & logout', () {
    test('getToken retorna token guardado', () async {
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => 'token123');
      final token = await authService.getToken();
      expect(token, 'token123');
    });

    test('logout elimina token', () async {
      when(mockStorage.delete(key: 'token')).thenAnswer((_) async => null);
      await authService.logout();
      verify(mockStorage.delete(key: 'token')).called(1);
    });
  });

  group('AuthService getPerfil', () {
    test('retorna null si no hay token', () async {
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => null);
      final result = await authService.getPerfil();
      expect(result, null);
    });

    test('retorna datos de perfil si hay token y status 200', () async {
      final fakePerfil = {'nombre': 'Juan'};
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => '12345');
      when(mockClient.get(
        Uri.parse('https://api-libreria.vercel.app/api/perfil-movil'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(fakePerfil), 200));

      final result = await authService.getPerfil();
      expect(result!['nombre'], 'Juan');
    });

    test('retorna null si status != 200', () async {
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => '12345');
      when(mockClient.get(
        Uri.parse('https://api-libreria.vercel.app/api/perfil-movil'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      final result = await authService.getPerfil();
      expect(result, null);
    });
  });
}
