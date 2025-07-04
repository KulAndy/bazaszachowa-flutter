import 'dart:async';
import 'package:bazaszachowa_flutter/api_config.dart';
import 'package:bazaszachowa_flutter/components/app/search_with_hints.dart';
import 'package:bazaszachowa_flutter/screens/preparation.dart';
import 'package:flutter/material.dart';
import 'package:bazaszachowa_flutter/components/app/menu.dart';

class SearchPreparation extends StatefulWidget {
  const SearchPreparation({super.key, required this.title});

  final String title;

  @override
  State<SearchPreparation> createState() => _SearchPreparationState();
}

class _SearchPreparationState extends State<SearchPreparation> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  Timer? _debounceTimer;
  String _color = 'white';
  String _playerName = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchPlayers(_searchController.text);
    });
  }

  Future<void> _searchPlayers(String query) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String trimmedQuery = query.trim();
    setState(() {
      _playerName = trimmedQuery;
    });
    if (trimmedQuery.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    try {
      final results = await ApiConfig.searchPlayer(trimmedQuery);
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = []);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error on search: $e')),
      );
    }
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
                SearchWithHints(
                  hintText: 'Nazwisko, Imię',
                  options: _searchResults,
                  label: "Gracz",
                  onSelected: (String label) => _searchPlayers(label),
                  controller: _searchController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Kolor:"),
                    Radio<String>(
                      value: 'white',
                      groupValue: _color,
                      onChanged: (String? value) {
                        setState(() {
                          _color = value!;
                        });
                      },
                    ),
                    const Text("Białe"),
                    Radio<String>(
                      value: 'black',
                      groupValue: _color,
                      onChanged: (String? value) {
                        setState(() {
                          _color = value!;
                        });
                      },
                    ),
                    const Text("Czarne"),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05445E),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Preparation(
                        title:
                            '${_playerName} ${_color == "white" ? "białe" : "czarne"}',

                        playerName: _playerName,
                        color: _color,
                      ),
                    ),
                  ),
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
