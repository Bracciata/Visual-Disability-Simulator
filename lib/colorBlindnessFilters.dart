import 'package:flutter/cupertino.dart';

class ColorBlindnessFilters{
  String name;
  ColorFilter colorFilter;
  ColorBlindnessFilters(String colorFilterName, List colors){
    name=colorFilterName;
    colorFilter = ColorFilter.matrix(colors);
  }
}