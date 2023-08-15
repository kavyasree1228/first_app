import 'package:flutter/material.dart';
import 'character.dart';
import 'character_detail_screen.dart';
import 'character_service.dart';
import 'character_search_bar.dart'; // Import the new widget

class CharacterListScreen extends StatefulWidget {
  final CharacterService characterService;
  final String packageName;

  const CharacterListScreen({
    required this.characterService,
    required this.packageName,
  });

  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late Future<List<Character>> _characterListFuture;
  List<Character> _filteredCharacters = []; // New list for filtered characters
  Character? _selectedCharacter; // Track selected character

  @override
  void initState() {
    super.initState();
    _characterListFuture = widget.characterService.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(
              title: const Text('Character viewing'),
            ) // No app bar for larger screens
          : AppBar(
              title: const Text('Character List'),
            ),
      body: isLargeScreen
          ? Row(
              children: [
                // List on the left
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      CharacterSearchBar(
                        onTextChanged: (value) async {
                          final characters = await _characterListFuture;
                          setState(() {
                            _filteredCharacters = characters
                                .where((character) => character.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      Expanded(
                        child: FutureBuilder<List<Character>>(
                          future: _characterListFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              final characters = snapshot.data!;
                              final charactersToShow =
                                  _filteredCharacters.isNotEmpty
                                      ? _filteredCharacters
                                      : characters;

                              return ListView.separated(
                                itemCount: charactersToShow.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final character = charactersToShow[index];
                                  return ListTile(
                                    title: Text(character.name),
                                    selected: _selectedCharacter == character,
                                    onTap: () {
                                      setState(() {
                                        _selectedCharacter = character;
                                      });
                                    },
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No data available'));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Details on the right
                Flexible(
                  flex: 2,
                  child: CharacterDetailScreen(
                    character: _selectedCharacter,
                  ),
                ),
              ],
            )
          : FutureBuilder<List<Character>>(
              future: _characterListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final characters = snapshot.data!;
                  final charactersToShow = _filteredCharacters.isNotEmpty
                      ? _filteredCharacters
                      : characters;

                  return ListView.separated(
                    itemCount: charactersToShow.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final character = charactersToShow[index];
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
                  return const Center(child: Text('No data available'));
                }
              },
            ),
    );
  }
}
