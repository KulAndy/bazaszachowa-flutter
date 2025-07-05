import "package:bazaszachowa_flutter/app_color_scheme.dart";
import "package:bazaszachowa_flutter/screens/player.dart";
import "package:bazaszachowa_flutter/types/opening_stats.dart";
import "package:flutter/material.dart";

class ColorStatsData extends StatelessWidget {
  const ColorStatsData({
    required this.colorStats,
    required this.header,
    required this.colorPrefix,
    required this.playerName,
    super.key,
  });
  final List<ColorStats> colorStats;
  final String header;
  final String colorPrefix;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    int sum = 0;
    double percentageSum = 0;

    return ExpansionTile(
      title: Text(header),
      collapsedBackgroundColor: AppColors.middleGray,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  Player(playerName: playerName, color: colorPrefix),
            ),
          ),
          child: const Text(
            "Filtruj",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth(),
            },
            children: <TableRow>[
              TableRow(
                decoration: const BoxDecoration(color: AppColors.middleGray),
                children: <String>["Debiut", "Ilość", "%"]
                    .map(
                      (String text) => TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(text, textAlign: TextAlign.center),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ...colorStats.asMap().entries.map((
                MapEntry<int, ColorStats> entry,
              ) {
                final ColorStats item = entry.value;
                final int index = entry.key;
                sum += item.count;
                percentageSum += item.percentage * item.count;
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
                  children:
                      <String>[
                            item.opening,
                            item.count.toString(),
                            item.percentage.toString(),
                          ]
                          .map(
                            (String text) => TableCell(
                              child: GestureDetector(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Player(
                                      playerName: playerName,
                                      color: colorPrefix,
                                      opening: item.opening,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                );
              }),
              TableRow(
                decoration: const BoxDecoration(color: AppColors.middleGray),
                children:
                    <String>[
                          "Podsumowanie",
                          sum.toString(),
                          (percentageSum / sum).toStringAsFixed(2),
                        ]
                        .map(
                          (String text) => TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(text, textAlign: TextAlign.center),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
