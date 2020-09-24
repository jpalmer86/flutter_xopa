import 'package:flutter/material.dart';

/// The [ThemedAppBar] allows this app to use a consistent
/// [AppBar] across the entire app.
class ThemedAppBar extends AppBar {
  ThemedAppBar({
    @required Widget title,
    Widget child,
    List<Widget> actions,
  }) : super(
          centerTitle: true,
          title: title,
          actions: actions,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          flexibleSpace: child,
        );
}
