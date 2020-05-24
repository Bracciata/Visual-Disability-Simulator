import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavTab{
    String title;
    IconData icon;
    MaterialColor color;
    NavTab(String tabTitle, IconData tabIcon, MaterialColor tabColor){
      title =tabTitle;
      icon = tabIcon;
      color=tabColor;
    }
}