import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'color.dart';

class CharactersDetailsPage extends StatefulWidget {
  final String character;
  final String vision;

  CharactersDetailsPage({required this.character, required this.vision});

  @override
  CharactersDetailsPageState createState() =>
      CharactersDetailsPageState(character: character, vision: vision);
}

class CharactersDetailsPageState extends State<CharactersDetailsPage> {
  final String character;
  final String vision;
  final Logger logger = Logger();

  CharactersDetailsPageState({required this.character, required this.vision});

  Future<String> fetchPortrait() async {
    try {
      final response = await http
          .get(Uri.parse('https://genshin.jmp.blue/characters/$character'));

      if (response.statusCode == 200) {
        final portraitResponse = await http.get(Uri.parse(
            'https://genshin.jmp.blue/characters/$character/portrait'));

        if (portraitResponse.statusCode != 404) {
          return 'https://genshin.jmp.blue/characters/$character/portrait';
        }
      } else {
        throw Exception('Failed to load data for $character');
      }
    } catch (e) {
      logger.e('Error fetching data: $e');
      return '';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getVisionColor(vision),
      appBar: AppBar(
        backgroundColor: Color(0xff002c58),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchPortrait(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Image.network(
                  snapshot.data!,
                  width: 400,
                  height: 400,
                );
              } else {
                return Image.asset(
                  'assets/portrait_empty.png',
                  width: 400,
                  height: 400,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
