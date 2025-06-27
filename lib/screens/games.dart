import 'dart:async';
import 'package:flutter/material.dart';
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
  String _minEco = 'A00';
  String _maxEco = 'E99';
  String _database = 'Polska';
  String _searchType = 'zwykłe';

  final FocusNode _minYearFocusNode = FocusNode();
  final FocusNode _maxYearFocusNode = FocusNode();

  Timer? _debounceTimer;

  List<String> get _ecoCodes {
    List<String> ecoCodes = [];
    for (int i = 0; i < 5; i++) {
      String letter = String.fromCharCode('A'.codeUnitAt(0) + i);
      for (int j = 0; j < 100; j++) {
        String number = j.toString().padLeft(2, '0');
        ecoCodes.add('$letter$number');
      }
    }
    return ecoCodes;
  }

  @override
  void initState() {
    super.initState();
    _minYearController.text = _minYear.toString();
    _maxYearController.text = _maxYear.toString();
    _searchControllerWhite.addListener(_onSearchChanged);
    _searchControllerBlack.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchControllerWhite.removeListener(_onSearchChanged);
    _searchControllerBlack.removeListener(_onSearchChanged);
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

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Handle search logic here
    });
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
    // Unfocus the text field after updating the year
    if (isMinYear) {
      _minYearFocusNode.unfocus();
    } else {
      _maxYearFocusNode.unfocus();
    }
  }

  void _printQueryParameters() {
    print('Query Parameters:');
    print('White: ${_searchControllerWhite.text}');
    print('Black: ${_searchControllerBlack.text}');
    print('Tournament: ${_tournamentController.text}');
    print('Ignore Colors: $_ignoreColors');
    print('Min Year: $_minYear');
    print('Max Year: $_maxYear');
    print('Min ECO: $_minEco');
    print('Max ECO: $_maxEco');
    print('Database: $_database');
    print('Search Type: $_searchType');
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
                      child: DropdownButtonFormField<String>(
                        value: _minEco,
                        decoration: const InputDecoration(
                          labelText: 'Min ECO',
                          border: OutlineInputBorder(),
                        ),
                        items: _ecoCodes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _minEco = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _maxEco,
                        decoration: const InputDecoration(
                          labelText: 'Max ECO',
                          border: OutlineInputBorder(),
                        ),
                        items: _ecoCodes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _maxEco = newValue!;
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
                      value: 'Polska',
                      groupValue: _database,
                      onChanged: (String? value) {
                        setState(() {
                          _database = value!;
                        });
                      },
                    ),
                    const Text("Polska"),
                    Radio<String>(
                      value: 'całość',
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
                      value: 'zwykłe',
                      groupValue: _searchType,
                      onChanged: (String? value) {
                        setState(() {
                          _searchType = value!;
                        });
                      },
                    ),
                    const Text("Zwykłe"),
                    Radio<String>(
                      value: 'dokładne',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05445E),
                    foregroundColor: Colors.white,
                  ),

                  onPressed: _printQueryParameters,
                  child: const Text('Szukaj'),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const Menu(),
    );
  }
}
