class PlayerRangeStats {
  PlayerRangeStats({
    required this.maxElo,
    required this.minYear,
    required this.maxYear,
  });

  factory PlayerRangeStats.fromJson(Map<String, dynamic> json) =>
      PlayerRangeStats(
        maxElo: json["maxElo"],
        minYear: json["minYear"],
        maxYear: json["maxYear"],
      );
  final int? maxElo;
  final int minYear;
  final int maxYear;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "maxElo": maxElo,
    "minYear": minYear,
    "maxYear": maxYear,
  };
}
