import "package:bazaszachowa_flutter/api_config.dart";
import "package:bazaszachowa_flutter/components/app/app_text_span.dart";
import "package:bazaszachowa_flutter/components/chessboard/game_controller.dart";
import "package:bazaszachowa_flutter/screens/player.dart";
import "package:bazaszachowa_flutter/types/game.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class GameView extends StatefulWidget {
  const GameView({
    required this.base,
    required this.games,
    required this.index,
    super.key,
  });
  final String base;
  final List<int> games;
  final int index;
  int get gameId => games[index];

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
    if (oldWidget.games != widget.games ||
        oldWidget.index != widget.index ||
        oldWidget.base != widget.base) {
      _fetchGame();
    }
  }

  Future<void> _fetchGame() async {
    try {
      final Game game = await ApiConfig.searchGame(
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

  void _goPlayer(String player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Player(playerName: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("${widget.base}/${widget.gameId}")),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.first_page),
                                onPressed: widget.index == 0
                                    ? null
                                    : () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              GameView(
                                                index: 0,
                                                base: widget.base,
                                                games: widget.games,
                                              ),
                                        ),
                                      ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.navigate_before),
                                onPressed: widget.index == 0
                                    ? null
                                    : () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              GameView(
                                                index: widget.index - 1,
                                                base: widget.base,
                                                games: widget.games,
                                              ),
                                        ),
                                      ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.navigate_next),
                                onPressed:
                                    widget.index == widget.games.length - 1
                                    ? null
                                    : () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              GameView(
                                                index: widget.index + 1,
                                                base: widget.base,
                                                games: widget.games,
                                              ),
                                        ),
                                      ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.last_page),
                                onPressed:
                                    widget.index == widget.games.length - 1
                                    ? null
                                    : () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              GameView(
                                                index: widget.games.length - 1,
                                                base: widget.base,
                                                games: widget.games,
                                              ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: RichText(
                            text: AppTextSpan(
                              context: context,
                              children: [
                                TextSpan(text: "${_game!.whiteElo ?? ''} "),
                                TextSpan(
                                  style: const TextStyle(color: Colors.blue),
                                  text: _game!.white,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _goPlayer(_game!.white),
                                ),
                                TextSpan(text: " ${_game!.result} "),
                                TextSpan(
                                  style: const TextStyle(color: Colors.blue),
                                  text: _game!.black,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _goPlayer(_game!.black),
                                ),
                                TextSpan(text: "${_game!.blackElo ?? ''} "),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GameController(game: _game!),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
