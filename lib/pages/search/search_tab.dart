import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/search/search_bloc.dart';
import 'package:xopa_app/pages/search/tiles/interest_tile.dart';

class SearchTab extends StatefulWidget {

  SearchTab({Key key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  SearchBloc _searchBloc;

  @override
  void initState() {
    final savedState =
        PageStorage.of(context).readState(context, identifier: widget.key);
    if (savedState != null) {
      _searchBloc = new SearchBloc(initialState: savedState);
    } else {
      _searchBloc = new SearchBloc();
      _searchBloc.add(FetchSearch());
    }
    _searchBloc.listen((SearchState state) {
      PageStorage.of(context)
          .writeState(context, state, identifier: widget.key);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _searchBloc,
      builder: (context, SearchState state) {
        if (state is LoadingSearch) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ErrorFetchingSearch) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is FetchedSearch) {
          return ListView.builder(
            itemCount: state.interests.length,
            itemBuilder: (context, index) {
              return InterestTile(state.interests[index]);
            },
          );
        }

        return Container();
      },
    );
  }
}
