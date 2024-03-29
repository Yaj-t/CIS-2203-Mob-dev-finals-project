import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../styles/color.dart';
import 'details.dart';
import 'package:logger/logger.dart';

class CharacterBodyPage extends StatefulWidget {
  @override
  CharacterBodyPageState createState() => CharacterBodyPageState();
}

class CharacterBodyPageState extends State<CharacterBodyPage> {
  List<dynamic> charactersData = [];
  Map<String, List<String>> charactersByVision = {};
  Map<String, String> characterIcons = {};
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://genshin.jmp.blue/characters'));

      if (response.statusCode == 200) {
        final List<dynamic> fetchedCharactersData = json.decode(response.body);
        setState(() {
          charactersData = fetchedCharactersData;
        });

        await Future.wait(fetchedCharactersData.map((characterName) =>
            fetchCharacterData(characterName, charactersByVision)));

        charactersByVision.forEach((vision, characterList) {
          characterList.sort();
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      logger.e('Error fetching data: $e');
    }
  }

  Future<void> fetchCharacterData(String characterName,
      Map<String, List<String>> charactersByVision) async {
    try {
      final visionResponse = await http
          .get(Uri.parse('https://genshin.jmp.blue/characters/$characterName'));

      if (!mounted) {
        return;
      }

      if (visionResponse.statusCode == 200) {
        final characterData = json.decode(visionResponse.body);

        final iconResponse = await http.get(Uri.parse(
            'https://genshin.jmp.blue/characters/$characterName/icon-big'));
        if (!mounted) {
          return;
        }

        if (iconResponse.statusCode != 404) {
          setState(() {
            characterIcons[characterName] =
                'https://genshin.jmp.blue/characters/$characterName/icon-big';
          });
        }

        final vision = characterData['vision'];
        setState(() {
          charactersByVision.putIfAbsent(vision, () => []);
          charactersByVision[vision]!.add(characterName);
        });
      } else {
        throw Exception('Failed to load vision data for $characterName');
      }
    } catch (e) {
      logger.e('Error fetching character data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, List<String>>> sortedEntries =
        charactersByVision.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      color: Color(0xFFFFF5E1),
      child: Center(
        child: charactersData.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: sortedEntries.length,
                itemBuilder: (context, index) {
                  final vision = sortedEntries[index].key;
                  final characterNames = sortedEntries[index].value;

                  String capitalize(String text) {
                    return text.isNotEmpty
                        ? text[0].toUpperCase() + text.substring(1)
                        : text;
                  }

                  return Container(
                    height: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Text(
                            '$vision Characters',
                            style: TextStyle(
                              fontFamily: 'Genshin',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff002c58),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: characterNames.length,
                            itemBuilder: (context, index) {
                              final characterName = characterNames[index];
                              final iconUrl = characterIcons[characterName];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CharactersDetailsPage(
                                          character: characterName,
                                          vision: vision,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 250,
                                    child: Card(
                                      color: getVisionColor(vision),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          if (iconUrl != null)
                                            Image.network(
                                              iconUrl,
                                              width: 125,
                                              height: 125,
                                            )
                                          else
                                            Image.asset(
                                              'assets/paimon_empty.png',
                                              width: 125,
                                              height: 125,
                                            ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            capitalize(characterName),
                                            style: TextStyle(
                                              fontFamily: 'Genshin',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff002c58),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
