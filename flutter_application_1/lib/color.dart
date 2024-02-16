import 'package:flutter/material.dart';

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
      return Colors.yellow.shade300;
    case 'Electro':
      return Colors.purple;
    case 'Cryo':
      return Colors.blue.shade100;
    default:
      return Colors.grey;
  }
}
