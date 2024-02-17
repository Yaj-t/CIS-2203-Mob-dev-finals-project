import 'package:flutter/material.dart';

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

Widget buildLocalMaterialRow(Map<String, String> localMaterial) {
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
    ],
  );
}

Widget buildCommonMaterialRow(Map<String, dynamic> commonMaterial) {
  if (commonMaterial.isNotEmpty) {
    List<Widget> itemsWidgets = [];

    if (commonMaterial['items'] != null) {
      for (var itemData in commonMaterial['items'] ?? []) {
        itemsWidgets.add(
          Column(
            children: [
              Text('Item ID: ${itemData['id']}'),
              Text('Item Name: ${itemData['name']}'),
              Text('Item Rarity: ${itemData['rarity']}'),
              SizedBox(height: 10),
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
