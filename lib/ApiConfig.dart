import 'dart:convert';
import 'package:bazaszachowa_flutter/types/FidePlayer.dart';
import 'package:bazaszachowa_flutter/types/OpeningStats.dart';
import 'package:bazaszachowa_flutter/types/PlayerRangeStats.dart';
import 'package:bazaszachowa_flutter/types/PolandPlayer.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  static const String baseUrl = 'https://api.bazaszachowa.smallhost.pl';
  static const String searchPlayersEndpoint = '/search_player';
  static const String minMaxYearElo = '/min_max_year_elo';
  static const String polandPlayer = '/cr_data';
  static const String fidePlayer = '/fide_data';
  static const String openingStats = '/player_opening_stats';

  static String _getSearchPlayersUrl(String query) {
    return '$baseUrl$searchPlayersEndpoint/${Uri.encodeComponent(query)}';
  }

  static String _getSearchMinMaxYearEloUrl(String query) {
    return '$baseUrl$minMaxYearElo/${Uri.encodeComponent(query)}';
  }

  static String _getSearchPolandPlayersUrl(String query) {
    return '$baseUrl$polandPlayer/${Uri.encodeComponent(query)}';
  }

  static String _getSearchFidePlayersUrl(String query) {
    return '$baseUrl$fidePlayer/${Uri.encodeComponent(query)}';
  }

  static String _getOpeningStatsUrl(String query) {
    return '$baseUrl$openingStats/${Uri.encodeComponent(query)}';
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

  static Future<PlayerRangeStats> searchMinMaxYearElo(String name) async {
    try {
      final response = await http.get(
        Uri.parse(_getSearchMinMaxYearEloUrl(name)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('Data is empty');
        }

        if (data[0] is Map<String, dynamic>) {
          return PlayerRangeStats.fromJson(data[0]);
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception(
          'Failed to fetch year/elo data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('MinMaxYearElo search error: $e');
    }
  }

  static Future<List<PolandPlayer>> searchPolandPlayers(String name) async {
    try {
      final response = await http.get(
        Uri.parse(_getSearchPolandPlayersUrl(name)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('Data is empty');
        }

        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return PolandPlayer.fromJson(item);
          } else {
            throw Exception('Unexpected data format for item: $item');
          }
        }).toList();
      } else {
        throw Exception(
          'Failed to fetch year/elo data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('poland [players search error: $e');
    }
  }

  static Future<List<FidePlayer>> searchFidePlayers(String name) async {
    try {
      final response = await http.get(
        Uri.parse(_getSearchFidePlayersUrl(name)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('Data is empty');
        }

        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return FidePlayer.fromJson(item);
          } else {
            throw Exception('Unexpected data format for item: $item');
          }
        }).toList();
      } else {
        throw Exception(
          'Failed to fetch year/elo data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('poland [players search error: $e');
    }
  }

  static Future<OpeningStats> searchOpeningStats(String name) async {
    try {
      final response = await http.get(Uri.parse(_getOpeningStatsUrl(name)));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('Data is empty');
        }

        return OpeningStats.fromJson(data);
      } else {
        throw Exception(
          'Failed to fetch opening stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to search opening stats: $e');
    }
  }
}
