import 'package:flutter/material.dart';
import 'package:xopa_app/pages/home_page.dart';
import 'package:xopa_app/pages/interests/edit_interests_page.dart';
import 'package:xopa_app/pages/loading/loading_bloc.dart';
import 'package:xopa_app/pages/onboarding/login/login_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  LoadingBloc _loadingBloc;

  @override
  void initState() {
    _loadingBloc = new LoadingBloc();

    _loadingBloc.listen((LoadingState state) {
      if (state is Loaded) {
        if (state.loggedIn) {
          if(state.needsToSetInterests) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => EditInterestsPage(),
              )
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomePage(),
              )
            );
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => LoginPage(),
            ),
          );
        }
      }
    });

    _loadingBloc.add(Load());
    super.initState();
  }

  @override
  void dispose() {
    _loadingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Text(
                'Xopa',
                style: Theme.of(context).primaryTextTheme.headline1,
              ),
              const SizedBox(height: 15),
              Text(
                'Collaborate with Creators.',
                style: Theme.of(context).primaryTextTheme.headline6,
              ),
              const SizedBox(height: 50),
              Icon(
                Icons.offline_bolt,
                size: 200,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
