import 'package:bazaszachowa_flutter/ApiConfig.dart';
import 'package:bazaszachowa_flutter/components/app/Link.dart';
import 'package:bazaszachowa_flutter/components/player/ColorStatsData.dart';
import 'package:bazaszachowa_flutter/components/player/FideData.dart';
import 'package:bazaszachowa_flutter/components/player/PolishData.dart';
import 'package:bazaszachowa_flutter/types/FidePlayer.dart';
import 'package:bazaszachowa_flutter/types/OpeningStats.dart';
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
  OpeningStats? _openingStats;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  void didUpdateWidget(Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerName != widget.playerName) {
      refresh();
    }
  }

  void refresh() {
    _fetchPlayerRangeStats();
    _fetchPolandPlayer();
    _fetchFidePlayer();
    _fetchOpeningStats();
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

  Future<void> _fetchOpeningStats() async {
    try {
      final stats = await ApiConfig.searchOpeningStats(widget.playerName);
      setState(() {
        _openingStats = stats;
      });
    } catch (e) {
      setState(() => _openingStats = null);
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
              PolishData(polandPlayers: _polandPlayers),
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
              FideData(fidePlayers: _fidePlayers),
              const SizedBox(height: 20),
              if (_openingStats == null)
                const CircularProgressIndicator()
              else ...[
                ColorStatsData(
                  colorStats: _openingStats!.white,
                  header: "Białe",
                  colorPrefix: 'white',
                ),
                ColorStatsData(
                  colorStats: _openingStats!.black,
                  header: "Czarne",
                  colorPrefix: 'black',
                ),
                GestureDetector(
                  onTap: () => print("reset"),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
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
