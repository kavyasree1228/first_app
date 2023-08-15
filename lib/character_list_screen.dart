import 'package:flutter/material.dart';
import 'character.dart';
import 'character_detail_screen.dart';
import 'character_service.dart';

class CharacterListScreen extends StatefulWidget {
  final CharacterService characterService;

  const CharacterListScreen(
      {required this.characterService, required String packageName});

  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late Future<List<Character>> _characterListFuture;

  @override
  void initState() {
    super.initState();
    _characterListFuture = widget.characterService.fetchCharacters();
    // Print the API response
    _characterListFuture.then((characters) {
      print('API Response: $characters');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character Viewer'),
      ),
      body: FutureBuilder<List<Character>>(
        future: _characterListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                // final extractedName = widget.characterService
                //     .extractNameFromUrl(character.firstUrl);
                return ListTile(
                  title: Text(character.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CharacterDetailScreen(character: character),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//       home: CharacterListScreen(
//           characterService: CharacterService('http://api.duckduckgo.com/?'))));
// }
