import 'package:flutter/material.dart';

BoxDecoration dec =BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomLeft,
        colors: [Colors.deepPurpleAccent[500],Colors.deepPurpleAccent[600],Colors.deepPurple[800]])
);


BoxDecoration dec2 =BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.deepPurpleAccent[400],Colors.deepPurpleAccent[600],Colors.deepPurple[800]])
);

BoxDecoration dec3 =BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.deepPurple[900],Colors.deepPurple[700]])
);
kTextFieldColor = Colors.green;
kLabelColor = Colors.blue;
