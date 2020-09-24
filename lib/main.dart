import 'package:flutter/material.dart';
import 'package:xopa_app/pages/loading/loading_page.dart';
import 'package:xopa_app/theme/theme.dart';

void main() => runApp(MaterialApp(
  title: 'Xopa',
  theme: appTheme,
  darkTheme: appDarkTheme,
  home: LoadingPage(),
));