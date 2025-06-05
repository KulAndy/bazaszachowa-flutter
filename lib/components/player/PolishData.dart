import 'package:bazaszachowa_flutter/components/app/Link.dart';
import 'package:bazaszachowa_flutter/types/PolandPlayer.dart';
import 'package:flutter/material.dart';

class PolishData extends StatelessWidget {
  const PolishData({super.key, this.polandPlayers});
  final List<PolandPlayer>? polandPlayers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (polandPlayers == null)
          const CircularProgressIndicator()
        else
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                Link(
                  text: 'CR',
                  context: context,
                  href: 'https://www.cr-pzszach.pl/',
                ),
              ],
            ),
          ),
        if (polandPlayers != null)
          ...polandPlayers!.map((item) {
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
                          TableCell(child: Text("Tytuł/Kat")),
                          TableCell(child: Text(item.title)),
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
                          TableCell(child: Text("CR ID")),
                          TableCell(child: Text(item.polandId.toString())),
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
                          TableCell(child: Text("FIDE ID")),
                          TableCell(
                            child: Text(item.fideId?.toString() ?? 'N/A'),
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
