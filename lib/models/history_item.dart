enum HistoryType { create, scan }

class HistoryItem {
  final String id;
  final HistoryType type;
  final String data;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      type: json['type'] == 'HistoryType.create'
          ? HistoryType.create
          : HistoryType.scan,
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
