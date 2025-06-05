import 'package:bazaszachowa_flutter/types/FidePlayer.dart';
import 'package:flutter/material.dart';

class FideData extends StatelessWidget {
  const FideData({super.key, this.fidePlayers});
  final List<FidePlayer>? fidePlayers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (fidePlayers != null)
          ...fidePlayers!.map((item) {
            return Column(
              children: [
                Center(
                  child: Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        ...[
                          TableCell(child: Text("ID")),
                          TableCell(child: Text(item.fideId.toString())),
                        ].map(
                          (item) => Padding(
                            padding: EdgeInsets.all(4.0),
                            child: item,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        ...[
                          TableCell(child: Text("Tytuł")),
                          TableCell(child: Text(item.title ?? "Brak")),
                        ].map(
                          (item) => Padding(
                            padding: EdgeInsets.all(4.0),
                            child: item,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        ...[
                          TableCell(child: Text("Rocznik")),
                          TableCell(
                            child: Text(item.birthYear?.toString() ?? "N/A"),
                          ),
                        ].map(
                          (item) => Padding(
                            padding: EdgeInsets.all(4.0),
                            child: item,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "Elo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        ...[
                          TableCell(child: Text("Klasyczne")),
                          TableCell(
                            child: Text(
                              item.standardRating?.toString() ?? "N/A",
                            ),
                          ),
                        ].map(
                          (item) => Padding(
                            padding: EdgeInsets.all(4.0),
                            child: item,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        ...[
                          TableCell(child: Text("Szybkie")),
                          TableCell(
                            child: Text(item.rapidRating?.toString() ?? "N/A"),
                          ),
                        ].map(
                          (item) => Padding(
                            padding: EdgeInsets.all(4.0),
                            child: item,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        ...[
                          TableCell(child: Text("Błyskawiczne")),
                          TableCell(
                            child: Text(item.blitzRating?.toString() ?? "N/A"),
                          ),
                        ].map(
                          (item) => Padding(
                            padding: EdgeInsets.all(4.0),
                            child: item,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
      ],
    );
  }
}
