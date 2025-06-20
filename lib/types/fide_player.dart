class FidePlayer {
  final int fideId;
  final String name;
  final String? title;
  final int? standardRating;
  final int? rapidRating;
  final int? blitzRating;
  final int? birthYear;

  FidePlayer({
    required this.fideId,
    required this.name,
    required this.title,
    required this.standardRating,
    required this.rapidRating,
    required this.blitzRating,
    required this.birthYear,
  });

  factory FidePlayer.fromJson(Map<String, dynamic> json) {
    return FidePlayer(
      fideId: json['fideid'],
      title: json['title'],
      name: json['name'],
      standardRating: json['rating'],
      rapidRating: json['rapid_rating'],
      blitzRating: json['blitz_rating'],
      birthYear: json['birthday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fideid": fideId,
      "name": name,
      "title": title,
      "rating": standardRating,
      "rapid_rating": rapidRating,
      "blitz_rating": blitzRating,
      "birthday": birthYear,
    };
  }
}
