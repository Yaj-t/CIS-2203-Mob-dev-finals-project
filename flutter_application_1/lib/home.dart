import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'routes.dart';
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
        child: _HomeAppBar(),
      ),
      body: Center(
        child: _HomeBodyPage(),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff002c58),
      shape:
          const Border(bottom: BorderSide(color: Color(0xFF2D2D39), width: 2)),
      title: Row(
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                'assets/paimon_logo.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}

class _HomeBodyPage extends StatefulWidget {
  @override
  _HomeBodyPageState createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<_HomeBodyPage> {
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
                            height: 200, // Adjust the height as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: characterNames.length,
                              itemBuilder: (context, index) {
                                final characterName = characterNames[index];
                                final iconUrl = characterIcons[characterName];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 200, // Set your desired width
                                    height: 250, // Set your desired height
                                    child: Card(
                                      color: getVisionColor(vision),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          if (iconUrl != null)
                                            Image.network(
                                              iconUrl!,
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

  Color getVisionColor(String vision) {
    switch (vision) {
      case 'Dendro':
        return Colors.green.shade400;
      case 'Pyro':
        return Colors.red;
      case 'Hydro':
        return Colors.blue.shade400;
      case 'Anemo':
        return Colors.green.shade100;
      case 'Geo':
        return Colors.brown;
      case 'Electro':
        return Colors.purple;
      case 'Cryo':
        return Colors.blue.shade100;
      default:
        return Colors.grey;
    }
  }
}
