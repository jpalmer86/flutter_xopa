import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/common/text_icon_button.dart';
import 'package:xopa_app/pages/collaborate/add_user_to_collaboration_page.dart';
import 'package:xopa_app/pages/interests/interest_detail_bloc.dart';
import 'package:xopa_app/pages/search/tiles/user_tile.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/interests/interest.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';

class InterestDetailPage extends StatefulWidget {
  final Interest interest;

  InterestDetailPage(this.interest);

  @override
  _InterestDetailPageState createState() => _InterestDetailPageState();
}

class _InterestDetailPageState extends State<InterestDetailPage> {
  InterestDetailBloc _interestDetailBloc;

  @override
  void initState() {
    _interestDetailBloc = new InterestDetailBloc();
    _interestDetailBloc.add(FetchInterestDetail(widget.interest));
    super.initState();
  }

  @override
  void dispose() {
    _interestDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: Text(widget.interest.name)),
      body: SafeArea(
        child: BlocBuilder(
          bloc: _interestDetailBloc,
          builder: (context, InterestDetailState state) {
            if (state is LoadingInterestDetail) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ErrorFetchingInterestDetail) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is FetchedInterestDetail) {
              if (state.usersForInterest.length == 0) {
                return const Center(
                  child: Text('No users found'),
                );
              }

              return ListView.builder(
                itemCount: state.usersForInterest.length,
                itemBuilder: (_, index) {
                  return UserTile(
                    userAndInterest: state.usersForInterest[index],
                    primaryActions: [
                      if (state.usersForInterest[index].userId != Client.userId)
                        TextIconButton(
                          icon: Icon(Icons.people),
                          text: 'Collaborate',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AddUserToCollaborationPage(
                                state.usersForInterest[index].userId,
                              ),
                            ));
                          },
                        ),
                    ],
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
