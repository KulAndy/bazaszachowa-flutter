import "package:bazaszachowa_flutter/api_config.dart";
import "package:bazaszachowa_flutter/components/chessboard/game_controller.dart";
import "package:bazaszachowa_flutter/types/game.dart";
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
                          child: Text(
                            // ignore: lines_longer_than_80_chars
                            "${_game!.whiteElo ?? ''} ${_game!.white} ${_game!.result} ${_game!.black} ${_game!.blackElo ?? ''}",
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
