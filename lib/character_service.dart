import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class CharacterService {
  final String baseUrl;

  CharacterService(this.baseUrl);

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      print('this is char file');
      final jsonData = json.decode(response.body);
      final characters = (jsonData['results'] as List)
          .map((characterData) => Character(
                name: characterData['Name'],
                description: characterData['Description'],
                image: characterData['Icon'],
              ))
          .toList();
      return characters;
    } else {
      print('--------------------Failed to load characters');
      throw Exception('Failed to load characters');
    }
  }
}
