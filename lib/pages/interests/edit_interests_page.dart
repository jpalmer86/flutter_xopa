import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/interests/add_interest_page.dart';
import 'package:xopa_app/pages/interests/edit_interests_bloc.dart';
import 'package:xopa_app/pages/loading/loading_page.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';

class EditInterestsPage extends StatefulWidget {
  @override
  _EditInterestsPageState createState() => _EditInterestsPageState();
}

class _EditInterestsPageState extends State<EditInterestsPage> {
  EditInterestsBloc _editInterestsBloc;

  @override
  void initState() {
    _editInterestsBloc = new EditInterestsBloc();
    _editInterestsBloc.listen(_blocListener);
    _editInterestsBloc.add(FetchEditInterests(''));
    super.initState();
  }

  @override
  void dispose() {
    _editInterestsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: const Text('Select Skills'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder(
                bloc: _editInterestsBloc,
                builder: (context, EditInterestsState state) {
                  if (state is LoadingEditInterests) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is FetchedEditInterests) {
                    return ListView.builder(
                      itemCount: state.allInterests.length,
                      itemBuilder: (context, i) {
                        return interestItemBuilder(context, state, i);
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder(
                bloc: _editInterestsBloc,
                builder: (context, EditInterestsState state) {
                  return ThemedButton(
                    child: const Text('Save'),
                    expanded: true,
                    filled: true,
                    onPressed: (state is FetchedEditInterests &&
                            state.selectedInterests.length > 0)
                        ? () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) => LoadingPage(),
                            ));
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget interestItemBuilder(
    BuildContext context,
    FetchedEditInterests state,
    int index,
  ) {
    final interest = state.allInterests[index];

    return OpenContainer(
      tappable: false,
      closedBuilder: (_, open) => CheckboxListTile(
        title: Text(interest.name),
        onChanged: (isSelected) {
          if (isSelected) {
            open();
          } else {
            _editInterestsBloc.add(DeselectInterest(interest.toUserInterest()));
          }
        },
        value: state.selectedInterests.contains(interest.toUserInterest()),
      ),
      openBuilder: (_, close) => AddInterestPage(
        interest: interest,
        onAdd: (userInterest) {
          _editInterestsBloc.add(SelectInterest(userInterest));
          close();
        }
      ),
    );
  }

  void _blocListener(EditInterestsState state) {
    if (state is ErrorFetchingEditInterests) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(state.message),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }
}
