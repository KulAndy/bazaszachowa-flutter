import "package:bazaszachowa_flutter/components/app/app_text_span.dart";
import "package:bazaszachowa_flutter/components/app/link.dart";
import "package:bazaszachowa_flutter/types/poland_player.dart";
import "package:flutter/material.dart";

class PolishData extends StatelessWidget {
  const PolishData({super.key, this.polandPlayers});
  final List<PolandPlayer>? polandPlayers;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      if (polandPlayers == null)
        const CircularProgressIndicator()
      else
        RichText(
          text: AppTextSpan(
            children: <TextSpan>[
              Link(
                text: "CR",
                context: context,
                href: "https://www.cr-pzszach.pl/",
              ),
            ],
            context: context,
          ),
        ),
      if (polandPlayers != null)
        ...polandPlayers!.map(
          (PolandPlayer item) => Column(
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
                          child: Text("Tytuł/Kat"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.title),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("CR ID"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.polandId),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("FIDE ID"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.fideId?.toString() ?? "N/A"),
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
