import 'package:flutter/material.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/repository/models/interests/users_interest.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';
import 'package:xopa_app/theme/widgets/themed_textfield.dart';

class AddInterestPage extends StatefulWidget {
  final Interest interest;
  final void Function(UsersInterest interest) onAdd;

  AddInterestPage({
    @required this.interest,
    @required this.onAdd,
  });

  @override
  _AddInterestPageState createState() => _AddInterestPageState();
}

class _AddInterestPageState extends State<AddInterestPage> {
  UsersInterest _usersInterest;

  @override
  void initState() {
    _usersInterest = widget.interest.toUserInterest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: Text(widget.interest.name)),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FilterChip(
                    label: const Text('Providing Skill'),
                    selected: !_usersInterest.seeking,
                    onSelected: (_) {
                      setState(() {
                        _usersInterest.seeking = false;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Seeking Skill'),
                    selected: _usersInterest.seeking,
                    onSelected: (_) {
                      setState(() {
                        _usersInterest.seeking = true;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ThemedTextField(
                    multiline: true,
                    label: 'Vision',
                    hint: _usersInterest.seeking? "I'm looking for...": 'I would love to...',
                    onChanged: (value) {
                      _usersInterest.comment = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ThemedButton.icon(
                  onPressed: () {
                    widget.onAdd?.call(_usersInterest);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: const Text('Add Interest'),
                  filled: true,
                  expanded: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
