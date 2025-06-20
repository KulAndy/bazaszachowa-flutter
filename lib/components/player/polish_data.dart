import 'package:bazaszachowa_flutter/components/app/link.dart';
import 'package:bazaszachowa_flutter/types/poland_player.dart';
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Tytuł/Kat"),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(item.title),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("CR ID"),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(item.polandId.toString()),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("FIDE ID"),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(item.fideId?.toString() ?? 'N/A'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          }),
      ],
    );
  }
}
