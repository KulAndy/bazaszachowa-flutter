import 'dart:async';
import 'package:bazaszachowa_flutter/ApiConfig.dart';
import 'package:bazaszachowa_flutter/screens/Player.dart';
import 'package:flutter/material.dart';
import 'package:bazaszachowa_flutter/components/app/Menu.dart';

class Players extends StatefulWidget {
  const Players({super.key, required this.title});

  final String title;

  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

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
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await ApiConfig.searchPlayer(query);
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = []);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Wystąpił błąd')));
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _navigateToPlayerPage(String playerName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Player(playerName: playerName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Gracz',
                  hintText: 'Nazwisko, Imię',
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
                  itemBuilder: (context, index) {
                    final player = _searchResults[index];
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
      drawer: const Menu(),
    );
  }
}
