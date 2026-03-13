class ExchangeRateModel {
  final double promedio;
  final String fechaActualizacion;
  final bool fromCache;

  ExchangeRateModel({
    required this.promedio,
    required this.fechaActualizacion,
    this.fromCache = false,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json, {bool fromCache = false}) {
    // The API might return integers that look like 36 instead of 36.0
    return ExchangeRateModel(
      promedio: (json['promedio'] as num).toDouble(),
      fechaActualizacion: json['fechaActualizacion'] ?? DateTime.now().toIso8601String(),
      fromCache: fromCache,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promedio': promedio,
      'fechaActualizacion': fechaActualizacion,
    };
  }
}
