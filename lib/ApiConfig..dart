import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  static const String baseUrl = 'https://api.bazaszachowa.smallhost.pl';
  static const String searchPlayersEndpoint = '/search_player';

  static String _getSearchPlayersUrl(String query) {
    return '$baseUrl$searchPlayersEndpoint/${Uri.encodeComponent(query)}';
  }

  static Future<List<String>> searchPlayer(String name) async {
    if (name.trim().length < 4) {
      return [];
    }

    try {
      final response = await http.get(Uri.parse(_getSearchPlayersUrl(name)));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<String>();
        }
        return [];
      } else {
        throw Exception('Failed to search players: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search players error: $e');
    }
  }
}
