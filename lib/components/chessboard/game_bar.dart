import 'package:flutter/material.dart';

class GameBar extends StatefulWidget {
  final VoidCallback? goToFirst;
  final VoidCallback? goToPrev;
  final VoidCallback? goToNext;
  final VoidCallback? goToLast;
  final VoidCallback flip;
  final VoidCallback download;
  final VoidCallback zoomIn;
  final VoidCallback zoomOut;
  final int index;

  const GameBar({
    super.key,
    this.goToFirst,
    this.goToPrev,
    this.goToNext,
    this.goToLast,
    required this.flip,
    required this.download,
    required this.zoomIn,
    required this.zoomOut,
    required this.index,
  });

  @override
  State<GameBar> createState() => _GameBarState();
}

class _GameBarState extends State<GameBar> {
  bool _playing = false;

  void _play() async {
    setState(() {
      _playing = !_playing; // Toggle play state
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.flip), onPressed: widget.flip),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: widget.download,
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: widget.zoomIn,
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: widget.zoomOut,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
