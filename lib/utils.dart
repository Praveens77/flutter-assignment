import 'package:flutter/material.dart';

// App Colors
const black = Color(0xff000000);
const white = Color(0xffFFFFFF);
const yellow = Color(0xfff9d12b);
const grey = Colors.grey;
const lightBlack = Colors.black45;

// App Texts
customText(txt, size, clr, wt){
  return Text(txt,
    style: TextStyle(
      fontSize: size,
      color: clr,
      fontWeight: wt
    ),
  );
}