import 'package:flutter/material.dart';
import 'package:xopa_app/theme/theme.dart';

class ThemedDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  ThemedDialog({this.title, this.content, this.actions});

  ThemedDialog.dialog({
    @required BuildContext context,
    this.title,
    this.content,
    void Function() onConfirm,
  }) : this.actions = <Widget>[
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
          ),
        ];

  ThemedDialog.confirmation({
    @required BuildContext context,
    this.title,
    this.content,
    void Function() onConfirm,
  }) : this.actions = <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppTheme.roundedBoxShape,
      title: title,
      content: content,
      actions: actions,
    );
  }
}
