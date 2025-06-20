import 'package:bazaszachowa_flutter/types/move.dart';

class Game {
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

  Game({
    required this.id,
    required this.year,
    this.month,
    this.day,
    required this.moves,
    this.event,
    this.site,
    this.round,
    required this.white,
    required this.black,
    this.result,
    this.whiteElo,
    this.blackElo,
    this.eco,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      year: json['Year'],
      month: json['Month'],
      day: json['Day'],
      moves: (json['moves'] as List)
          .map((item) => Move.fromJson(item))
          .toList(),
      event: json['Event'],
      site: json['Site'],
      round: json['Round'],
      white: json['White'],
      black: json['Black'],
      result: json['Result'],
      whiteElo: json['WhiteElo'],
      blackElo: json['BlackElo'],
      eco: json['ECO'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Year": year,
      "Month": month,
      "Day": day,
      "moves": moves.map((item) => item.toJson()),
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
}
