class Move {
  Move({required this.from, required this.to, this.promotion});

  factory Move.fromJson(Map<String, dynamic> json) =>
      Move(from: json["from"], to: json["to"], promotion: json["promotion"]);
  final String from;
  final String to;
  final String? promotion;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "from": from,
    "to": to,
    "promotion": promotion,
  };
}
