import 'package:flutter/material.dart';

class CharacterSearchBar extends StatelessWidget {
  final ValueChanged<String> onTextChanged;

  const CharacterSearchBar({required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onTextChanged,
        decoration: InputDecoration(
          labelText: 'Search Characters',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
