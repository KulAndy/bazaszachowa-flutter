class PolandPlayer {
  PolandPlayer({
    required this.polandId,
    required this.title,
    required this.fideId,
    required this.name,
  });

  factory PolandPlayer.fromJson(Map<String, dynamic> json) => PolandPlayer(
    polandId: json["id"],
    title: json["kat"],
    fideId: json["fide_id"],
    name: json["name"],
  );
  final String polandId;
  final String title;
  final String? fideId;
  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": polandId,
    "kat": title,
    "fide_id": fideId,
    "name": name,
  };
}
