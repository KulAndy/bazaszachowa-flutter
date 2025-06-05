import 'package:bazaszachowa_flutter/types/OpeningStats.dart';
import 'package:flutter/material.dart';

class ColorStatsData extends StatelessWidget {
  final List<ColorStats> colorStats;
  final String header;
  final String colorPrefix;

  const ColorStatsData({
    Key? key,
    required this.colorStats,
    required this.header,
    required this.colorPrefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int sum = 0;
    double percantageSum = 0;
    return ExpansionTile(
      title: Text(header),
      children: <Widget>[
        GestureDetector(
          onTap: () => print(colorPrefix),
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
          child: IntrinsicWidth(
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              children: [
                TableRow(
                  children: [
                    ...[
                      TableCell(
                        child: Text("Debiut", textAlign: TextAlign.center),
                      ),
                      TableCell(
                        child: Text("Ilość", textAlign: TextAlign.center),
                      ),
                      TableCell(child: Text("%", textAlign: TextAlign.center)),
                    ].map(
                      (item) =>
                          Padding(padding: EdgeInsets.all(4.0), child: item),
                    ),
                  ],
                ),
                ...colorStats.map((item) {
                  sum += item.count;
                  percantageSum += item.percentage * item.count;
                  return TableRow(
                    children: [
                      ...[
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.opening,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.count.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.percentage.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ].map(
                        (item) =>
                            Padding(padding: EdgeInsets.all(4.0), child: item),
                      ),
                    ],
                  );
                }).toList(),
                TableRow(
                  children: [
                    ...[
                      TableCell(
                        child: Text(
                          "Podsumowanie",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          sum.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          (percantageSum / sum).toStringAsFixed(2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ].map(
                      (item) =>
                          Padding(padding: EdgeInsets.all(4.0), child: item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
