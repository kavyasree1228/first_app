import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class CharacterService {
  final String baseUrl;

  CharacterService(this.baseUrl);
  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final relatedTopics = jsonData['RelatedTopics'] as List;
      final characters = relatedTopics.map((topic) {
        return Character(
          name: _stripHtmlTags(topic['Result']),
          description: '', // You can set description as needed
          image: _extractImageUrl(topic['Icon']['URL']),
        );
      }).toList();

      return characters;
    } else {
      throw Exception('Failed to load characters');
    }
  }

// Helper method to strip HTML tags from a string
  String _stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(regex, '');
  }

// Helper method to extract the image URL from the API response
  String _extractImageUrl(String url) {
    return 'https://duckduckgo.com$url';
  }
}
