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

  @override
  void initState() {
    super.initState();
    _characterListFuture = widget.characterService.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character List'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // On larger screens, show both list and details side by side
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildListView(),
                ),
                Expanded(
                  flex: 3,
                  child: CharacterDetailScreen(
                    character: _filteredCharacters.isNotEmpty
                        ? _filteredCharacters.first
                        : Character(name: '', description: '', image: ''),
                  ),
                ),
              ],
            );
          } else {
            // On smaller screens, show only the list
            return _buildListView();
          }
        },
      ),
    );
  }

  Widget _buildListView() {
    return Column(
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
        ),
      ],
    );
  }
}
