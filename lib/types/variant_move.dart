class VariantMove {
  List<int> variations;
  String from;
  String to;
  String turn;
  String fen;
  int index;
  String san;
  int? prev;
  String? promotion;
  int? next;

  VariantMove({
    required this.variations,
    required this.from,
    required this.to,
    required this.turn,
    required this.fen,
    required this.index,
    required this.san,
    this.prev,
    this.promotion,
    this.next,
  });
}
