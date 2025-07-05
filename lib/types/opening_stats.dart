class OpeningStats {
  OpeningStats({required this.white, required this.black});

  factory OpeningStats.fromJson(Map<String, dynamic> json) => OpeningStats(
    white: (json["whites"] as List<dynamic>)
        .map((i) => ColorStats.fromJson(i))
        .toList(),
    black: (json["blacks"] as List<dynamic>)
        .map((i) => ColorStats.fromJson(i))
        .toList(),
  );
  final List<ColorStats> white;
  final List<ColorStats> black;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "whites": white.map((ColorStats e) => e.toJson()).toList(),
    "blacks": black.map((ColorStats e) => e.toJson()).toList(),
  };
}

class ColorStats {
  ColorStats({
    required this.opening,
    required this.count,
    required this.percentage,
  });

  factory ColorStats.fromJson(Map<String, dynamic> json) => ColorStats(
    opening: json["opening"],
    count: json["count"],
    percentage: (json["percent"] as num).toDouble(),
  );
  final String opening;
  final int count;
  final double percentage;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "opening": opening,
    "count": count,
    "percent": percentage,
  };
}
