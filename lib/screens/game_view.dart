import 'package:flutter/material.dart';
import 'package:bazaszachowa_flutter/api_config.dart';
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:bazaszachowa_flutter/components/chessboard/game_controller.dart';

class GameView extends StatefulWidget {
  final int gameId;
  final String base;

  const GameView({super.key, required this.gameId, required this.base});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  Game? _game;

  @override
  void initState() {
    super.initState();
    _fetchGame();
  }

  @override
  void didUpdateWidget(GameView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameId != widget.gameId || oldWidget.base != widget.base) {
      _fetchGame();
    }
  }

  Future<void> _fetchGame() async {
    try {
      final game = await ApiConfig.searchGame(
        gameId: widget.gameId,
        base: widget.base,
      );

      setState(() {
        _game = game;
      });
    } catch (e) {
      setState(() => _game = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("${widget.base}/${widget.gameId}")),
      body: SafeArea(
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "${_game!.whiteElo ?? ''} ${_game!.white} ${_game!.result} ${_game!.black} ${_game!.blackElo ?? ''}",
                        ),
                      ),
                      const SizedBox(height: 20),
                      GameController(game: _game),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
