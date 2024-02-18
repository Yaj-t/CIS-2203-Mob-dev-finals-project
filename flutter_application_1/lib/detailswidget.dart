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
      bossMaterial['name'] != null
          ? Text(
              '${bossMaterial['name']}',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff002c58),
              ),
            )
          : Text(
              'Not yet updated',
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
      localMaterial['name'] != null
          ? Text(
              '${localMaterial['name']}',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff002c58),
              ),
            )
          : Text(
              'Not yet updated',
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

Widget buildCommonMaterialRow(Map<String, dynamic>? commonMaterial) {
  if (commonMaterial != null && commonMaterial.isNotEmpty) {
    List<Widget> itemsWidgets = [];

    if (commonMaterial['items'] != null) {
      for (var itemData in commonMaterial['items'] ?? []) {
        String? itemId = itemData['id']?.toString();
        String? itemName = itemData['name']?.toString();

        itemsWidgets.add(
          Column(
            children: [
              itemName != null
                  ? RichText(
                      text: TextSpan(
                        text: 'Item name: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '$itemName',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff002c58), // Change the color here
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      'Not yet updated',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff002c58),
                      ),
                    ),
              SizedBox(height: 10),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 7),
        Text('Common Materials:'),
        SizedBox(height: 7),
        Column(
          children: itemsWidgets,
        ),
        SizedBox(height: 7),
      ],
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 3),
        RichText(
          text: TextSpan(
            text: 'Common Materials: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'Not yet updated',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff002c58), // Change the color here
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildWeeklyBossMaterialRow(Map<String, String> weeklyBossMaterial) {
  String? weeklyBossMaterialName = weeklyBossMaterial['name']
      ?.toLowerCase()
      .replaceAll(' ', '-')
      .replaceAll("'", '-');

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Local Material:'),
      SizedBox(width: 10),
      weeklyBossMaterial['name'] != null
          ? Text(
              '${weeklyBossMaterial['name']}',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff002c58),
              ),
            )
          : Text(
              'Not yet updated',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff002c58),
              ),
            ),
      SizedBox(width: 10),
      weeklyBossMaterialName != null
          ? Image.network(
              'https://genshin.jmp.blue/materials/talent-boss/$weeklyBossMaterialName',
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

Widget buildTalentMaterialRow(Map<String, dynamic>? talentMaterial) {
  if (talentMaterial != null && talentMaterial.isNotEmpty) {
    List<Widget> itemsWidgets = [];

    if (talentMaterial['items'] != null) {
      for (var itemData in talentMaterial['items'] ?? []) {
        String? itemId = itemData['id']?.toString();
        String? itemName = itemData['name']?.toString();

        itemsWidgets.add(
          Column(
            children: [
              itemName != null
                  ? RichText(
                      text: TextSpan(
                        text: 'Item name: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '$itemName',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff002c58), // Change the color here
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      'Not yet updated',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff002c58),
                      ),
                    ),
              SizedBox(height: 10),
              itemId != null
                  ? Image.network(
                      'https://genshin.jmp.blue/materials/talent-book/$itemId',
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 7),
        Text('Talent Materials:'),
        SizedBox(height: 7),
        Column(
          children: itemsWidgets,
        ),
        SizedBox(height: 7),
      ],
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 3),
        RichText(
          text: TextSpan(
            text: 'Talent Materials: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'Not yet updated',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff002c58), // Change the color here
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
