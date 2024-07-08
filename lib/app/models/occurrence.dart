class Occurrence {
  int? id;
  String title;
  DateTime date;
  int? wrapProjectionId;
  int? forwardProjectionId;

  Occurrence({
    this.id,
    required this.title,
    required this.date,
    this.wrapProjectionId,
    this.forwardProjectionId,
  });

  factory Occurrence.fromJson(Map<String, dynamic> json) {
    return Occurrence(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      wrapProjectionId: json['wrapProjectionId'],
      forwardProjectionId: json['forwardProjectionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'wrapProjectionId': wrapProjectionId,
      'forwardProjectionId': forwardProjectionId,
    };
  }
}
