import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<String> fetchPortrait(String character) async {
    try {
      final response = await http
          .get(Uri.parse('https://genshin.jmp.blue/characters/$character'));

      if (response.statusCode == 200) {
        final gachaSplashResponse = await http.get(Uri.parse(
            'https://genshin.jmp.blue/characters/$character/gacha-splash'));
        final portraitResponse = await http.get(Uri.parse(
            'https://genshin.jmp.blue/characters/$character/portrait'));

        if (gachaSplashResponse.statusCode != 404) {
          return 'https://genshin.jmp.blue/characters/$character/gacha-splash';
        } else if (portraitResponse.statusCode != 404) {
          return 'https://genshin.jmp.blue/characters/$character/portrait';
        }
      } else {
        throw Exception('Failed to load data for $character');
      }
    } catch (e) {
      return '';
    }

    return '';
  }

  Future<Map<String, dynamic>> fetchAscensionMaterials(String vision) async {
    try {
      final response = await http.get(
          Uri.parse('https://genshin.jmp.blue/materials/character-ascension'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> ascensionData = json.decode(response.body);
        final Map<String, dynamic> visionData =
            ascensionData[vision.toLowerCase()];

        final Map<String, dynamic> sliverData = visionData['sliver'];
        final Map<String, dynamic> fragmentData = visionData['fragment'];
        final Map<String, dynamic> chunkData = visionData['chunk'];
        final Map<String, dynamic> gemstoneData = visionData['gemstone'];

        return {
          'sliver': sliverData,
          'fragment': fragmentData,
          'chunk': chunkData,
          'gemstone': gemstoneData,
        };
      } else {
        throw Exception('Failed to load data for ascension materials');
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, String>> fetchBossAscensionMaterials(
      String character) async {
    try {
      final response = await http
          .get(Uri.parse('https://genshin.jmp.blue/materials/boss-material'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> bossMaterials = json.decode(response.body);

        // Iterate through the boss materials to find the one associated with the character
        for (var entry in bossMaterials.entries) {
          String materialId = entry.key;
          Map<String, dynamic> materialData = entry.value;

          if (materialData['characters'] != null &&
              materialData['characters'].contains(character.toLowerCase())) {
            String materialName = materialData['name'];
            return {'id': materialId, 'name': materialName};
          }
        }
      } else {
        throw Exception('Failed to load data for boss ascension materials');
      }
    } catch (e) {
      return {};
    }

    return {};
  }
}
