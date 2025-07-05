import 'dart:async';
import 'package:bazaszachowa_flutter/components/player/game_table.dart';
import 'package:flutter/material.dart';
import 'package:bazaszachowa_flutter/api_config.dart';
import 'package:bazaszachowa_flutter/types/game.dart';
import 'package:bazaszachowa_flutter/components/app/menu.dart';

class Games extends StatefulWidget {
  const Games({super.key, required this.title});

  final String title;

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  final TextEditingController _searchControllerWhite = TextEditingController();
  final TextEditingController _searchControllerBlack = TextEditingController();
  final TextEditingController _tournamentController = TextEditingController();
  final TextEditingController _minYearController = TextEditingController();
  final TextEditingController _maxYearController = TextEditingController();

  bool _ignoreColors = false;
  int _minYear = 1475;
  int _maxYear = DateTime.now().year;
  int _minEcoValue = 1;
  int _maxEcoValue = 500;
  String _database = 'all';
  String _searchType = 'classic';

  final FocusNode _minYearFocusNode = FocusNode();
  final FocusNode _maxYearFocusNode = FocusNode();

  Timer? _debounceTimer;

  List<Map<String, dynamic>> get _ecoCodes {
    List<Map<String, dynamic>> ecoCodes = [];
    int index = 1;
    for (int i = 0; i < 5; i++) {
      String letter = String.fromCharCode('A'.codeUnitAt(0) + i);
      for (int j = 0; j < 100; j++) {
        String number = j.toString().padLeft(2, '0');
        ecoCodes.add({'label': '$letter$number', 'value': index});
        index++;
      }
    }
    return ecoCodes;
  }

  List<Game>? _games;

  @override
  void initState() {
    super.initState();
    _minYearController.text = _minYear.toString();
    _maxYearController.text = _maxYear.toString();
  }

  @override
  void dispose() {
    _searchControllerWhite.dispose();
    _searchControllerBlack.dispose();
    _tournamentController.dispose();
    _minYearController.dispose();
    _maxYearController.dispose();
    _minYearFocusNode.dispose();
    _maxYearFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateYear({bool isMinYear = true, required String value}) {
    final newYear = int.tryParse(value);
    if (newYear != null) {
      setState(() {
        if (isMinYear) {
          _minYear = newYear;
        } else {
          _maxYear = newYear;
        }
      });
    }
    if (isMinYear) {
      _minYearFocusNode.unfocus();
    } else {
      _maxYearFocusNode.unfocus();
    }
  }

  void _fetchGames() async {
    GameResponse response = await ApiConfig.searchGames(
      white: _searchControllerWhite.text,
      black: _searchControllerBlack.text,
      event: _tournamentController.text,
      ignore: _ignoreColors,
      minYear: _minYear,
      maxYear: _maxYear,
      minEco: _minEcoValue,
      maxEco: _maxEcoValue,
      base: _database,
      searching: _searchType,
    );

    setState(() {
      _games = response.games;
      _database = response.table;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 12),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchControllerWhite,
                  decoration: const InputDecoration(
                    labelText: 'Białe',
                    hintText: 'Nazwisko, Imię',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchControllerBlack,
                  decoration: const InputDecoration(
                    labelText: 'Czarne',
                    hintText: 'Nazwisko, Imię',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("Ignoruj kolory"),
                  value: _ignoreColors,
                  onChanged: (bool? value) {
                    setState(() {
                      _ignoreColors = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _minYearFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Min Rok',
                          hintText: 'Min Rok',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _minYearController,
                        onSubmitted: (value) =>
                            _updateYear(isMinYear: true, value: value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        focusNode: _maxYearFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Max Rok',
                          hintText: 'Max Rok',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _maxYearController,
                        onSubmitted: (value) =>
                            _updateYear(isMinYear: false, value: value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _tournamentController,
                  decoration: const InputDecoration(
                    labelText: 'Turniej',
                    hintText: 'Turniej',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _minEcoValue,
                        decoration: const InputDecoration(
                          labelText: 'Min ECO',
                          border: OutlineInputBorder(),
                        ),
                        items: _ecoCodes.map((item) {
                          return DropdownMenuItem<int>(
                            value: item['value'],
                            child: Text(item['label']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _minEcoValue = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _maxEcoValue,
                        decoration: const InputDecoration(
                          labelText: 'Max ECO',
                          border: OutlineInputBorder(),
                        ),
                        items: _ecoCodes.map((item) {
                          return DropdownMenuItem<int>(
                            value: item['value'],
                            child: Text(item['label']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _maxEcoValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Baza:"),
                    Radio<String>(
                      value: 'poland',
                      groupValue: _database,
                      onChanged: (String? value) {
                        setState(() {
                          _database = value!;
                        });
                      },
                    ),
                    const Text("Polska"),
                    Radio<String>(
                      value: 'all',
                      groupValue: _database,
                      onChanged: (String? value) {
                        setState(() {
                          _database = value!;
                        });
                      },
                    ),
                    const Text("Całość"),
                  ],
                ),
                Row(
                  children: [
                    const Text("Wyszukiwanie:"),
                    Radio<String>(
                      value: 'classic',
                      groupValue: _searchType,
                      onChanged: (String? value) {
                        setState(() {
                          _searchType = value!;
                        });
                      },
                    ),
                    const Text("Zwykłe"),
                    Radio<String>(
                      value: 'fulltext',
                      groupValue: _searchType,
                      onChanged: (String? value) {
                        setState(() {
                          _searchType = value!;
                        });
                      },
                    ),
                    const Text("Dokładne"),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchGames,
                  child: const Text('Szukaj'),
                ),
                const SizedBox(height: 20),
                if (_games != null) ...[
                  Text(
                    "Znaleziono ${_games!.length}",
                    textAlign: TextAlign.center,
                  ),
                  GameTable(games: _games!, base: 'all'),
                ],
              ],
            ),
          ),
        ),
      ),
      drawer: const Menu(),
    );
  }
}
