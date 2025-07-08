import "dart:async";

import "package:bazaszachowa_flutter/api_config.dart";
import "package:bazaszachowa_flutter/components/app/menu.dart";
import "package:bazaszachowa_flutter/components/app/search_with_hints.dart";
import "package:bazaszachowa_flutter/screens/preparation.dart";
import "package:flutter/material.dart";

class SearchPreparation extends StatefulWidget {
  const SearchPreparation({super.key});

  String get title => "Przygotowanie";

  @override
  State<SearchPreparation> createState() => _SearchPreparationState();
}

class _SearchPreparationState extends State<SearchPreparation> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = <String>[];
  Timer? _debounceTimer;
  String _color = "white";
  String _playerName = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
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
    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
      context,
    );
    final String trimmedQuery = query.trim();
    setState(() {
      _playerName = trimmedQuery;
    });
    if (trimmedQuery.isEmpty) {
      setState(() => _searchResults = <String>[]);
      return;
    }

    try {
      final List<String> results = await ApiConfig.searchPlayer(trimmedQuery);
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = <String>[]);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Error on search: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              SearchWithHints(
                hintText: "Nazwisko, Imię",
                options: _searchResults,
                label: "Gracz",
                onSelected: _searchPlayers,
                controller: _searchController,
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  const Text("Kolor:"),
                  Radio<String>(
                    value: "white",
                    groupValue: _color,
                    onChanged: (String? value) {
                      setState(() {
                        _color = value!;
                      });
                    },
                  ),
                  const Text("Białe"),
                  Radio<String>(
                    value: "black",
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Preparation(playerName: _playerName, color: _color),
                  ),
                ),
                child: const Text("Szukaj"),
              ),
            ],
          ),
        ),
      ),
    ),
    drawer: const Menu(),
  );
}
