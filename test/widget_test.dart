// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

import 'package:first_app/character.dart';
import 'package:first_app/character_list_screen.dart';
import 'package:first_app/character_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CharacterListScreen displays correct title',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: CharacterListScreen(
          characterService: MockCharacterService(
              'http://api.duckduckgo.com/?q=simpsons+characters&format=json'), // Replace with your character service
          packageName: 'com.sample.simpsonsviewer',
        ),
      ),
    );

    // Find the title widget
    final titleFinder = find.text('Character List');

    // Expect the title to be present
    expect(titleFinder, findsOneWidget);
  });
}

// Mock character service for testing
class MockCharacterService extends CharacterService {
  MockCharacterService(super.baseUrl);

  @override
  Future<List<Character>> fetchCharacters() async {
    // Return mock data for testing
    return [
      Character(name: 'Character 1', description: '', image: ''),
      Character(name: 'Character 2', description: '', image: ''),
    ];
  }
}
