import 'package:bazaszachowa_flutter/api_config.dart';
import 'package:bazaszachowa_flutter/components/app/link.dart';
import 'package:bazaszachowa_flutter/components/player/color_stats_data.dart';
import 'package:bazaszachowa_flutter/components/player/fide_data.dart';
import 'package:bazaszachowa_flutter/components/player/game_table.dart';
import 'package:bazaszachowa_flutter/components/player/polish_data.dart';
import 'package:bazaszachowa_flutter/types/fide_player.dart';
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:bazaszachowa_flutter/types/opening_stats.dart';
import 'package:bazaszachowa_flutter/types/player_range_stats.dart';
import 'package:bazaszachowa_flutter/types/poland_player.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final String playerName;
  final String? color;
  final String? opening;

  const Player({super.key, required this.playerName, this.opening, this.color});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerRangeStats? _playerRangeStats;
  List<PolandPlayer>? _polandPlayers;
  List<FidePlayer>? _fidePlayers;
  OpeningStats? _openingStats;
  List<Game>? _games;

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
    _fetchGames();
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

  Future<void> _fetchGames() async {
    try {
      List<Game>? games;
      if (widget.color == null) {
        games = (await ApiConfig.searchGames(
          white: widget.playerName,
          ignore: true,
          base: 'all',
          searching: 'fulltext',
        )).games;
      } else {
        games = await ApiConfig.searchFilterGames(
          widget.playerName,
          widget.color!,
          widget.opening,
        );
      }
      setState(() {
        _games = games;
      });
    } catch (e) {
      setState(() => _games = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.playerName)),
      body: SafeArea(
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 12),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_playerRangeStats == null)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    if (_playerRangeStats!.maxElo != null)
                      _buildStatItem(
                        'Najwyższy osiągnięty ranking',
                        _playerRangeStats!.maxElo.toString(),
                      ),
                    _buildStatItem(
                      'Gry z lat ${_playerRangeStats!.minYear} - ${_playerRangeStats!.maxYear}',
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              PolishData(polandPlayers: _polandPlayers),

              const SizedBox(height: 20),

              if (_fidePlayers == null)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                  ],
                ),

              const SizedBox(height: 20),

              if (_openingStats == null)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    ColorStatsData(
                      colorStats: _openingStats!.white,
                      header: "Białe",
                      colorPrefix: 'white',
                      playerName: widget.playerName,
                    ),
                    ColorStatsData(
                      colorStats: _openingStats!.black,
                      header: "Czarne",
                      colorPrefix: 'black',
                      playerName: widget.playerName,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Player(
                            playerName: widget.playerName,
                            color: null,
                            opening: null,
                          ),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              if (_games == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                Text("Znaleziono ${_games!.length}"),
                GameTable(games: _games!, base: 'all'),
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
