import 'package:flutter/cupertino.dart';

class ColorBlindnessFilters{
  String name;
  String about;
  ColorFilter colorFilter;
  ColorBlindnessFilters(String colorFilterName,String aboutColorFilter, List colors){
    name=colorFilterName;
    colorFilter = ColorFilter.matrix(colors);
    about=aboutColorFilter;
  }
}