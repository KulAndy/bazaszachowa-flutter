import "package:bazaszachowa_flutter/components/chessboard/stockfish_wrapper.dart";
import "package:flutter/material.dart";

class StockfishAnalysisWidget extends StatefulWidget {
  const StockfishAnalysisWidget({required this.fen, super.key});
  final String fen;

  @override
  State<StockfishAnalysisWidget> createState() =>
      _StockfishAnalysisWidgetState();
}

class _StockfishAnalysisWidgetState extends State<StockfishAnalysisWidget> {
  static late StockfishWrapper _stockfish = StockfishWrapper(callback: (p0) {});
  List<Map<String, dynamic>> _analysis = [];

  @override
  void initState() {
    super.initState();
    _stockfish.callback = (analysis) {
      if (mounted) {
        setState(() {
          _analysis = analysis;
        });
      }
    };

    _startAnalysis();
  }

  @override
  void didUpdateWidget(StockfishAnalysisWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fen != widget.fen) {
      _startAnalysis();
    }
  }

  void _startAnalysis() {
    setState(() {
      _analysis = [];
    });
    _stockfish.analyze(widget.fen);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_analysis.isEmpty)
        const Text("No analysis available")
      else
        Column(
          children: [
            for (var move in _analysis.take(3)) _buildMoveEvaluation(move),
          ],
        ),
    ],
  );

  Widget _buildMoveEvaluation(Map<String, dynamic> move) {
    final evaluation = move["evaluation"];
    final isMate = evaluation is int;
    final Color? color = evaluation > 0
        ? Colors.green[800]
        : evaluation < 0
        ? Colors.red[800]
        : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              move["move"],
              style: const TextStyle(fontFamily: "Chess", fontSize: 16),
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color?.withAlpha(53),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isMate
                  ? "Mate ${evaluation.abs()}"
                  : '${evaluation > 0 ? '+' : ''}${evaluation.toStringAsFixed(2)}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              move["continuation"],
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
