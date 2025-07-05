import "package:bazaszachowa_flutter/api_config.dart";
import "package:bazaszachowa_flutter/components/app/app_text_span.dart";
import "package:bazaszachowa_flutter/components/app/link.dart";
import "package:bazaszachowa_flutter/components/player/color_stats_data.dart";
import "package:bazaszachowa_flutter/components/player/fide_data.dart";
import "package:bazaszachowa_flutter/components/player/game_table.dart";
import "package:bazaszachowa_flutter/components/player/polish_data.dart";
import "package:bazaszachowa_flutter/types/fide_player.dart";
import "package:bazaszachowa_flutter/types/game.dart";
import "package:bazaszachowa_flutter/types/opening_stats.dart";
import "package:bazaszachowa_flutter/types/player_range_stats.dart";
import "package:bazaszachowa_flutter/types/poland_player.dart";
import "package:flutter/material.dart";

class Player extends StatefulWidget {
  const Player({required this.playerName, super.key, this.opening, this.color});
  final String playerName;
  final String? color;
  final String? opening;

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
    } else if (oldWidget.color != widget.color ||
        oldWidget.opening != widget.opening) {
      _fetchGames();
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
      final PlayerRangeStats stats = await ApiConfig.searchMinMaxYearElo(
        widget.playerName,
      );
      setState(() {
        _playerRangeStats = stats;
      });
    } catch (e) {
      setState(() => _playerRangeStats = null);
    }
  }

  Future<void> _fetchPolandPlayer() async {
    try {
      final List<PolandPlayer> players = await ApiConfig.searchPolandPlayers(
        widget.playerName,
      );
      setState(() {
        _polandPlayers = players;
      });
    } catch (e) {
      setState(() => _polandPlayers = null);
    }
  }

  Future<void> _fetchFidePlayer() async {
    try {
      final List<FidePlayer> players = await ApiConfig.searchFidePlayers(
        widget.playerName,
      );
      setState(() {
        _fidePlayers = players;
      });
    } catch (e) {
      setState(() => _fidePlayers = null);
    }
  }

  Future<void> _fetchOpeningStats() async {
    try {
      final OpeningStats stats = await ApiConfig.searchOpeningStats(
        widget.playerName,
      );
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
          searching: "fulltext",
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.playerName)),
    body: SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_playerRangeStats == null)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: <Widget>[
                  if (_playerRangeStats!.maxElo != null)
                    _buildStatItem(
                      "Najwyższy osiągnięty ranking",
                      _playerRangeStats!.maxElo.toString(),
                    ),
                  _buildStatItem(
                    // ignore: lines_longer_than_80_chars
                    "Gry z lat ${_playerRangeStats!.minYear} - ${_playerRangeStats!.maxYear}",
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
                children: <Widget>[
                  RichText(
                    text: AppTextSpan(
                      children: <TextSpan>[
                        Link(
                          text: "FIDE",
                          context: context,
                          href: "https://www.fide.com/",
                        ),
                      ],
                      context: context,
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
                children: <Widget>[
                  ColorStatsData(
                    colorStats: _openingStats!.white,
                    header: "Białe",
                    colorPrefix: "white",
                    playerName: widget.playerName,
                  ),
                  ColorStatsData(
                    colorStats: _openingStats!.black,
                    header: "Czarne",
                    colorPrefix: "black",
                    playerName: widget.playerName,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Player(playerName: widget.playerName),
                      ),
                    ),
                    child: const Text("Reset"),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            if (_games == null)
              const Center(child: CircularProgressIndicator())
            else ...<Widget>[
              Text("Znaleziono ${_games!.length}", textAlign: TextAlign.center),
              GameTable(games: _games!, base: "all"),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _buildStatItem(String label, [String? value]) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        if (value != null) Text(value),
      ],
    ),
  );
}
