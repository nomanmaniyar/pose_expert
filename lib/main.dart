import 'package:flutter/material.dart';
import 'package:pose_expert/UI/pageController.dart';

// import 'package:flutter/src/widgets/framework.dart': Failed assertion: line 3949 pos 14: 'owner._debugCurrentBuildTarget == this': is not true.

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PageViewController(),
  ));
}
