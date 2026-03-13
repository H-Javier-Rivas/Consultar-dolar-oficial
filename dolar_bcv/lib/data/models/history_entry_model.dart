class HistoryEntryModel {
  final int? id;
  final double amountBs;
  final double rateUsed;
  final String operation; // '+' or '-'
  final String sessionDate; // ISO format

  HistoryEntryModel({
    this.id,
    required this.amountBs,
    required this.rateUsed,
    required this.operation,
    required this.sessionDate,
  });

  factory HistoryEntryModel.fromMap(Map<String, dynamic> map) {
    return HistoryEntryModel(
      id: map['id'] as int?,
      amountBs: (map['amountBs'] as num).toDouble(),
      rateUsed: (map['rateUsed'] as num).toDouble(),
      operation: map['operation'] as String,
      sessionDate: map['sessionDate'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amountBs': amountBs,
      'rateUsed': rateUsed,
      'operation': operation,
      'sessionDate': sessionDate,
    };
  }
}
