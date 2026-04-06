import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/exchange_rate_model.dart';
import 'network_service.dart';

class ExchangeRateService {
  final NetworkService _networkService;

  ExchangeRateService(this._networkService);

  Future<ExchangeRateModel> getOfficialRate() async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://ve.dolarapi.com/v1';
    final url = '$baseUrl/dolares/oficial';

    try {
      final data = await _networkService.get(url);
      return ExchangeRateModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ExchangeRateModel> getParallelRate() async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://ve.dolarapi.com/v1';
    final url = '$baseUrl/dolares/paralelo';

    try {
      final data = await _networkService.get(url);
      return ExchangeRateModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}
