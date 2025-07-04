import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:bazaszachowa_flutter/types/move.dart';
import 'package:chess/chess.dart' as chess_lib;

String cutStringToSecondSpace(String inputString) {
  final lastSpaceIndex = inputString.indexOf(' ', inputString.indexOf(' ') + 1);
  return inputString.substring(0, lastSpaceIndex);
}

const int firstBatchLimit = 40;

class Stats {
  int count;
  double points;

  Stats({this.count = 0, this.points = 0});

  Map<String, dynamic> toJson() {
    return {'count': count, 'points': points};
  }
}

class MoveData {
  int games;
  double points;
  List<int> years;
  Map<int, Stats> stats;

  MoveData({
    required this.games,
    required this.points,
    required this.years,
    required this.stats,
  });

  Map<String, dynamic> toJson() {
    return {
      'games': games,
      'points': points,
      'years': years,
      'stats': stats.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
    };
  }
}

class FenData {
  Map<String, MoveData> moves = {};
  List<int> indexes = [];

  Map<String, dynamic> toJson() {
    return {
      ...moves.map((key, value) => MapEntry(key, value.toJson())),
      'indexes': indexes,
    };
  }
}

class ChessProcessor {
  String currentFEN = "";
  Map<String, FenData> fensObj = {};
  List<Game> games = [];
  bool isCompleted = false;

  Future<Map<String, FenData>> getTree(List<Game> rows) async {
    isCompleted = false;
    games = rows;
    final fensPromises = rows.map((row) => getFENsFirstBatch(row));
    final fensArray = await Future.wait(fensPromises);
    fensObj = mergeFensArray(fensArray);

    return fensObj;
  }

  Map<String, FenData> mergeFensArray(List<Map<String, FenData>> fensArray) {
    final Map<String, FenData> mergedFensObj = {};
    for (final fens in fensArray) {
      fens.forEach((fen, data) {
        if (mergedFensObj.containsKey(fen)) {
          mergedFensObj[fen]!.indexes.addAll(data.indexes);
          data.moves.forEach((move, moveData) {
            if (mergedFensObj[fen]!.moves.containsKey(move)) {
              final existingMoveData = mergedFensObj[fen]!.moves[move]!;
              existingMoveData.games += moveData.games;
              existingMoveData.points += moveData.points;
              existingMoveData.years.addAll(moveData.years);
              moveData.stats.forEach((year, stat) {
                if (existingMoveData.stats.containsKey(year)) {
                  existingMoveData.stats[year]!.count += stat.count;
                  existingMoveData.stats[year]!.points += stat.points;
                } else {
                  existingMoveData.stats[year] = Stats()
                    ..count = stat.count
                    ..points = stat.points;
                }
              });
            } else {
              mergedFensObj[fen]!.moves[move] = moveData;
            }
          });
        } else {
          mergedFensObj[fen] = data;
        }
      });
    }
    return mergedFensObj;
  }

  Future<Map<String, FenData>> getFENsFirstBatch(Game row) async {
    final moves = row.moves;
    final points = row.result == '1-0'
        ? 1.0
        : row.result == '0-1'
        ? 0.0
        : 0.5;
    final chess = chess_lib.Chess();
    final Map<String, FenData> fens = {};
    int i = 0;

    for (final move in moves) {
      final result = await processMove(
        chess,
        move,
        i % 2 == 0 ? points : 1 - points,
        row.year,
      );
      if (result['fen'] != null && result['doneMove'] != null) {
        final fen = result['fen']!;
        if (fens.containsKey(fen)) {
          if (fens[fen]!.moves.containsKey(result['doneMove']!['san'])) {
            final moveData = fens[fen]!.moves[result['doneMove']!['san']]!;
            moveData.games += 1;
            moveData.points += result['data']['points'];
            moveData.years.addAll(result['data']['years']);
            if (!moveData.stats.containsKey(row.year)) {
              moveData.stats[row.year] = Stats()
                ..count = 1
                ..points = result['data']['points'];
            }
          } else {
            fens[fen]!.moves[result['doneMove']!['san']] = MoveData(
              games: 1,
              points: result['data']['points'],
              years: result['data']['years'],
              stats: {
                row.year: Stats()
                  ..count = 1
                  ..points = result['data']['points'],
              },
            );
          }
        } else {
          fens[fen] = FenData()
            ..moves[result['doneMove']!['san']] = MoveData(
              games: 1,
              points: result['data']['points'],
              years: result['data']['years'],
              stats: {
                row.year: Stats()
                  ..count = 1
                  ..points = result['data']['points'],
              },
            )
            ..indexes = [row.id];
        }
      }
      if (i++ >= firstBatchLimit || result['doneMove'] == null) {
        break;
      }
    }
    return fens;
  }

  Future<Map<String, dynamic>> processMove(
    chess_lib.Chess chess,
    Move move,
    double points,
    int year,
  ) async {
    final rawFen = chess.fen;
    final fen = cutStringToSecondSpace(rawFen);

    if (!chess.move({
      'from': move.from,
      'to': move.to,
      'promotion': move.promotion,
    })) {
      throw Exception("Cannot make move ${move.from} ${move.to} in $fen");
    }

    var history = chess.getHistory({'verbose': true});

    if (history.isEmpty) {
      throw Exception("No history after move ${move.from} ${move.to} in $fen");
    }

    Map<String, dynamic> moveObj = history.last;
    return {
      'fen': fen,
      'data': {
        'games': 1,
        'points': points,
        'years': [year],
        'stats': <int, Stats>{},
      },
      'doneMove': moveObj,
    };
  }

  FenData searchFEN([String fen = chess_lib.Chess.DEFAULT_POSITION]) {
    fen = fen.trim();
    if (fen.isEmpty) {
      fen = chess_lib.Chess.DEFAULT_POSITION;
    }
    fen = cutStringToSecondSpace(fen);

    if (fensObj.containsKey(fen)) {
      final fens = FenData()
        ..moves = Map.from(fensObj[fen]!.moves)
        ..indexes = List.from(fensObj[fen]!.indexes);
      final moves = fens.moves.entries
          .map((entry) => {'move': entry.key, ...entry.value.toJson()})
          .toList();
      moves.sort((a, b) => (b['games'] as int).compareTo(a['games'] as int));
      final sortedFenData = FenData()
        ..indexes = fens.indexes
        ..moves = Map.fromEntries(
          moves.map(
            (e) => MapEntry(
              e['move'] as String,
              MoveData(
                games: e['games'] as int,
                points: (e['points'] as num).toDouble(),
                years: List<int>.from(e['years'] as List),
                stats: Map<int, Stats>.from(
                  (e['stats'] as Map).map(
                    (key, value) => MapEntry(
                      int.parse(key),
                      Stats()
                        ..count = (value['count'] as num).toInt()
                        ..points = (value['points'] as num).toDouble(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      return sortedFenData;
    } else {
      return FenData();
    }
  }

  Future<Map<String, FenData>> getFENsSecondBatch(Game row) async {
    final moves = row.moves;
    final points = row.result == '1-0'
        ? 1.0
        : row.result == '0-1'
        ? 0.0
        : 0.5;
    final chess = chess_lib.Chess();
    final Map<String, FenData> fens = {};
    int i = 0;

    for (final move in moves) {
      final result = await processMove(chess, move, points, row.year);
      if (i++ < firstBatchLimit) {
        continue;
      }
      if (result['fen'] != null && result['doneMove'] != null) {
        final fen = result['fen']!;
        if (fensObj.containsKey(fen)) {
          fensObj[fen]!.indexes.add(row.id);
          if (fensObj[fen]!.moves.containsKey(result['doneMove']!['san'])) {
            final moveData = fensObj[fen]!.moves[result['doneMove']!['san']]!;
            moveData.games += 1;
            moveData.points += result['data']['points'];
            moveData.years.add(result['data']['years'][0]);
          } else {
            fensObj[fen]!.moves[result['doneMove']!['san']] = MoveData(
              games: 1,
              points: result['data']['points'],
              years: [result['data']['years'][0]],
              stats: {},
            );
          }
        } else {
          fensObj[fen] = FenData()
            ..moves[result['doneMove']!['san']] = MoveData(
              games: 1,
              points: result['data']['points'],
              years: [result['data']['years'][0]],
              stats: {},
            )
            ..indexes = [row.id];
        }
      }
      if (result['doneMove'] == null) {
        return fens;
      }
    }
    return fens;
  }

  Future<void> completeTree() async {
    const batchSize = 5;
    int index = 0;
    void processBatch() async {
      for (int i = 0; i < batchSize && index < games.length; i++) {
        final row = games[index];
        await getFENsSecondBatch(row);
        index++;
      }
      if (index < games.length) {
        Future.delayed(Duration.zero, processBatch);
      } else {
        isCompleted = true;
      }
    }

    processBatch();
  }
}
