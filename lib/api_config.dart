import "dart:convert";
import "package:bazaszachowa_flutter/types/fide_player.dart";
import "package:bazaszachowa_flutter/types/game.dart";
import "package:bazaszachowa_flutter/types/opening_stats.dart";
import "package:bazaszachowa_flutter/types/player_range_stats.dart";
import "package:bazaszachowa_flutter/types/poland_player.dart";
import "package:http/http.dart" as http;

// ignore: avoid_classes_with_only_static_members
class ApiConfig {
  static const String baseUrl = "https://api.bazaszachowa.smallhost.pl";
  static const String searchPlayersEndpoint = "/search_player";
  static const String minMaxYearElo = "/min_max_year_elo";
  static const String polandPlayer = "/cr_data";
  static const String fidePlayer = "/fide_data";
  static const String openingStats = "/player_opening_stats";
  static const String games = "/search_game";
  static const String filterGames = "/search_player_opening_game";
  static const String game = "/game";

  static String _getSearchPlayersUrl(String query) =>
      "$baseUrl$searchPlayersEndpoint/${Uri.encodeComponent(query)}";

  static String _getSearchMinMaxYearEloUrl(String query) =>
      "$baseUrl$minMaxYearElo/${Uri.encodeComponent(query)}";

  static String _getSearchPolandPlayersUrl(String query) =>
      "$baseUrl$polandPlayer/${Uri.encodeComponent(query)}";

  static String _getSearchFidePlayersUrl(String query) =>
      "$baseUrl$fidePlayer/${Uri.encodeComponent(query)}";

  static String _getOpeningStatsUrl(String query) =>
      "$baseUrl$openingStats/${Uri.encodeComponent(query)}";

  static Uri _getGamesUrl({
    String white = "",
    String black = "",
    bool ignore = false,
    int? minYear,
    int? maxYear,
    String event = "",
    int minEco = 1,
    int maxEco = 500,
    String base = "all",
    String searching = "classic",
  }) {
    final Map<String, String> queryParameters = <String, String>{
      "white": white.trim(),
      "black": black.trim(),
      "ignore": ignore.toString(),
      if (minYear != null) "minYear": minYear.toString(),
      if (maxYear != null) "maxYear": maxYear.toString(),
      "event": event.trim(),
      "minEco": minEco.toString(),
      "maxEco": maxEco.toString(),
      "base": base,
      "searching": searching,
    };

    return Uri.parse(
      "$baseUrl$games",
    ).replace(queryParameters: queryParameters);
  }

  static String _getFilterGamesUrl(String name, String color, String? opening) {
    String url =
        "$baseUrl$filterGames/${Uri.encodeComponent(name)}/${Uri.encodeComponent(color)}";
    if (opening != null) {
      url += "/${Uri.encodeComponent(opening)}";
    }
    return url;
  }

  static String _getGameUrl({int gameId = 0, String base = "all"}) =>
      "$baseUrl$game/$base/$gameId";

  static Future<List<String>> searchPlayer(String name) async {
    if (name.trim().length < 4) {
      return <String>[];
    }

    try {
      final http.Response response = await http.get(
        Uri.parse(_getSearchPlayersUrl(name)),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          return data.cast<String>();
        }
        return <String>[];
      } else {
        throw Exception("Failed to search players: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Search players error: $e");
    }
  }

  static Future<PlayerRangeStats> searchMinMaxYearElo(String name) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_getSearchMinMaxYearEloUrl(name)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        if (data[0] is Map<String, dynamic>) {
          return PlayerRangeStats.fromJson(data[0]);
        } else {
          throw Exception("Unexpected data format");
        }
      } else {
        throw Exception(
          "Failed to fetch year/elo data: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("MinMaxYearElo search error: $e");
    }
  }

  static Future<List<PolandPlayer>> searchPolandPlayers(String name) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_getSearchPolandPlayersUrl(name)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return PolandPlayer.fromJson(item);
          } else {
            throw Exception("Unexpected data format for item: $item");
          }
        }).toList();
      } else {
        throw Exception(
          "Failed to fetch year/elo data: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("poland [players search error: $e");
    }
  }

  static Future<List<FidePlayer>> searchFidePlayers(String name) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_getSearchFidePlayersUrl(name)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return FidePlayer.fromJson(item);
          } else {
            throw Exception("Unexpected data format for item: $item");
          }
        }).toList();
      } else {
        throw Exception(
          "Failed to fetch year/elo data: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("poland [players search error: $e");
    }
  }

  static Future<OpeningStats> searchOpeningStats(String name) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_getOpeningStatsUrl(name)),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        return OpeningStats.fromJson(data);
      } else {
        throw Exception(
          "Failed to fetch opening stats: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to search opening stats: $e");
    }
  }

  static Future<GameResponse> searchGames({
    String white = "",
    String black = "",
    bool ignore = false,
    int? minYear,
    int? maxYear,
    String event = "",
    int minEco = 1,
    int maxEco = 500,
    String base = "all",
    String searching = "classic",
  }) async {
    try {
      final http.Response response = await http.get(
        _getGamesUrl(
          white: white,
          black: black,
          ignore: ignore,
          minYear: minYear,
          maxYear: maxYear,
          event: event,
          minEco: minEco,
          maxEco: maxEco,
          base: base,
          searching: searching,
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        if (!data.containsKey("rows") || !data.containsKey("table")) {
          throw Exception("Incorrect data");
        }

        return GameResponse(
          table: data["table"],
          games: (data["rows"] as List).map((item) {
            if (item is Map<String, dynamic>) {
              return Game.fromJson(item);
            } else {
              throw Exception("Unexpected data format for item: $item");
            }
          }).toList(),
        );
      } else {
        throw Exception("Failed to fetch games: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to search games: $e");
    }
  }

  static Future<List<Game>> searchFilterGames(
    String name,
    String color,
    String? opening,
  ) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_getFilterGamesUrl(name, color, opening)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return Game.fromJson(item);
          } else {
            throw Exception("Unexpected data format for item: $item");
          }
        }).toList();
      } else {
        throw Exception("Failed to fetch filter games: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to search filter games: $e");
    }
  }

  static Future<Game> searchGame({int gameId = 0, String base = "all"}) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_getGameUrl(gameId: gameId, base: base)),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception("Data is empty");
        }

        if (data[0] is Map<String, dynamic>) {
          return Game.fromJson(data[0]);
        } else {
          throw Exception("Unexpected data format");
        }
      } else {
        throw Exception("Failed to search game: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Search game error: $e");
    }
  }
}

class GameResponse {
  GameResponse({required this.table, required this.games});
  final String table;
  final List<Game> games;
}
