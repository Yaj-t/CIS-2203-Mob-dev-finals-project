import 'package:flutter/material.dart';

Widget buildAscensionMaterialRow(
  String materialType,
  Map<String, dynamic>? materialData,
) {
  String? materialName =
      materialData?['name']?.toLowerCase()?.replaceAll(' ', '-');

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('$materialType:'),
      SizedBox(width: 10),
      Text(
        '${materialData?['name'] ?? 'Not yet updated'}',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff002c58),
        ),
      ),
      SizedBox(width: 10),
      // Check if materialName is null, and display the appropriate image
      materialName != null
          ? Image.network(
              'https://genshin.jmp.blue/materials/character-ascension/$materialName',
              width: 35,
              height: 35,
            )
          : Image.asset(
              'assets/portrait_empty.png',
              width: 35,
              height: 35,
            ),
    ],
  );
}

Widget buildBossMaterialRow(Map<String, String> bossMaterial) {
  String? bossMaterialName =
      bossMaterial['name']?.toLowerCase().replaceAll(' ', '-');

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
      SizedBox(width: 10),
      bossMaterialName != null
          ? Image.network(
              'https://genshin.jmp.blue/materials/boss-material/$bossMaterialName',
              width: 35,
              height: 35,
            )
          : Image.asset(
              'assets/portrait_empty.png',
              width: 35,
              height: 35,
            ),
    ],
  );
}

Widget buildLocalMaterialRow(Map<String, String> localMaterial) {
  String? localMaterialName =
      localMaterial['name']?.toLowerCase().replaceAll(' ', '-');

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Local Material:'),
      SizedBox(width: 10),
      Text(
        '${localMaterial['name']}',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff002c58),
        ),
      ),
      SizedBox(width: 10),
      localMaterialName != null
          ? Image.network(
              'https://genshin.jmp.blue/materials/local-specialties/$localMaterialName',
              width: 35,
              height: 35,
            )
          : Image.asset(
              'assets/portrait_empty.png',
              width: 35,
              height: 35,
            ),
    ],
  );
}

Widget buildCommonMaterialRow(Map<String, dynamic> commonMaterial) {
  if (commonMaterial.isNotEmpty) {
    List<Widget> itemsWidgets = [];

    if (commonMaterial['items'] != null) {
      for (var itemData in commonMaterial['items'] ?? []) {
        String? itemId = itemData['id']?.toString();
        String? itemName = itemData['name']?.toString();
        String? itemRarity = itemData['rarity']?.toString();

        itemsWidgets.add(
          Column(
            children: [
              Text('Item Name: $itemName'),
              Text('Item Rarity: $itemRarity'),
              SizedBox(height: 10),
              // Check if itemIdFormatted is null, and display the appropriate image
              itemId != null
                  ? Image.network(
                      'https://genshin.jmp.blue/materials/common-ascension/$itemId',
                      width: 35,
                      height: 35,
                    )
                  : Image.asset(
                      'assets/portrait_empty.png',
                      width: 35,
                      height: 35,
                    ),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        Text('Common Materials:'),
        Column(
          children: itemsWidgets,
        ),
      ],
    );
  } else {
    return Container();
  }
}

Widget buildWeeklyBossMaterialRow(Map<String, String> weeklyBossMaterial) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Weekly Boss Material:'),
      SizedBox(width: 10),
      Text(
        '${weeklyBossMaterial['name']}',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff002c58),
        ),
      ),
    ],
  );
}

Widget buildTalentMaterialRow(Map<String, dynamic> talentMaterial) {
  if (talentMaterial.isNotEmpty) {
    List<Widget> itemsWidgets = [];

    if (talentMaterial['items'] != null) {
      for (var itemData in talentMaterial['items']) {
        itemsWidgets.add(
          Column(
            children: [
              Text('Talent Item ID: ${itemData['id']}'),
              Text('Talent Item Name: ${itemData['name']}'),
              Text('Talent Item Rarity: ${itemData['rarity']}'),
              SizedBox(height: 10),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        Text('Talent Common Materials:'),
        Column(
          children: itemsWidgets,
        ),
      ],
    );
  } else {
    return Container();
  }
}
