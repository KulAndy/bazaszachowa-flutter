import "package:bazaszachowa_flutter/components/chessboard/game_controller.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class GameBar extends StatefulWidget {
  const GameBar({
    required this.flip,
    required this.copy,
    required this.zoomIn,
    required this.zoomOut,
    required this.index,
    required this.underBoard,
    required this.toggleUnderBoard,
    super.key,
    this.goToFirst,
    this.goToPrev,
    this.goToNext,
    this.goToLast,
  });
  final VoidCallback? goToFirst;
  final VoidCallback? goToPrev;
  final VoidCallback? goToNext;
  final VoidCallback? goToLast;
  final VoidCallback flip;
  final VoidCallback copy;
  final VoidCallback zoomIn;
  final VoidCallback zoomOut;
  final int index;
  final UnderBoard underBoard;
  final VoidCallback toggleUnderBoard;

  @override
  State<GameBar> createState() => _GameBarState();
}

class _GameBarState extends State<GameBar> {
  bool _playing = false;

  Future<void> _play() async {
    setState(() {
      _playing = !_playing;
    });

    while (_playing && widget.goToNext != null) {
      widget.goToNext!();
      await Future.delayed(const Duration(milliseconds: 250));
    }

    setState(() {
      _playing = false;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: widget.goToFirst,
            ),
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: widget.goToPrev,
            ),
            IconButton(
              icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
              onPressed: _play,
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: widget.goToNext,
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: widget.goToLast,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(icon: const Icon(Icons.flip), onPressed: widget.flip),
            IconButton(icon: const Icon(Icons.copy), onPressed: widget.copy),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: widget.zoomIn,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: widget.zoomOut,
            ),
            IconButton(
              icon: widget.underBoard == UnderBoard.notation
                  ? const FaIcon(FontAwesomeIcons.fish)
                  : const FaIcon(FontAwesomeIcons.fileLines),
              onPressed: widget.toggleUnderBoard,
            ),
          ],
        ),
      ),
    ],
  );
}
