import 'package:bazaszachowa_flutter/ApiConfig.dart';
import 'package:bazaszachowa_flutter/types/PlayerRangeStats.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final String playerName;

  const Player({super.key, required this.playerName});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerRangeStats? _playerRangeStats;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPlayerRangeStats();
  }

  @override
  void didUpdateWidget(Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerName != widget.playerName) {
      _fetchPlayerRangeStats();
    }
  }

  Future<void> _fetchPlayerRangeStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await ApiConfig.searchMinMaxYearElo(widget.playerName);
      setState(() {
        _playerRangeStats = stats;
      });
    } catch (e) {
      setState(() => _playerRangeStats = null);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.playerName)),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.playerName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_playerRangeStats != null) ...[
              if (_playerRangeStats!.maxElo != null)
                _buildStatItem(
                  'Najwyższy osiągnięty ranking',
                  _playerRangeStats!.maxElo.toString(),
                ),
              _buildStatItem(
                'Gry z lat ${_playerRangeStats!.minYear} - ${_playerRangeStats!.maxYear}',
              ),
            ],
          ],
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
