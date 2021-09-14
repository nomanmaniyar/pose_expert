// import 'package:flutter/material.dart';
// import 'package:pose_expert/main.dart' as main;
// import 'theme.dart';

// enum ThemeType { Light, Dark }

// class ThemeModel extends ChangeNotifier {
//   ThemeData currentTheme = kDarkTheme;
//   ThemeType themeType = ThemeType.Dark;

//   ThemeModel(this.currentTheme, this.themeType);

//   toggleTheme() {
//     if (this.themeType == ThemeType.Dark) {
//       main.prefs.put("darkMode", false);
//       this.currentTheme = kLightTheme;
//       this.themeType = ThemeType.Light;
//       print(main.prefs.get("darkMode"));
//       return notifyListeners();
//     }

//     if (this.themeType == ThemeType.Light) {
//       main.prefs.put("darkMode", true);
//       this.currentTheme = kDarkTheme;
//       this.themeType = ThemeType.Dark;
//       print(main.prefs.get("darkMode"));
//       return notifyListeners();
//     }
//   }

//   returnTheme() {
//     return themeType;
//   }
// }
