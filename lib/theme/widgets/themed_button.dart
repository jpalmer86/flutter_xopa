import 'package:flutter/material.dart';

class ThemedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool filled;
  final bool expanded;

  ThemedButton({
    @required this.onPressed,
    this.child,
    this.filled = false,
    this.expanded = false,
  });

  ThemedButton.icon({
    @required this.onPressed,
    @required Widget icon,
    Widget label,
    this.filled = false,
    this.expanded = false,
  }) : this.child = _buildIconButtonChild(icon, label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expanded ? double.infinity : null,
      child: MaterialButton(
        onPressed: onPressed,
        child: DefaultTextStyle(
          style: filled
              ? Theme.of(context).primaryTextTheme.button
              : Theme.of(context).textTheme.button,
          child: child,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: filled
              ? BorderSide.none
              : BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        color: filled ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }

  static Widget _buildIconButtonChild(Widget icon, Widget label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 14.5),
          child: icon,
        ),
        label,
      ],
    );
  }
}
