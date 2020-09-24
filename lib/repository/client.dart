import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:xopa_app/repository/errors.dart';
import 'package:web_socket_channel/io.dart';

const String kApiUrl = 'http://192.168.1.110:1234';
const String kWsUrl = 'ws://192.168.1.110:1234';

class Client {
  static Dio _dio;
  static String _token;
  static String userId = '';

  static Dio getDio() {
    if (_dio == null) {
      _dio = new Dio()
        ..options.connectTimeout = 5000
        ..interceptors
            .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
          if (_token != null) {
            options.headers['jwt'] = _token;
          }
        }));
    }

    return _dio;
  }

  static Future<dynamic> get(
    String path, {
    Map<int, String> errorMessages = const {
      400: 'Data was invalid',
      404: 'Page not found',
      500: 'Server error. Try again later.',
    },
    List<int> ignoreTheseErrors = const [],
  }) async {
    try {
      final response = await getDio().get(Client.url(path));
      return response.data;
    } on DioError catch (e) {
      final responseCode = e.response?.statusCode ?? 0;

      if (ignoreTheseErrors.contains(responseCode)) return;

      if (errorMessages.containsKey(responseCode)) {
        throw KozeException(errorMessages[responseCode]);
      }
      throw KozeException(e.message);
    }
  }

  static Future<dynamic> post(
    String path, {
    data,
    Map<int, String> errorMessages = const {
      400: 'Data was invalid',
      404: 'Page not found',
      500: 'Server error. Try again later.',
    },
    List<int> ignoreTheseErrors = const [],
  }) async {
    try {
      final response = await getDio().post(Client.url(path), data: data);
      return response.data;
    } on DioError catch (e) {
      final responseCode = e.response?.statusCode ?? 0;

      if (ignoreTheseErrors.contains(responseCode)) return;

      if (errorMessages.containsKey(responseCode)) {
        throw KozeException(errorMessages[responseCode]);
      }
      throw KozeException(e.message);
    }
  }

  static IOWebSocketChannel getWebsocket(
    String path, {
    Duration pingInterval,
  }) {
    return IOWebSocketChannel.connect(
      Uri.parse(Client.wsUrl(path)),
      headers: {
        'jwt': _token,
      },
    );
  }

  static String url(String relativePath) {
    return '$kApiUrl$relativePath';
  }

  static String wsUrl(String relativePath) {
    return '$kWsUrl$relativePath';
  }

  static void setToken(String token) {
    _token = token;

    //Get user id from token.
    final splitToken = _token.split('.');
    if (splitToken.length != 3) return;
    final base64 = base64Url.normalize(splitToken[1]);
    final payloadJson = utf8.decode(base64Url.decode(base64));
    final Map<String, dynamic> payload = jsonDecode(payloadJson);
    userId = payload['id'] ?? '';
  }
}
