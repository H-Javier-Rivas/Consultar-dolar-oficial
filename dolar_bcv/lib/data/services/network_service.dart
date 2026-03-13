import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class NetworkService {
  Future<dynamic> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw NetworkException('Error de servidor: \${response.statusCode}');
      }
    } on http.ClientException {
      throw NetworkException('Error de conexión. Verifica tu internet.');
    } catch (e) {
      throw NetworkException('No se pudo completar la solicitud: \$e');
    }
  }
}
