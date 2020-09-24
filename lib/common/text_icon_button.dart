import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {

  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  TextIconButton({@required this.icon, this.text = '', @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        IconButton(
          icon: icon,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          alignment: const Alignment(0, -0.5),
        ),
        Align(
          alignment: const Alignment(0, 0.5),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }

}
