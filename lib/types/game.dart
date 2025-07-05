import "package:bazaszachowa_flutter/types/move.dart";

class Game {
  Game({
    required this.id,
    required this.year,
    required this.moves,
    required this.white,
    required this.black,
    this.month,
    this.day,
    this.event,
    this.site,
    this.round,
    this.result,
    this.whiteElo,
    this.blackElo,
    this.eco,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    id: json["id"] ?? 0,
    year: json["Year"] ?? 0,
    month: json["Month"],
    day: json["Day"],
    moves: (json["moves"] as List<dynamic>? ?? <dynamic>[])
        .map((item) => Move.fromJson(item))
        .toList(),
    event: json["Event"],
    site: json["Site"],
    round: json["Round"],
    white: json["White"] ?? "",
    black: json["Black"] ?? "",
    result: json["Result"],
    whiteElo: json["WhiteElo"],
    blackElo: json["BlackElo"],
    eco: json["ECO"],
  );
  final int id;
  final int year;
  final int? month;
  final int? day;
  final String? event;
  final String? site;
  final String? round;
  final String white;
  final String black;
  final String? result;
  final int? whiteElo;
  final int? blackElo;
  final String? eco;
  final List<Move> moves;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "Year": year,
    "Month": month,
    "Day": day,
    "moves": moves.map((Move item) => item.toJson()).toList(),
    "Event": event,
    "Site": site,
    "Round": round,
    "White": white,
    "Black": black,
    "Result": result,
    "WhiteElo": whiteElo,
    "BlackElo": blackElo,
    "ECO": eco,
  };
}
