import "dart:async";

import "package:bazaszachowa_flutter/api_config.dart";
import "package:bazaszachowa_flutter/components/app/menu.dart";
import "package:bazaszachowa_flutter/screens/player.dart";
import "package:flutter/material.dart";

class Players extends StatefulWidget {
  const Players({super.key});

  String get title => "Zawodnicy";

  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = <String>[];
  bool _isSearching = false;
  Timer? _debounceTimer;

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
    if (trimmedQuery.isEmpty) {
      setState(() => _searchResults = <String>[]);
      return;
    }

    setState(() => _isSearching = true);

    try {
      final List<String> results = await ApiConfig.searchPlayer(trimmedQuery);
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = <String>[]);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Error on search: $e")),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _navigateToPlayerPage(String playerName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Player(playerName: playerName),
      ),
    );
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
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Gracz",
                  hintText: "Nazwisko, Imię",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _searchPlayers(_searchController.text),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isSearching)
                const CircularProgressIndicator()
              else if (_searchResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String player = _searchResults[index];
                    return Card(
                      child: ListTile(
                        title: Text(player),
                        onTap: () => _navigateToPlayerPage(player),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    ),
    drawer: const Menu(),
  );
}
