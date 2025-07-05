import "package:chessground/chessground.dart";
import "package:dartchess/dartchess.dart" as dart_chess;
import "package:flutter/material.dart";

class BoardWidget extends StatefulWidget {
  const BoardWidget({
    required this.position,
    required this.orientation,
    required this.turn,
    required this.promotionMove,
    required this.onMove,
    required this.onPromotionSelection,
    required this.size,
    super.key,
  });
  final dart_chess.Position position;
  final dart_chess.Side orientation;
  final PlayerSide turn;
  final dart_chess.NormalMove? promotionMove;
  final Function(dart_chess.NormalMove, {bool? isDrop}) onMove;
  final Function(dart_chess.Role?) onPromotionSelection;
  final double size;

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) => Chessboard(
    size: widget.size,
    fen: widget.position.fen,
    orientation: widget.orientation,
    game: GameData(
      playerSide: widget.turn,
      validMoves: dart_chess.makeLegalMoves(widget.position),
      sideToMove: widget.position.turn,
      isCheck: widget.position.isCheck,
      promotionMove: widget.promotionMove,
      onMove: widget.onMove,
      onPromotionSelection: widget.onPromotionSelection,
    ),
  );
}
