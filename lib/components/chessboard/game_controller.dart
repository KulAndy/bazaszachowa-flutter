import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart' as dart_chess;
import 'package:chessground/chessground.dart';
import 'package:chess/chess.dart' as chess_lib;
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:bazaszachowa_flutter/types/variant_move.dart';
import 'package:bazaszachowa_flutter/components/chessboard/board.dart';
import 'package:bazaszachowa_flutter/components/chessboard/game_bar.dart';
import 'package:flutter/services.dart';

class GameController extends StatefulWidget {
  final Game game;
  final Function(String)? onMove;

  const GameController({super.key, required this.game, this.onMove});

  @override
  State<GameController> createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {
  dart_chess.Position _position = dart_chess.Chess.initial;
  dart_chess.Side _orientation = dart_chess.Side.white;
  PlayerSide _turn = PlayerSide.white;
  dart_chess.NormalMove? _promotionMove;
  final ScrollController _scrollController = ScrollController();
  List<VariantMove> _moves = [
    VariantMove(
      variations: [],
      from: "",
      to: "",
      turn: 'w',
      fen: dart_chess.Chess.initial.fen,
      index: 0,
      san: "",
    ),
  ];
  int _index = 0;
  double _size = 400;
  double _initSize = 400;

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
  }

  @override
  void didUpdateWidget(GameController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.game != widget.game) {
      _refresh();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChessGame() {
    _position = dart_chess.Chess.initial;
    _turn = PlayerSide.white;
  }

  void _refresh() async {
    try {
      List<VariantMove> newMovesList = [
        VariantMove(
          variations: [],
          from: "",
          to: "",
          turn: 'w',
          fen: dart_chess.Chess.initial.fen,
          index: 0,
          san: "",
        ),
      ];
      chess_lib.Chess chess = chess_lib.Chess();

      int counter = 1;

      for (var move in widget.game.moves) {
        if (!chess.move({
          'from': move.from,
          'to': move.to,
          'promotion': move.promotion,
        })) {
          break;
        }
        var history = chess.getHistory({'verbose': true});

        if (history.isEmpty) {
          break;
        }

        Map<String, dynamic> moveObj = history.last;
        VariantMove variantMove = VariantMove(
          variations: [],
          from: move.from,
          to: move.to,
          turn: counter % 2 == 0 ? 'w' : 'b',
          fen: chess.fen,
          index: counter,
          san: moveObj['san'],
          promotion: moveObj['promotion'],
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
      _moves = [
        VariantMove(
          variations: [],
          from: "",
          to: "",
          turn: 'w',
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
          int length = _moves.length;
          chess_lib.Chess chess = chess_lib.Chess.fromFEN(_position.fen);
          if (!chess.move({
            'from': move.from.name,
            'to': move.to.name,
            'promotion': move.promotion?.letter,
          })) {
            return;
          }
          var history = chess.getHistory({'verbose': true});
          Map<String, dynamic> moveObj = history.last;

          if (history.isEmpty) {
            return;
          }

          _position = _position.play(move);

          if (widget.onMove != null) {
            widget.onMove!(_position.fen);
          }

          if (_turn == PlayerSide.white) {
            _turn = PlayerSide.black;
          } else {
            _turn = PlayerSide.white;
          }

          _moves.add(
            VariantMove(
              variations: [],
              from: move.from.name,
              to: move.to.name,
              turn: _turn == PlayerSide.white ? 'w' : 'b',
              fen: _position.fen,
              index: length,
              san: moveObj['san'],
              prev: _index,
              promotion: move.promotion?.letter,
            ),
          );

          if (_moves[_index].next == null) {
            _moves[_index].next = length;
          } else {
            _moves[_index].variations.add(length);
          }

          _index = length;
        });
      }
    }
  }

  bool isPromotionPawnMove(dart_chess.NormalMove move) {
    return move.promotion == null &&
        _position.board.roleAt(move.from) == dart_chess.Role.pawn &&
        ((move.to.rank == dart_chess.Rank.first &&
                _position.turn == dart_chess.Side.black) ||
            (move.to.rank == dart_chess.Rank.eighth &&
                _position.turn == dart_chess.Side.white));
  }

  void _goToFirst() {
    if (_index > 0) {
      setState(() {
        _index = 0;
        _turn = PlayerSide.white;
        _position = dart_chess.Chess.initial;
      });
      if (widget.onMove != null) {
        widget.onMove!(dart_chess.Chess.initial.fen);
      }
    }
  }

  void _goToPrev() {
    if (_index > 0 && _moves.isNotEmpty && _moves[_index].prev != null) {
      var prevIndex = _moves[_index].prev!;
      setState(() {
        _index = prevIndex;
        _turn = _moves[prevIndex].turn == 'w'
            ? PlayerSide.white
            : PlayerSide.black;
        _position = dart_chess.Chess.fromSetup(
          dart_chess.Setup.parseFen(_moves[prevIndex].fen),
        );
      });
      if (widget.onMove != null) {
        widget.onMove!(_moves[prevIndex].fen);
      }
    }
  }

  void _goToNext() {
    if (_index < _moves.length - 1 &&
        _moves.isNotEmpty &&
        _moves[_index].next != null) {
      var nextIndex = _moves[_index].next!;
      setState(() {
        _index = nextIndex;
        _turn = _moves[nextIndex].turn == 'w'
            ? PlayerSide.white
            : PlayerSide.black;
        _position = dart_chess.Chess.fromSetup(
          dart_chess.Setup.parseFen(_moves[nextIndex].fen),
        );
      });
      if (widget.onMove != null) {
        widget.onMove!(_moves[nextIndex].fen);
      }
    }
  }

  void _goToLast() {
    if (_index < _moves.length - 1 && _moves.isNotEmpty) {
      int lastIndex = _index;
      while (_moves[lastIndex].next != null) {
        lastIndex = _moves[lastIndex].next!;
      }
      setState(() {
        _index = lastIndex;
        _turn = _moves[lastIndex].turn == 'w'
            ? PlayerSide.white
            : PlayerSide.black;
        _position = dart_chess.Chess.fromSetup(
          dart_chess.Setup.parseFen(_moves[lastIndex].fen),
        );
      });
      if (widget.onMove != null) {
        widget.onMove!(_moves[lastIndex].fen);
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

  String _generatePGN() {
    StringBuffer pgn = StringBuffer();

    pgn.writeln('[Event "${widget.game.event}"]');
    pgn.writeln('[Site "${widget.game.site}"]');
    pgn.writeln(
      '[Date "${widget.game.year}-${widget.game.month?.toString().padLeft(2, '0')}-${widget.game.day?.toString().padLeft(2, '0')}"]',
    );
    pgn.writeln('[Round "${widget.game.round}"]');
    pgn.writeln('[White "${widget.game.white}"]');
    pgn.writeln('[Black "${widget.game.black}"]');
    pgn.writeln('[Result "${widget.game.result}"]');
    pgn.writeln('[WhiteElo "${widget.game.whiteElo}"]');
    pgn.writeln('[BlackElo "${widget.game.blackElo}"]');
    pgn.writeln('[ECO "${widget.game.eco}"]');
    pgn.writeln();

    int counter = 1;
    VariantMove move = _moves[0];

    while (true) {
      if (move.next == null) {
        break;
      }
      if (++counter % 2 == 0) {
        pgn.write("${(counter / 2).toInt()}. ");
      }
      move = _moves.firstWhere((item) => item.index == move.next);
      pgn.write("${move.san} ");
    }

    pgn.write(widget.game.result ?? '*');

    return pgn.toString();
  }

  Future<void> _copyPGNToClipboard() async {
    String pgn = _generatePGN();

    await Clipboard.setData(ClipboardData(text: pgn));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PGN copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    List<VariantMove> mainMoves = [];
    VariantMove move = _moves[0];

    while (true) {
      if (move.next == null) {
        break;
      }
      move = _moves.firstWhere((item) => item.index == move.next);
      mainMoves.add(move);
    }

    List<InlineSpan> notationSpans = [];

    for (var i = 0; i < mainMoves.length; i++) {
      if (i % 2 == 0) {
        notationSpans.add(
          TextSpan(
            text: "${(i / 2 + 1).toInt()}. ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }

      notationSpans.add(
        WidgetSpan(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _index = mainMoves[i].index;
                _turn = mainMoves[i].turn == 'w'
                    ? PlayerSide.white
                    : PlayerSide.black;

                _position = dart_chess.Chess.fromSetup(
                  dart_chess.Setup.parseFen(mainMoves[i].fen),
                );
              });
            },
            child: Container(
              color: mainMoves[i].index == _index && _index > 0
                  ? Colors.orange
                  : Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                mainMoves[i].san,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );

      notationSpans.add(TextSpan(text: " "));
    }

    notationSpans.add(
      TextSpan(
        text: "\n${widget.game.result ?? "*"}",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );

    return Column(
      children: [
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
        ),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.all(10.0),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: notationSpans,
            ),
          ),
        ),
      ],
    );
  }
}
