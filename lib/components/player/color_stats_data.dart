import 'package:bazaszachowa_flutter/app_color_scheme.dart';
import 'package:bazaszachowa_flutter/screens/player.dart';
import 'package:bazaszachowa_flutter/types/opening_stats.dart';
import 'package:flutter/material.dart';

class ColorStatsData extends StatelessWidget {
  final List<ColorStats> colorStats;
  final String header;
  final String colorPrefix;
  final String playerName;

  const ColorStatsData({
    super.key,
    required this.colorStats,
    required this.header,
    required this.colorPrefix,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              builder: (context) => Player(
                playerName: playerName,
                color: colorPrefix,
                opening: null,
              ),
            ),
          ),
          child: const Text(
            'Filtruj',
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppColors.middleGray),
                children: ["Debiut", "Ilość", "%"]
                    .map(
                      (text) => TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(text, textAlign: TextAlign.center),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ...colorStats.asMap().entries.map((entry) {
                var item = entry.value;
                int index = entry.key;
                sum += item.count;
                percentageSum += item.percentage * item.count;
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
                return TableRow(
                  decoration: BoxDecoration(color: backgroundColor),
                  children:
                      [
                            item.opening,
                            item.count.toString(),
                            item.percentage.toString(),
                          ]
                          .map(
                            (text) => TableCell(
                              child: GestureDetector(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Player(
                                      playerName: playerName,
                                      color: colorPrefix,
                                      opening: item.opening,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                decoration: BoxDecoration(color: AppColors.middleGray),
                children:
                    [
                          "Podsumowanie",
                          sum.toString(),
                          (percentageSum / sum).toStringAsFixed(2),
                        ]
                        .map(
                          (text) => TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
