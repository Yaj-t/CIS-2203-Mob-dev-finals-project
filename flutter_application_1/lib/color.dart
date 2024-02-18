import 'package:flutter/material.dart';

Color getVisionColor(String vision) {
  switch (vision) {
    case 'Dendro':
      return Color(0xff2c853f);
    case 'Pyro':
      return Color(0xffea3943);
    case 'Hydro':
      return Color(0xff3262d2);
    case 'Anemo':
      return Color(0xff75c2aa);
    case 'Geo':
      return Color(0xfffdb237);
    case 'Electro':
      return Color(0xff693b84);
    case 'Cryo':
      return Color(0xff4f93cc);
    default:
      return Colors.grey;
  }
}

Color getVisionSecondaryColor(String vision) {
  switch (vision) {
    case 'Dendro':
      return Color(0xff859a5a);
    case 'Pyro':
      return Color(0xffffabab);
    case 'Hydro':
      return Colors.blue.shade400;
    case 'Anemo':
      return Colors.green.shade100;
    case 'Geo':
      return Color(0xfffee9a5);
    case 'Electro':
      return Color(0xffd2a3d3);
    case 'Cryo':
      return Color(0xffa1d0fc);
    default:
      return Colors.grey;
  }
}
