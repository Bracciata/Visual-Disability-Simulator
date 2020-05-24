import 'package:flutter/cupertino.dart';

class ColorBlindnessFilters{
  String colorFilterName;
  ColorFilter colorFilter;
  ColorBlindnessFilters(String name, List colors){
    colorFilterName=name;
    colorFilter = ColorFilter.matrix(colors);
  }
}