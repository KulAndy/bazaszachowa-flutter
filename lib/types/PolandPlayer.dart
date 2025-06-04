class PolandPlayer {
  final String polandId;
  final String title;
  final String? fideId;
  final String name;

  PolandPlayer({
    required this.polandId,
    required this.title,
    required this.fideId,
    required this.name,
  });

  factory PolandPlayer.fromJson(Map<String, dynamic> json) {
    return PolandPlayer(
      polandId: json['id'],
      title: json['kat'],
      fideId: json['fide_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': polandId, 'kat': title, 'fide_id': fideId, 'name': name};
  }
}
