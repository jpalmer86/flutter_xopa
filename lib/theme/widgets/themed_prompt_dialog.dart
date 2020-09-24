import 'package:flutter/material.dart';
import 'package:xopa_app/theme/theme.dart';
import 'package:xopa_app/theme/widgets/themed_textfield.dart';

class ThemedPromptDialog extends StatefulWidget {
  final String initialText;
  final bool Function(String value) isValid;
  final String title;
  final String promptLabel;
  final bool multiline;

  ThemedPromptDialog({
    this.initialText = '',
    this.isValid,
    this.title = '',
    this.promptLabel = '',
    this.multiline = false,
  });

  @override
  _ThemedPromptDialogState createState() => _ThemedPromptDialogState();
}

class _ThemedPromptDialogState extends State<ThemedPromptDialog> {
  TextEditingController _promptController;
  bool _valid;

  @override
  void initState() {
    _promptController = new TextEditingController(text: widget.initialText);
    _promptController.addListener(() {
      setState(() {
        _valid = _isValid(_promptController.text);
      });
    });
    _valid = _isValid(widget.initialText);
    super.initState();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  bool _isValid(String text) {
    if (widget.isValid != null)
      return widget.isValid(text);
    else
      return text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppTheme.roundedBoxShape,
      title: Text(widget.title),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ThemedTextField(
          controller: _promptController,
          label: widget.promptLabel,
          multiline: widget.multiline,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('Save'),
          onPressed: _valid
              ? () {
                  Navigator.of(context).pop(_promptController.text);
                }
              : null,
        ),
      ],
    );
  }
}
