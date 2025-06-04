import 'package:bazaszachowa_flutter/ApiConfig.dart';
import 'package:bazaszachowa_flutter/components/app/Link.dart';
import 'package:bazaszachowa_flutter/types/FidePlayer.dart';
import 'package:bazaszachowa_flutter/types/PlayerRangeStats.dart';
import 'package:bazaszachowa_flutter/types/PolandPlayer.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final String playerName;

  const Player({super.key, required this.playerName});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerRangeStats? _playerRangeStats;
  List<PolandPlayer>? _polandPlayers;
  List<FidePlayer>? _fidePlayers;

  @override
  void initState() {
    super.initState();
    _fetchPlayerRangeStats();
    _fetchPolandPlayer();
    _fetchFidePlayer();
  }

  @override
  void didUpdateWidget(Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerName != widget.playerName) {
      _fetchPlayerRangeStats();
      _fetchPolandPlayer();
      _fetchFidePlayer();
    }
  }

  Future<void> _fetchPlayerRangeStats() async {
    try {
      final stats = await ApiConfig.searchMinMaxYearElo(widget.playerName);
      setState(() {
        _playerRangeStats = stats;
      });
    } catch (e) {
      setState(() => _playerRangeStats = null);
    }
  }

  Future<void> _fetchPolandPlayer() async {
    try {
      final players = await ApiConfig.searchPolandPlayers(widget.playerName);
      setState(() {
        _polandPlayers = players;
      });
    } catch (e) {
      setState(() => _polandPlayers = null);
    }
  }

  Future<void> _fetchFidePlayer() async {
    try {
      final players = await ApiConfig.searchFidePlayers(widget.playerName);
      setState(() {
        _fidePlayers = players;
      });
    } catch (e) {
      setState(() => _fidePlayers = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.playerName)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (_playerRangeStats == null)
                const CircularProgressIndicator()
              else ...[
                if (_playerRangeStats!.maxElo != null)
                  _buildStatItem(
                    'Najwyższy osiągnięty ranking',
                    _playerRangeStats!.maxElo.toString(),
                  ),
                _buildStatItem(
                  'Gry z lat ${_playerRangeStats!.minYear} - ${_playerRangeStats!.maxYear}',
                ),
              ],
              const SizedBox(height: 20),
              if (_polandPlayers == null)
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
              if (_polandPlayers != null)
                ..._polandPlayers!.map((item) {
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
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text("Tytuł/Kat")),
                              TableCell(child: Text(item.title)),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: Text("CR ID")),
                              TableCell(child: Text(item.polandId.toString())),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: Text("FIDE ID")),
                              TableCell(
                                child: Text(item.fideId?.toString() ?? 'N/A'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              const SizedBox(height: 20),
              if (_fidePlayers == null)
                const CircularProgressIndicator()
              else
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      Link(
                        text: 'FIDE',
                        context: context,
                        href: 'https://www.fide.com/',
                      ),
                    ],
                  ),
                ),
              if (_fidePlayers != null)
                ..._fidePlayers!.map((item) {
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
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text("ID")),
                              TableCell(child: Text(item.fideId.toString())),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: Text("Tytuł")),
                              TableCell(child: Text(item.title ?? "Brak")),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: Text("Rocznik")),
                              TableCell(
                                child: Text(
                                  item.birthYear?.toString() ?? "N/A",
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
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text("Klasyczne")),
                              TableCell(
                                child: Text(
                                  item.standardRating?.toString() ?? "N/A",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: Text("Szybkie")),
                              TableCell(
                                child: Text(
                                  item.rapidRating?.toString() ?? "N/A",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: Text("Błyskawiczne")),
                              TableCell(
                                child: Text(
                                  item.blitzRating?.toString() ?? "N/A",
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
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, [String? value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          if (value != null) Text(value),
        ],
      ),
    );
  }
}
