import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'routes.dart';
import 'footer.dart';
import 'appbar.dart';
import 'color.dart';
import 'details.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    routes: routes,
  ));
}

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomeAppBar(),
      ),
      body: Center(
        child: HomeBodyPage(),
      ),
      bottomNavigationBar: HomeFooter(),
    );
  }
}

class HomeBodyPage extends StatefulWidget {
  @override
  HomeBodyPageState createState() => HomeBodyPageState();
}

class HomeBodyPageState extends State<HomeBodyPage> {
  List<dynamic> charactersData = [];
  Map<String, List<String>> charactersByVision = {};
  Map<String, String> characterIcons = {};
  bool loadingComplete = false;
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

        await Future.wait(
          fetchedCharactersData.map((characterName) async {
            final visionResponse = await http.get(Uri.parse(
                'https://genshin.jmp.blue/characters/$characterName'));

            if (visionResponse.statusCode == 200) {
              final characterData = json.decode(visionResponse.body);

              final iconResponse = await http.get(Uri.parse(
                  'https://genshin.jmp.blue/characters/$characterName/icon-big'));
              if (iconResponse.statusCode != 404) {
                characterIcons[characterName] =
                    'https://genshin.jmp.blue/characters/$characterName/icon-big';
              }

              final vision = characterData['vision'];
              charactersByVision.putIfAbsent(vision, () => []);
              charactersByVision[vision]!.add(characterName);
            } else {
              throw Exception('Failed to load vision data for $characterName');
            }
          }),
        );

        // Mark loading as complete
        setState(() {
          loadingComplete = true;
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      logger.e('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !loadingComplete
          ? const CircularProgressIndicator()
          : charactersData.isEmpty
              ? const Text('No characters found.')
              : ListView(
                  children: charactersByVision.entries.map((entry) {
                    final vision = entry.key;
                    final characterNames = entry.value;
                    return Container(
                      height: 275,
                      color: Color(0xFFFFF5E1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              '$vision Characters',
                              style: TextStyle(
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
                                              characterName,
                                              style: TextStyle(
                                                fontSize: 20,
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
                  }).toList(),
                ),
    );
  }
}
