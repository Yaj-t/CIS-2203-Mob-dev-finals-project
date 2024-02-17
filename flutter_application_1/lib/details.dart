import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'apiservice.dart';
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
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getVisionSecondaryColor(vision),
      appBar: AppBar(
        backgroundColor: Color(0xff002c58),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            apiService.fetchPortrait(character),
            apiService.fetchAscensionMaterials(vision),
            apiService.fetchBossAscensionMaterials(character),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<dynamic> results = snapshot.data ?? [];

              Widget imageWidget;

              if (results[0] != null && results[0].isNotEmpty) {
                imageWidget = Image.network(
                  results[0],
                  width: 400,
                  height: 400,
                );
              } else {
                imageWidget = Image.asset(
                  'assets/portrait_empty.png',
                  width: 400,
                  height: 400,
                );
              }

              final Map<String, dynamic> ascensionMaterials =
                  results[1] as Map<String, dynamic>? ?? {};

              final Map<String, String> bossMaterial =
                  results[2] as Map<String, String>? ?? {};

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    imageWidget,
                    SizedBox(height: 5),
                    Text(
                      character.toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Genshin',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff002c58),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/Element_$vision.svg',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 10),
                    buildAscensionMaterialRow(
                        'Sliver', ascensionMaterials['sliver']!),
                    buildAscensionMaterialRow(
                        'Fragment', ascensionMaterials['fragment']!),
                    buildAscensionMaterialRow(
                        'Chunk', ascensionMaterials['chunk']!),
                    buildAscensionMaterialRow(
                        'Gemstone', ascensionMaterials['gemstone']!),
                    SizedBox(height: 10),
                    // Display boss material information
                    buildBossMaterialRow(bossMaterial),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildAscensionMaterialRow(
    String materialType,
    Map<String, dynamic> materialData,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$materialType:'),
        SizedBox(width: 10),
        Text(
          '${materialData['name']}',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff002c58),
          ),
        ),
      ],
    );
  }

  Widget buildBossMaterialRow(Map<String, String> bossMaterial) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Boss Material:'),
        SizedBox(width: 10),
        Text(
          '${bossMaterial['name']}',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff002c58),
          ),
        ),
      ],
    );
  }
}
