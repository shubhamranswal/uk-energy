import 'package:flutter/cupertino.dart';

double fontSizer(BuildContext context){
  var fontSize = 16.0;
  var width = MediaQuery.of(context).size.width;
  if (width <= 480) {
    fontSize = 16.0;
  } else if (width > 480 && width <= 960) {
    fontSize = 22.0;
  } else {
    fontSize = 28.0;
  }
  return fontSize;
}