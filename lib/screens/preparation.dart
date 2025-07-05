import 'package:bazaszachowa_flutter/api_config.dart';
import 'package:bazaszachowa_flutter/app_color_scheme.dart';
import 'package:bazaszachowa_flutter/chess_processor.dart';
import 'package:bazaszachowa_flutter/components/chessboard/game_controller.dart';
import 'package:bazaszachowa_flutter/components/player/game_table.dart';
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:chess/chess.dart' as chess;
import 'package:flutter/material.dart';

class Preparation extends StatefulWidget {
  final String title;
  final String playerName;
  final String color;

  const Preparation({
    super.key,
    required this.title,
    required this.playerName,
    required this.color,
  });

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  List<Game>? _games;
  final ChessProcessor _processor = ChessProcessor();
  Game _game = Game(id: 0, year: 0, moves: [], white: "N, N", black: "N, N");
  String? _fen = chess.Chess.DEFAULT_POSITION;
  List<TableRow> _moves = [];
  List<int> _indexes = [];
  final GlobalKey<GameControllerState> _gameControllerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    try {
      List<Game> games = await ApiConfig.searchFilterGames(
        widget.playerName,
        widget.color,
        null,
      );
      await _processor.getTree(games);
      setState(() {
        _games = games;
        _updateMoves();
      });
    } catch (e) {
      setState(() => _games = null);
    }
  }

  void _updateMoves() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int index = 0;
    if (_fen != null) {
      var result = _processor.searchFEN(_fen!);
      _indexes = result.indexes;
      _moves = result.moves.entries.map((entry) {
        final moveData = entry.value;
        Color backgroundColor;
        if (isDark) {
          if (index % 2 == 0) {
            backgroundColor = AppColors.darkEvenRow;
          } else {
            backgroundColor = AppColors.darkOddRow;
          }
        } else {
          if (index % 2 == 0) {
            backgroundColor = AppColors.lightEvenRow;
          } else {
            backgroundColor = AppColors.lightOddRow;
          }
        }
        index++;
        return TableRow(
          decoration: BoxDecoration(color: backgroundColor),
          children: [
            TableCell(
              child: GestureDetector(
                onTap: () {
                  _gameControllerKey.currentState?.makeMove(
                    from: moveData.from,
                    to: moveData.to,
                    promotion: moveData.promotion,
                  );
                },
                child: Text(entry.key),
              ),
            ),
            TableCell(
              child: Text(
                moveData.years.reduce((a, b) => a > b ? a : b).toString(),
              ),
            ),
            TableCell(child: Text(moveData.games.toString())),
            TableCell(
              child: Text(
                (moveData.points / moveData.games * 100).toStringAsFixed(2),
              ),
            ),
          ],
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GameController(
                key: _gameControllerKey,
                game: _game,
                onMove: (String fen) {
                  setState(() {
                    _fen = fen;
                    _updateMoves();
                  });
                },
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: AppColors.middleGray),
                    children: [
                      TableCell(child: Text("Ruch")),
                      TableCell(child: Text("Ostatnio")),
                      TableCell(child: Text("Gry")),
                      TableCell(child: Text("%")),
                    ],
                  ),
                  ..._moves,
                ],
              ),
              if (_games != null)
                GameTable(
                  games: _games!
                      .where((item) => _indexes.contains(item.id))
                      .toList(),
                  base: "all",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
