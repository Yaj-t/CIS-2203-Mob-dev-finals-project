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
  Map<String, String> characterVisions = {};
  Map<String, String> characterNation = {};
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
              characterVisions[characterName] = characterData['vision'];
              characterNation[characterName] = characterData['nation'];
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
              : ListView.builder(
                  itemCount: charactersData.length,
                  itemBuilder: (context, index) {
                    final characterName = charactersData[index];
                    final vision = characterVisions[characterName];
                    final nation = characterNation[characterName];

                    return ListTile(
                      title: Text(
                        vision != null
                            ? '$characterName ($vision, $nation)'
                            : '$characterName (Vision not found)',
                      ),
                    );
                  },
                ),
    );
  }
}
