import "package:bazaszachowa_flutter/components/chessboard/half_move.dart";
import "package:bazaszachowa_flutter/types/variant_move.dart";
import "package:chessground/chessground.dart";
import "package:dartchess/dartchess.dart";
import "package:flutter/material.dart";

class Notation extends StatelessWidget {
  const Notation({
    required this.callback,
    super.key,
    this.moves = const [],
    this.result,
    this.currentIndex = 0,
    this.height = 400,
  });

  final List<VariantMove> moves;
  final Function(int, PlayerSide, Position) callback;
  final String? result;
  final int currentIndex;
  final double height;

  List<TextSpan> processMove(VariantMove move, bool isMain, int moveNo) {
    final List<TextSpan> moveComponents = [];

    if (move.turn == "b") {
      moveComponents.add(
        TextSpan(
          text: "$moveNo. ",
          style: TextStyle(
            fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    moveComponents.add(
      HalfMove(
        move: move.san,
        doMove: () {
          callback(
            move.index,
            move.turn == "w" ? PlayerSide.white : PlayerSide.black,
            Chess.fromSetup(Setup.parseFen(move.fen)),
          );
        },
        isCurrent: currentIndex == move.index,
        isMain: isMain,
      ),
    );

    for (final int variationIndex in move.variations) {
      moveComponents.add(
        const TextSpan(
          text: " (",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      );
      if (move.turn == "w") {
        moveComponents.add(TextSpan(text: "$moveNo... "));
      }
      moveComponents
        ..addAll(
          processMove(
            moves.firstWhere((item) => item.index == variationIndex),
            false,
            moveNo,
          ),
        )
        ..add(
          const TextSpan(
            text: ") ",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        );
    }

    if (move.next != null) {
      int nextMoveNo = moveNo;
      if (move.turn == "w") {
        nextMoveNo += 1;
      }
      moveComponents.addAll(processMove(moves[move.next!], isMain, nextMoveNo));
    }

    return moveComponents;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    List<TextSpan> moveComponents = [];
    if (moves.isNotEmpty && moves[0].next != null) {
      moveComponents = processMove(moves[moves[0].next!], true, 1);
    }

    if (result != null) {
      moveComponents.add(
        TextSpan(
          text: result,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ColoredBox(
      color: isDark ? Colors.black : Colors.white,
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: moveComponents,
        ),
      ),
    );
  }
}
