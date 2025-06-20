class OpeningStats {
  final List<ColorStats> white;
  final List<ColorStats> black;

  OpeningStats({required this.white, required this.black});

  factory OpeningStats.fromJson(Map<String, dynamic> json) {
    return OpeningStats(
      white: (json['whites'] as List)
          .map((i) => ColorStats.fromJson(i))
          .toList(),
      black: (json['blacks'] as List)
          .map((i) => ColorStats.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "whites": white.map((e) => e.toJson()).toList(),
      "blacks": black.map((e) => e.toJson()).toList(),
    };
  }
}

class ColorStats {
  final String opening;
  final int count;
  final double percentage;

  ColorStats({
    required this.opening,
    required this.count,
    required this.percentage,
  });

  factory ColorStats.fromJson(Map<String, dynamic> json) {
    return ColorStats(
      opening: json['opening'],
      count: json['count'],
      percentage: (json['percent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"opening": opening, "count": count, "percent": percentage};
  }
}
