import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/collaborate/collaborate_bloc.dart';
import 'package:xopa_app/pages/collaborate/collaboration_detail_page.dart';
import 'package:xopa_app/pages/collaborate/tiles/collaboration_tile.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';
import 'package:xopa_app/theme/widgets/themed_prompt_dialog.dart';

class CollaboratePage extends StatefulWidget {
  CollaboratePage({Key key}) : super(key: key);

  @override
  _CollaboratePageState createState() => _CollaboratePageState();
}

class _CollaboratePageState extends State<CollaboratePage> {
  CollaborationsBloc _collaborationsBloc;

  @override
  void initState() {
    final state =
        PageStorage.of(context).readState(context, identifier: widget.key);
    if (state != null) {
      _collaborationsBloc = new CollaborationsBloc(initialState: state);
    } else {
      _collaborationsBloc = new CollaborationsBloc();
      _collaborationsBloc.add(FetchCollaborations());
    }
    _collaborationsBloc.listen((CollaborationsState state) {
      PageStorage.of(context)
          .writeState(context, state, identifier: widget.key);
    });
    super.initState();
  }

  @override
  void dispose() {
    _collaborationsBloc.close();
    super.dispose();
  }

  void _showAddCollaborationDialog(BuildContext context) async {
    final newCollaborationName = await showDialog(
      context: context,
      builder: (_) => ThemedPromptDialog(
        title: 'New Collaboration',
        promptLabel: 'Collaboration Name',
      ),
    );
    if (newCollaborationName != null) {
      _collaborationsBloc.add(NewCollaboration(newCollaborationName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: BlocBuilder(
              bloc: _collaborationsBloc,
              builder: (context, CollaborationsState state) {
                if (state is LoadingCollaborations) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is FetchedCollaborations) {
                  if (state.collaborations.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No collaborations yet.\nClick "New Collaboration" below to get started!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.collaborations.length,
                    itemBuilder: (context, index) {
                      return OpenContainer(
                        transitionType: ContainerTransitionType.fadeThrough,
                        closedBuilder: (context, open) {
                          return CollaborationTile(
                            onTap: open,
                            collaboration: state.collaborations[index],
                          );
                        },
                        openBuilder: (_, __) {
                          return CollaborationDetailPage(
                            state.collaborations[index],
                          );
                        },
                      );
                    },
                  );
                }

                if (state is ErrorFetchingCollaborations) {
                  return Center(child: Text(state.message));
                }

                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ThemedButton.icon(
              icon: Icon(Icons.group_add),
              label: const Text('New Collaboration'),
              onPressed: () {
                _showAddCollaborationDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
