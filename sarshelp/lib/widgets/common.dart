
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildWaitingScreen() {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ),
  );
}