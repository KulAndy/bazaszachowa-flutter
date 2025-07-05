import "package:bazaszachowa_flutter/api_config.dart";
import "package:bazaszachowa_flutter/app_color_scheme.dart";
import "package:bazaszachowa_flutter/chess_processor.dart";
import "package:bazaszachowa_flutter/components/chessboard/game_controller.dart";
import "package:bazaszachowa_flutter/components/player/game_table.dart";
import "package:bazaszachowa_flutter/types/game.dart";
import "package:bazaszachowa_flutter/types/move.dart";
import "package:chess/chess.dart" as chess;
import "package:flutter/material.dart";

class Preparation extends StatefulWidget {
  const Preparation({
    required this.title,
    required this.playerName,
    required this.color,
    super.key,
  });
  final String title;
  final String playerName;
  final String color;

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  List<Game>? _games;
  final ChessProcessor _processor = ChessProcessor();
  final Game _game = Game(
    id: 0,
    year: 0,
    moves: <Move>[],
    white: "N, N",
    black: "N, N",
  );
  String? _fen = chess.Chess.DEFAULT_POSITION;
  List<TableRow> _moves = <TableRow>[];
  List<int> _indexes = <int>[];
  final GlobalKey<GameControllerState> _gameControllerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    try {
      final List<Game> games = await ApiConfig.searchFilterGames(
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    int index = 0;
    if (_fen != null) {
      final FenData result = _processor.searchFEN(_fen!);
      _indexes = result.indexes;
      _moves = result.moves.entries.map((MapEntry<String, MoveData> entry) {
        final MoveData moveData = entry.value;
        Color backgroundColor;
        if (isDark) {
          if (index.isEven) {
            backgroundColor = AppColors.darkEvenRow;
          } else {
            backgroundColor = AppColors.darkOddRow;
          }
        } else {
          if (index.isEven) {
            backgroundColor = AppColors.lightEvenRow;
          } else {
            backgroundColor = AppColors.lightOddRow;
          }
        }
        index++;
        return TableRow(
          decoration: BoxDecoration(color: backgroundColor),
          children: <Widget>[
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
                moveData.years
                    .reduce((int a, int b) => a > b ? a : b)
                    .toString(),
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: SafeArea(
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
              children: <TableRow>[
                const TableRow(
                  decoration: BoxDecoration(color: AppColors.middleGray),
                  children: <Widget>[
                    TableCell(child: Text("Ruch")),
                    TableCell(child: Text("Ostatnio")),
                    TableCell(child: Text("Gry")),
                    TableCell(child: Text("%")),
                  ],
                ),
                ..._moves,
              ],
            ),
            if (_games == null)
              const Center(child: CircularProgressIndicator())
            else
              GameTable(
                games: _games!
                    .where((Game item) => _indexes.contains(item.id))
                    .toList(),
                base: "all",
              ),
          ],
        ),
      ),
    ),
  );
}
