import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class ApiService {
  final Logger logger = Logger();

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

  Future<String> fetchVisionIcon(String vision) async {
    try {
      final response = await http.get(Uri.parse(
          'https://genshin.jmp.blue/elements/${vision.toLowerCase()}/icon'));

      if (response.statusCode == 200) {
        final visionResponse = await http.get(Uri.parse(
            'https://genshin.jmp.blue/elements/${vision.toLowerCase()}/icon'));
        
        if (visionResponse.statusCode != 404) {
          return 'https://genshin.jmp.blue/elements/${vision.toLowerCase()}/icon';
        }
      } else {
        throw Exception('Failed to load data for $vision icon');
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

  Future<Map<String, String>> fetchLocalAscensionMaterials(
      String character) async {
    try {
      final response = await http.get(
          Uri.parse('https://genshin.jmp.blue/materials/local-specialties'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> localMaterials = json.decode(response.body);

        for (var regionData in localMaterials.values) {
          if (regionData is List) {
            for (var entry in regionData) {
              if (entry['characters'] != null &&
                  entry['characters'].contains(character.toLowerCase())) {
                String localMaterialId = entry['id'];
                String localMaterialName = entry['name'];

                return {'id': localMaterialId, 'name': localMaterialName};
              }
            }
          }
        }
      } else {
        throw Exception('Failed to load data for local ascension materials');
      }
    } catch (e) {
      return {};
    }

    return {};
  }

  Future<Map<String, dynamic>> fetchCommonAscensionMaterials(
    String character,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('https://genshin.jmp.blue/materials/common-ascension'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> commonMaterials = json.decode(response.body);

        for (var entry in commonMaterials.entries) {
          Map<String, dynamic> commonMaterialData = entry.value;

          if (commonMaterialData['characters'] != null &&
              List<String>.from(commonMaterialData['characters'])
                  .contains(character.toLowerCase())) {
            String commonMaterialId = entry.key;
            List<Map<String, dynamic>> items = [];

            for (var itemData in commonMaterialData['items']) {
              String itemId = itemData['id'];
              String itemName = itemData['name'];
              int itemRarity = itemData['rarity'];

              items.add({
                'id': itemId,
                'name': itemName,
                'rarity': itemRarity,
              });
            }

            return {
              'id': commonMaterialId,
              'items': items,
            };
          }
        }
      } else {
        throw Exception('Failed to load data for common ascension materials');
      }
    } catch (e) {
      return {};
    }

    return {};
  }

  Future<Map<String, String>> fetchWeeklyBossAscensionMaterials(
      String character) async {
    try {
      final response = await http
          .get(Uri.parse('https://genshin.jmp.blue/materials/talent-boss'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> weeklyBossMaterials =
            json.decode(response.body);

        for (var entry in weeklyBossMaterials.entries) {
          String weeklyMaterialId = entry.key;
          Map<String, dynamic> weeklyMaterialData = entry.value;

          if (weeklyMaterialData['characters'] != null &&
              weeklyMaterialData['characters']
                  .contains(character.toLowerCase())) {
            String weeklyMaterialName = weeklyMaterialData['name'];
            return {'id': weeklyMaterialId, 'name': weeklyMaterialName};
          }
        }
      } else {
        throw Exception(
            'Failed to load data for weekly boss ascension materials');
      }
    } catch (e) {
      return {};
    }

    return {};
  }

  Future<Map<String, dynamic>> fetchTalentAscensionMaterials(
    String character,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('https://genshin.jmp.blue/materials/talent-book'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> talentMaterials = json.decode(response.body);

        for (var entry in talentMaterials.entries) {
          Map<String, dynamic> talentMaterialData = entry.value;

          if (talentMaterialData['characters'] != null &&
              List<String>.from(talentMaterialData['characters'])
                  .contains(character.toLowerCase())) {
            String talentMaterialId = entry.key;
            List<Map<String, dynamic>> talentItems = [];

            for (var talentItemData in talentMaterialData['items']) {
              String talentItemId = talentItemData['id'];
              String talentItemName = talentItemData['name'];
              int talentItemRarity = talentItemData['rarity'];

              talentItems.add({
                'id': talentItemId,
                'name': talentItemName,
                'rarity': talentItemRarity,
              });
            }

            return {
              'id': talentMaterialId,
              'items': talentItems,
            };
          }
        }
      } else {
        throw Exception('Failed to load data for talent ascension materials');
      }
    } catch (e) {
      return {};
    }

    return {};
  }
}
