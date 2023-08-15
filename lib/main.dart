import 'package:flutter/material.dart';
import 'character_list_screen.dart';
import 'character_service.dart';
import 'package:flutter_config/flutter_config.dart';
import '../flavors/simpsons/simpsonsConfig.dart' as simpsonConfig;
import '../flavors/the_wire/wireConfig.dart' as wireConfig;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flavor Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _navigateToListScreen(
                  context,
                  simpsonConfig.AppConfig.apiUrl,
                  simpsonConfig.AppConfig.packageName,
                );
              },
              child: Text('Simpsons Flavor'),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToListScreen(
                  context,
                  wireConfig.AppConfig.apiUrl,
                  wireConfig.AppConfig.packageName,
                );
              },
              child: Text('Wire Flavor'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToListScreen(
      BuildContext context, String apiUrl, String packageName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterListScreen(
          characterService: CharacterService(apiUrl),
          packageName: packageName,
        ),
      ),
    );
  }
}
