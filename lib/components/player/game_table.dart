import 'package:bazaszachowa_flutter/screens/game_view.dart';
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:flutter/material.dart';

class GameTable extends StatelessWidget {
  final List<Game> games;
  final String base;
  const GameTable({super.key, required this.games, required this.base});

  void _navigateToGame(BuildContext context, int index, String base) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameView(
          games: games.map((item) => item.id).toList(),
          index: index,
          base: base,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(4),
                3: FlexColumnWidth(3),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(26),
                  ),
                  children: [
                    _buildTableHeader('Biały'),
                    _buildTableHeader('Wynik'),
                    _buildTableHeader('Czarny'),
                    _buildTableHeader('Data'),
                  ],
                ),

                ...games.asMap().entries.map((entry) {
                  final index = entry.key;
                  final game = entry.value;
                  return TableRow(
                    children: [
                      _buildTableCell(context, game.white, index),
                      _buildTableCenterCell(context, game.result ?? '*', index),
                      _buildTableCell(context, game.black, index),
                      _buildTableCell(
                        context,
                        '${game.year}.${game.month?.toString().padLeft(2, '0') ?? '??'}.${game.day?.toString().padLeft(2, '0') ?? '??'}',
                        index,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(BuildContext context, String text, int index) {
    return InkWell(
      onTap: () => _navigateToGame(context, index, base),
      child: Padding(padding: const EdgeInsets.all(12.0), child: Text(text)),
    );
  }

  Widget _buildTableCenterCell(BuildContext context, String text, int index) {
    return InkWell(
      onTap: () => _navigateToGame(context, index, base),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(child: Text(text)),
      ),
    );
  }
}
