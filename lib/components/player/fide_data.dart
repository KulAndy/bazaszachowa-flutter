import "package:bazaszachowa_flutter/types/fide_player.dart";
import "package:flutter/material.dart";

class FideData extends StatelessWidget {
  const FideData({super.key, this.fidePlayers});
  final List<FidePlayer>? fidePlayers;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      if (fidePlayers != null)
        ...fidePlayers!.map(
          (FidePlayer item) => Column(
            children: <Widget>[
              Center(
                child: Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("ID"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.fideId.toString()),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Tytuł"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.title ?? "Brak"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Rocznik"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.birthYear?.toString() ?? "N/A"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Center(
                child: Text(
                  "Elo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Klasyczne"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.standardRating?.toString() ?? "N/A"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Szybkie"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.rapidRating?.toString() ?? "N/A"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Błyskawiczne"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.blitzRating?.toString() ?? "N/A"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
    ],
  );
}
