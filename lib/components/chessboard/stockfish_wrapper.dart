import "dart:async";
import "dart:io";
import "dart:math";
import "package:chess/chess.dart";
import "package:stockfish_chess_engine/stockfish_chess_engine.dart";

final int cores = max(1, Platform.numberOfProcessors - 1);

class StockfishWrapper {
  StockfishWrapper({required this.callback}) {
    _initializeStockfish();
  }
  static final Stockfish _stockfish = Stockfish();
  Function(List<Map<String, dynamic>>) callback;
  final Completer<void> _readyCompleter = Completer<void>();
  final List<Map<String, dynamic>> _currentAnalysis = [];
  String? _current_fen;
  int _currentDepth = 1;
  Timer? _timer;

  Future<void> _initializeStockfish() async {
    _stockfish.stdout.listen((output) {
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
        _stockfish.stdin = "setoption name Threads value $cores";
        _stockfish.stdin = "setoption name MultiPV value 3";
        _stockfish.stdin = "setoption name Hash value 2048";
      }

      if (output.contains("bestmove") && _currentDepth++ < 15) {
        _analyzeDepth();
      }

      if (output.contains("info depth")) {
        final Map<String, dynamic>? analysis = _parseAnalysis(output);
        if (analysis != null) {
          _processAnalysis(analysis);
        }
      }
    });

    _stockfish.stderr.listen((error) {
      print("Stockfish error: $error");
    });
  }

  Map<String, dynamic>? _parseAnalysis(String output) {
    final multipvRegex = RegExp(r"multipv (\d+)");
    final RegExpMatch? multipvMatch = multipvRegex.firstMatch(output);
    final int multipv = multipvMatch != null
        ? int.parse(multipvMatch.group(1)!)
        : 1;

    final RegExpMatch? cpMatch = RegExp(r"score cp (-?\d+)").firstMatch(output);
    final RegExpMatch? mateMatch = RegExp(
      r"score mate (-?\d+)",
    ).firstMatch(output);

    final isMate = mateMatch != null;
    final num evaluation = isMate
        ? int.parse(mateMatch!.group(1)!)
        : (cpMatch != null ? int.parse(cpMatch.group(1)!) / 100 : 0.0);

    final RegExpMatch? moveMatch = RegExp(
      " pv ([a-h1-8 ]+)",
    ).firstMatch(output);
    if (moveMatch == null) {
      return null;
    }

    final String moveString = moveMatch.group(1)!;
    final List<String> moveList = moveString.split(" ");
    if (moveList.isEmpty) {
      return null;
    }

    final Chess chess = Chess.fromFEN(_current_fen!);
    final Color color = chess.turn;
    return {
      "multipv": multipv,
      "move": moveList.first,
      "evaluation": evaluation * (color == Color.WHITE ? 1 : -1),
      "isMate": isMate,
      "depth": _parseDepth(output),
      "continuation": moveList.skip(1).take(3).join(" "),
    };
  }

  void _processAnalysis(Map<String, dynamic> analysis) {
    final multipv = analysis["multipv"];
    if (multipv > 3) {
      return;
    }

    _currentAnalysis
      ..removeWhere((a) => a["multipv"] == multipv)
      ..add(analysis);
    final List<Map<String, dynamic>> sortedMoves = _sortMoves(_currentAnalysis);
    callback(sortedMoves.take(3).toList());
  }

  List<Map<String, dynamic>> _sortMoves(List<Map<String, dynamic>> moves) {
    final Chess chess = Chess.fromFEN(_current_fen!);
    final Color color = chess.turn;

    return List.from(moves)..sort((a, b) {
      if (a["isMate"] && !b["isMate"]) {
        return -1;
      }
      if (!a["isMate"] && b["isMate"]) {
        return 1;
      }

      if (a["isMate"] && b["isMate"]) {
        final aMate = a["evaluation"] as int;
        final bMate = b["evaluation"] as int;

        if (aMate > 0 && bMate > 0) {
          return aMate.compareTo(bMate);
        }
        if (aMate < 0 && bMate < 0) {
          return bMate.compareTo(aMate);
        }
        return aMate > 0 ? -1 : 1;
      }

      final aEval = a["evaluation"] as double;
      final bEval = b["evaluation"] as double;

      return color == Color.WHITE
          ? bEval.compareTo(aEval)
          : aEval.compareTo(bEval);
    });
  }

  int _parseDepth(String output) {
    final RegExpMatch? depthMatch = RegExp(r"depth (\d+)").firstMatch(output);
    return depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;
  }

  void analyze(String fen) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () async {
      _currentAnalysis.clear();
      _current_fen = fen;
      await _readyCompleter.future;
      _stockfish.stdin = "stop";
      _currentDepth = 1;
      _analyzeDepth();
    });
  }

  void _analyzeDepth() {
    _stockfish.stdin = "position fen $_current_fen";
    _stockfish.stdin = "go depth $_currentDepth";
  }

  void dispose() {
    _stockfish.stdin = "stop";
  }
}
