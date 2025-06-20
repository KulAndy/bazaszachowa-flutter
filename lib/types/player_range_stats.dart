class PlayerRangeStats {
  final int? maxElo;
  final int minYear;
  final int maxYear;

  PlayerRangeStats({
    required this.maxElo,
    required this.minYear,
    required this.maxYear,
  });

  factory PlayerRangeStats.fromJson(Map<String, dynamic> json) {
    return PlayerRangeStats(
      maxElo: json['maxElo'],
      minYear: json['minYear'],
      maxYear: json['maxYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'maxElo': maxElo, 'minYear': minYear, 'maxYear': maxYear};
  }
}
