import "package:bazaszachowa_flutter/app_color_scheme.dart";
import "package:bazaszachowa_flutter/screens/game_view.dart";
import "package:bazaszachowa_flutter/types/game.dart";
import "package:flutter/material.dart";

class GameTable extends StatelessWidget {
  const GameTable({required this.games, required this.base, super.key});
  final List<Game> games;
  final String base;

  void _navigateToGame(BuildContext context, int index, String base) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GameView(
          games: games.map((Game item) => item.id).toList(),
          index: index,
          base: base,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(4),
                  3: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    decoration: const BoxDecoration(
                      color: AppColors.middleGray,
                    ),
                    children: <Widget>[
                      _buildTableHeader("Biały"),
                      _buildTableHeader("Wynik"),
                      _buildTableHeader("Czarny"),
                      _buildTableHeader("Data"),
                    ],
                  ),

                  ...games.asMap().entries.map((MapEntry<int, Game> entry) {
                    final int index = entry.key;
                    final Game game = entry.value;

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
                    return TableRow(
                      decoration: BoxDecoration(color: backgroundColor),
                      children: <Widget>[
                        _buildTableCell(context, game.white, index),
                        _buildTableCenterCell(
                          context,
                          game.result ?? "*",
                          index,
                        ),
                        _buildTableCell(context, game.black, index),
                        _buildTableCell(
                          context,
                          // ignore: lines_longer_than_80_chars
                          '${game.year}.${game.month?.toString().padLeft(2, '0') ?? '??'}.${game.day?.toString().padLeft(2, '0') ?? '??'}',
                          index,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTableHeader(String text) => Padding(
    padding: const EdgeInsets.all(12),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildTableCell(BuildContext context, String text, int index) =>
      InkWell(
        onTap: () => _navigateToGame(context, index, base),
        child: Padding(padding: const EdgeInsets.all(12), child: Text(text)),
      );

  Widget _buildTableCenterCell(BuildContext context, String text, int index) =>
      InkWell(
        onTap: () => _navigateToGame(context, index, base),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(child: Text(text)),
        ),
      );
}
