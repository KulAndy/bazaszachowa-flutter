import "dart:math";

import "package:bazaszachowa_flutter/components/chessboard/board.dart";
import "package:bazaszachowa_flutter/components/chessboard/game_bar.dart";
import "package:bazaszachowa_flutter/components/chessboard/notation.dart";
import "package:bazaszachowa_flutter/components/chessboard/stockfish_analysis_widget.dart";
import "package:bazaszachowa_flutter/types/game.dart";
import "package:bazaszachowa_flutter/types/move.dart";
import "package:bazaszachowa_flutter/types/variant_move.dart";
import "package:chess/chess.dart" as chess_lib;
import "package:chessground/chessground.dart";
import "package:dartchess/dartchess.dart" as dart_chess;
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class GameController extends StatefulWidget {
  const GameController({required this.game, super.key, this.onMove});
  final Game game;
  final Function(String)? onMove;

  @override
  State<GameController> createState() => GameControllerState();
}

enum UnderBoard { notation, stockfish }

class GameControllerState extends State<GameController> {
  dart_chess.Position _position = dart_chess.Chess.initial;
  dart_chess.Side _orientation = dart_chess.Side.white;
  PlayerSide _turn = PlayerSide.white;
  dart_chess.NormalMove? _promotionMove;
  List<VariantMove> _moves = <VariantMove>[
    VariantMove(
      variations: <int>[],
      from: "",
      to: "",
      turn: "w",
      fen: dart_chess.Chess.initial.fen,
      index: 0,
      san: "",
    ),
  ];
  int _index = 0;
  double _size = 400;
  double _initSize = 400;
  UnderBoard _underBoard = UnderBoard.notation;

  @override
  void initState() {
    super.initState();
    _initializeChessGame();
    _refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    _size = _initSize = min(screenHeight, screenWidth);
    if (_size > 768) {
      _size /= 2;
    }
  }

  @override
  void didUpdateWidget(GameController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.game != widget.game) {
      _refresh();
    }
  }

  void makeMove({required String from, required String to, String? promotion}) {
    String uci = "$from$to";
    if (promotion != null) {
      uci += promotion;
    }
    final dart_chess.NormalMove move = dart_chess.NormalMove.fromUci(uci);
    _onMove(move);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeChessGame() {
    _position = dart_chess.Chess.initial;
    _turn = PlayerSide.white;
  }

  Future<void> _refresh() async {
    try {
      final List<VariantMove> newMovesList = <VariantMove>[
        VariantMove(
          variations: <int>[],
          from: "",
          to: "",
          turn: "w",
          fen: dart_chess.Chess.initial.fen,
          index: 0,
          san: "",
        ),
      ];
      final chess_lib.Chess chess = chess_lib.Chess();

      int counter = 1;

      for (final Move move in widget.game.moves) {
        if (!chess.move(<String, String?>{
          "from": move.from,
          "to": move.to,
          "promotion": move.promotion,
        })) {
          break;
        }
        final List history = chess.getHistory(<dynamic, dynamic>{
          "verbose": true,
        });

        if (history.isEmpty) {
          break;
        }

        final Map<String, dynamic> moveObj = history.last;
        final VariantMove variantMove = VariantMove(
          variations: <int>[],
          from: move.from,
          to: move.to,
          turn: counter.isEven ? "w" : "b",
          fen: chess.fen,
          index: counter,
          san: moveObj["san"],
          promotion: moveObj["promotion"],
          prev: counter - 1,
        );

        newMovesList[counter - 1].next = counter;

        counter++;
        newMovesList.add(variantMove);
      }

      setState(() {
        _moves = newMovesList;
        _initializeChessGame();
      });
    } catch (e) {
      _moves = <VariantMove>[
        VariantMove(
          variations: <int>[],
          from: "",
          to: "",
          turn: "w",
          fen: dart_chess.Chess.initial.fen,
          index: 0,
          san: "",
        ),
      ];
    }
  }

  void _onPromotionSelection(dart_chess.Role? role) {
    if (role != null && _promotionMove != null) {
      setState(() {
        _position = _position.play(_promotionMove!.withPromotion(role));
        _promotionMove = null;
      });
    }
  }

  void _onMove(dart_chess.NormalMove move, {bool? isDrop}) {
    if (_position.isLegal(move)) {
      if (isPromotionPawnMove(move)) {
        setState(() {
          _promotionMove = move;
        });
      } else {
        setState(() {
          final int length = _moves.length;
          final chess_lib.Chess chess = chess_lib.Chess.fromFEN(_position.fen);

          if (!chess.move(<String, String?>{
            "from": move.from.name,
            "to": move.to.name,
            "promotion": move.promotion?.letter,
          })) {
            return;
          }

          final List history = chess.getHistory(<dynamic, dynamic>{
            "verbose": true,
          });

          final Map<String, dynamic> moveObj = history.last;
          if (history.isEmpty) {
            return;
          }

          _position = _position.play(move);
          if (widget.onMove != null) {
            widget.onMove?.call(_position.fen);
          }

          if (_turn == PlayerSide.white) {
            _turn = PlayerSide.black;
          } else {
            _turn = PlayerSide.white;
          }

          if (_moves.firstWhere((item) => item.index == _index).next != null &&
              _moves.firstWhere((item) => item.index == _index).next! <
                  _moves.length &&
              _moves[_moves.firstWhere((item) => item.index == _index).next!]
                      .san ==
                  moveObj["san"]) {
            _index = _moves.firstWhere((item) => item.index == _index).next!;
            return;
          }

          for (final int variantIndex
              in _moves.firstWhere((item) => item.index == _index).variations) {
            if (variantIndex < _moves.length &&
                _moves.firstWhere((item) => item.index == variantIndex).san ==
                    moveObj["san"]) {
              _index = variantIndex;
              return;
            }
          }

          _moves.add(
            VariantMove(
              variations: <int>[],
              from: move.from.name,
              to: move.to.name,
              turn: _turn == PlayerSide.white ? "w" : "b",
              fen: _position.fen,
              index: length,
              san: moveObj["san"],
              prev: _index,
              promotion: move.promotion?.letter,
            ),
          );

          if (_moves.firstWhere((item) => item.index == _index).next == null) {
            _moves.firstWhere((item) => item.index == _index).next = length;
          } else {
            _moves
                .firstWhere(
                  (item) =>
                      item.index ==
                      _moves.firstWhere((item) => item.index == _index).next,
                )
                .variations
                .add(length);
          }

          setState(() {
            _index = length;
            _moves = [..._moves];
          });
        });
      }
    }
  }

  bool isPromotionPawnMove(dart_chess.NormalMove move) =>
      move.promotion == null &&
      _position.board.roleAt(move.from) == dart_chess.Role.pawn &&
      ((move.to.rank == dart_chess.Rank.first &&
              _position.turn == dart_chess.Side.black) ||
          (move.to.rank == dart_chess.Rank.eighth &&
              _position.turn == dart_chess.Side.white));

  void _goToFirst() {
    if (_index > 0) {
      setState(() {
        _index = 0;
        _turn = PlayerSide.white;
        _position = dart_chess.Chess.initial;
      });
      if (widget.onMove != null) {
        widget.onMove?.call(dart_chess.Chess.initial.fen);
      }
    }
  }

  void _goToPrev() {
    if (_index > 0 &&
        _moves.isNotEmpty &&
        _moves.firstWhere((item) => item.index == _index).prev != null) {
      final int prevIndex = _moves
          .firstWhere((item) => item.index == _index)
          .prev!;
      setState(() {
        _index = prevIndex;
        _turn = _moves.firstWhere((item) => item.index == prevIndex).turn == "w"
            ? PlayerSide.white
            : PlayerSide.black;
        _position = dart_chess.Chess.fromSetup(
          dart_chess.Setup.parseFen(
            _moves.firstWhere((item) => item.index == prevIndex).fen,
          ),
        );
      });
      if (widget.onMove != null) {
        widget.onMove?.call(
          _moves.firstWhere((item) => item.index == prevIndex).fen,
        );
      }
    }
  }

  void _goToNext() {
    if (_index < _moves.length - 1 &&
        _moves.isNotEmpty &&
        _moves.firstWhere((item) => item.index == _index).next != null) {
      final int nextIndex = _moves
          .firstWhere((item) => item.index == _index)
          .next!;
      setState(() {
        _index = nextIndex;
        _turn = _moves.firstWhere((item) => item.index == nextIndex).turn == "w"
            ? PlayerSide.white
            : PlayerSide.black;
        _position = dart_chess.Chess.fromSetup(
          dart_chess.Setup.parseFen(
            _moves.firstWhere((item) => item.index == nextIndex).fen,
          ),
        );
      });
      if (widget.onMove != null) {
        widget.onMove?.call(
          _moves.firstWhere((item) => item.index == nextIndex).fen,
        );
      }
    }
  }

  void _goToLast() {
    if (_index < _moves.length - 1 && _moves.isNotEmpty) {
      int lastIndex = _index;
      while (_moves.firstWhere((item) => item.index == lastIndex).next !=
          null) {
        lastIndex = _moves.firstWhere((item) => item.index == lastIndex).next!;
      }
      setState(() {
        _index = lastIndex;
        _turn = _moves.firstWhere((item) => item.index == lastIndex).turn == "w"
            ? PlayerSide.white
            : PlayerSide.black;
        _position = dart_chess.Chess.fromSetup(
          dart_chess.Setup.parseFen(
            _moves.firstWhere((item) => item.index == lastIndex).fen,
          ),
        );
      });
      if (widget.onMove != null) {
        widget.onMove?.call(
          _moves.firstWhere((item) => item.index == lastIndex).fen,
        );
      }
    }
  }

  void _flip() {
    setState(() {
      _orientation = _orientation == dart_chess.Side.white
          ? dart_chess.Side.black
          : dart_chess.Side.white;
    });
  }

  void _zoomIn() {
    setState(() {
      _size = min(_size + 10, _initSize);
    });
  }

  void _zoomOut() {
    setState(() {
      _size = max(_size - 10, 100);
    });
  }

  List<String> _processMove(VariantMove move, bool isMain, int moveNo) {
    final List<String> moveComponents = [];

    if (move.turn == "b") {
      moveComponents.add("$moveNo. ");
    }

    moveComponents.add("${move.san} ");

    for (final int variationIndex in move.variations) {
      moveComponents.add(" (");
      if (move.turn == "w") {
        moveComponents.add("$moveNo... ");
      }
      moveComponents
        ..addAll(
          _processMove(
            _moves.firstWhere((item) => item.index == variationIndex),
            false,
            moveNo,
          ),
        )
        ..add(") ");
    }

    if (move.next != null) {
      int nextMoveNo = moveNo;
      if (move.turn == "w") {
        nextMoveNo += 1;
      }
      moveComponents.addAll(
        _processMove(_moves[move.next!], isMain, nextMoveNo),
      );
    }

    return moveComponents;
  }

  String _generatePGN() {
    final StringBuffer pgn = StringBuffer()
      ..writeln('[Event "${widget.game.event}"]')
      ..writeln('[Site "${widget.game.site}"]')
      ..writeln(
        // ignore: lines_longer_than_80_chars
        '[Date "${widget.game.year}-${widget.game.month?.toString().padLeft(2, '0')}-${widget.game.day?.toString().padLeft(2, '0')}"]',
      )
      ..writeln('[Round "${widget.game.round}"]')
      ..writeln('[White "${widget.game.white}"]')
      ..writeln('[Black "${widget.game.black}"]')
      ..writeln('[Result "${widget.game.result}"]')
      ..writeln('[WhiteElo "${widget.game.whiteElo}"]')
      ..writeln('[BlackElo "${widget.game.blackElo}"]')
      ..writeln('[ECO "${widget.game.eco}"]')
      ..writeln()
      ..writeAll(_processMove(_moves[0], true, 0))
      ..write(widget.game.result ?? "*");

    return pgn.toString();
  }

  Future<void> _copyPGNToClipboard() async {
    final String pgn = _generatePGN();

    await Clipboard.setData(ClipboardData(text: pgn));

    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(const SnackBar(content: Text("PGN copied to clipboard")));
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      BoardWidget(
        position: _position,
        orientation: _orientation,
        turn: _turn,
        promotionMove: _promotionMove,
        onMove: _onMove,
        onPromotionSelection: _onPromotionSelection,
        size: _size,
      ),
      GameBar(
        goToFirst: _index <= 0 ? null : _goToFirst,
        goToPrev: _index <= 0 ? null : _goToPrev,
        goToNext: _index >= _moves.length - 1 ? null : _goToNext,
        goToLast: _index >= _moves.length - 1 ? null : _goToLast,
        flip: _flip,
        copy: _copyPGNToClipboard,
        zoomIn: _zoomIn,
        zoomOut: _zoomOut,
        index: _index,
        underBoard: _underBoard,
        toggleUnderBoard: () {
          if (_underBoard == UnderBoard.notation) {
            setState(() {
              _underBoard = UnderBoard.stockfish;
            });
          } else {
            setState(() {
              _underBoard = UnderBoard.notation;
            });
          }
        },
      ),
      if (_underBoard == UnderBoard.notation)
        Notation(
          callback: (newIndex, turn, position) => setState(() {
            _index = newIndex;
            _turn = turn;
            _position = position;
          }),
          moves: _moves,
          result: widget.game.result,
          currentIndex: _index,
        )
      else
        StockfishAnalysisWidget(fen: _position.fen),
    ],
  );
}
