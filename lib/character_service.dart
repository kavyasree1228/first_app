import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class CharacterService {
  final String baseUrl;

  CharacterService(this.baseUrl);

  String extractNameFromUrl(String url) {
    List<String> urlParts = url.split('/');
    return urlParts.last;
  }

  String _extractImageUrl(String url) {
    if (url.isEmpty) {
      return 'https://picsum.photos/200/300'; // Empty URL
    } else if (url.startsWith('/')) {
      return 'https://duckduckgo.com$url'; // Complete URL
    } else {
      return url; // Already a complete URL
    }
  }

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final relatedTopics = jsonData['RelatedTopics'] as List;
      final characters = relatedTopics.map((topic) {
        //  final name = extractNameFromUrl(topic['FirstURL']);
        return Character(
          name: extractNameFromUrl(topic['FirstURL']).replaceAll('_', ' '),
          description: topic['Text'],
          image: _extractImageUrl(topic['Icon']['URL']),
        );
      }).toList();

      return characters;
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
