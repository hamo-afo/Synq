class StockModel {
  final String symbol;
  final double price;
  final double change;
  final DateTime? lastUpdated;

  StockModel({
    required this.symbol,
    required this.price,
    required this.change,
    this.lastUpdated,
  });

  StockModel copyWith({
    String? symbol,
    double? price,
    double? change,
    DateTime? lastUpdated,
  }) {
    return StockModel(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      change: change ?? this.change,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'price': price,
      'change': change,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      symbol: map['symbol'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      change: (map['change'] ?? 0).toDouble(),
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.tryParse(map['lastUpdated'])
          : null,
    );
  }
}
