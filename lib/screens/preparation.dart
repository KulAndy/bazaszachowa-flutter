import 'package:bazaszachowa_flutter/api_config.dart';
import 'package:bazaszachowa_flutter/chess_processor.dart';
import 'package:bazaszachowa_flutter/components/chessboard/game_controller.dart';
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:chess/chess.dart' hide State;
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
  String? _fen = Chess.DEFAULT_POSITION;
  List<TableRow> _moves = [];

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
    if (_fen != null) {
      _moves = _processor.searchFEN(_fen!).moves.entries.map((entry) {
        final moveData = entry.value;
        return TableRow(
          children: [
            TableCell(child: Text(entry.key)),
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
                game: _game,
                onMove: (String fen) {
                  setState(() {
                    _fen = fen;
                    _updateMoves();
                  });
                },
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      const TableCell(child: Text("Move")),
                      const TableCell(child: Text("Last Year")),
                      const TableCell(child: Text("Games")),
                      const TableCell(child: Text("%")),
                    ],
                  ),
                  ..._moves,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
