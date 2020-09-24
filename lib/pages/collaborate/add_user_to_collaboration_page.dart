import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/collaborate/add_user_to_collaboration_bloc.dart';
import 'package:xopa_app/pages/collaborate/collaborate_bloc.dart';
import 'package:xopa_app/pages/collaborate/tiles/collaboration_tile.dart';
import 'package:xopa_app/pages/home_page.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:xopa_app/theme/widgets/themed_dialog.dart';

class AddUserToCollaborationPage extends StatefulWidget {
  final String userId;

  AddUserToCollaborationPage(this.userId);

  @override
  _AddUserToCollaborationPageState createState() =>
      _AddUserToCollaborationPageState();
}

class _AddUserToCollaborationPageState
    extends State<AddUserToCollaborationPage> {
  CollaborationsBloc _collaborationsBloc;
  AddUserToCollaborationBloc _addUserToCollaborationBloc;

  @override
  void initState() {
    _collaborationsBloc = new CollaborationsBloc();
    _collaborationsBloc.add(FetchCollaborations());
    _addUserToCollaborationBloc = new AddUserToCollaborationBloc();
    _addUserToCollaborationBloc.listen((AddUserToCollaborationState state) {
      if (state is AddedUser) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomePage(
              initialIndex: 0,
            ),
          ),
        );
      }

      if (state is ErrorAddingUserToCollaboration) {
        showDialog(
            context: context,
            builder: (_) {
              return ThemedDialog.dialog(
                context: context,
                title: const Text('Error Adding User to Collaboration'),
                content: Text(state.message),
              );
            });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _collaborationsBloc.close();
    _addUserToCollaborationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: const Text('Select Collaboration'),
      ),
      body: SafeArea(
        child: BlocBuilder(
          bloc: _collaborationsBloc,
          builder: (_, CollaborationsState state) {
            if (state is LoadingCollaborations) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ErrorFetchingCollaborations) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is FetchedCollaborations) {
              if (state.collaborations.isEmpty) {
                return const Center(
                  child: Text('No Available Collaborations'),
                );
              }
              return ListView.builder(
                itemCount: state.collaborations.length,
                itemBuilder: (_, index) {
                  final collaboration = state.collaborations[index];

                  //We can't add a user to a collaboration they are already in...
                  if (collaboration.users.indexWhere(
                          (portfolio) => portfolio.userId == widget.userId) !=
                      -1) return Container();

                  return CollaborationTile(
                    onTap: () {
                      _addUserToCollaborationBloc.add(
                        AddUserToCollaborationEvent(
                          collaboration.id,
                          widget.userId,
                        ),
                      );
                    },
                    collaboration: state.collaborations[index],
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
