class Move {
  final String from;
  final String to;
  final String? promotion;

  Move({required this.from, required this.to, this.promotion});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      from: json['from'],
      to: json['to'],
      promotion: json['promotion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"from": from, "to": to, "promotion": promotion};
  }
}
