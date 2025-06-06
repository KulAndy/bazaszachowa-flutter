import 'package:bazaszachowa_flutter/screens/Player.dart';
import 'package:bazaszachowa_flutter/types/OpeningStats.dart';
import 'package:flutter/material.dart';

class ColorStatsData extends StatelessWidget {
  final List<ColorStats> colorStats;
  final String header;
  final String colorPrefix;
  final String playerName;

  const ColorStatsData({
    Key? key,
    required this.colorStats,
    required this.header,
    required this.colorPrefix,
    required this.playerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int sum = 0;
    double percentageSum = 0;

    return ExpansionTile(
      title: Text(header),
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
              ...colorStats.map((item) {
                sum += item.count;
                percentageSum += item.percentage * item.count;
                return TableRow(
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
              }).toList(),
              TableRow(
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
