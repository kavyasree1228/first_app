import 'package:flutter/material.dart';
import 'character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character? character;

  CharacterDetailScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      appBar: isLargeScreen
          ? null // No app bar for larger screens
          : AppBar(
              title: const Text('Character Detail'),
            ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: character != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    character!.image,
                    height: 150,
                  ),
                  SizedBox(height: 45.0),
                  Text(
                    character!.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              )
            : Center(
                child: Text(
                    'Please select a character from the list')), // Center the message
      ),
    );
  }
}
