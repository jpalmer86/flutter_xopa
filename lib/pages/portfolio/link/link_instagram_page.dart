import 'package:flutter/material.dart';
import 'package:xopa_app/pages/portfolio/link/link_instagram_bloc.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LinkInstagramPage extends StatefulWidget {
  @override
  _LinkInstagramPageState createState() => _LinkInstagramPageState();
}

class _LinkInstagramPageState extends State<LinkInstagramPage> {
  LinkInstagramBloc _linkInstagramBloc;

  @override
  void initState() {
    _linkInstagramBloc = new LinkInstagramBloc();
    _linkInstagramBloc.listen((LinkInstagramState state) {
      if (state is ErrorLinkingInstagram) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error linking Instagram Account'),
              content: Text(state.message),
              actions: [
                FlatButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    //Close the dialog
                    Navigator.of(context).pop();

                    //Close this page and tell the calling page that things failed.
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          },
        );
      }

      if (state is SuccessfullyLinkedInstagram) {
        Navigator.of(context).pop(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _linkInstagramBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: const Text('Link Instagram Account')),
      body: SafeArea(
        child: WebView(
          initialUrl:
              'https://api.instagram.com/oauth/authorize?client_id=1137801439912294&redirect_uri=https://koze-app.github.io/koze_website/auth/&scope=user_profile,user_media&response_type=code',
          onPageStarted: (url) {
            if (url.startsWith(
                'https://koze-app.github.io/koze_website/auth/?code=')) {
              final authCode = url
                  .replaceFirst(
                      'https://koze-app.github.io/koze_website/auth/?code=', '')
                  .replaceFirst('#_', '');
              _linkInstagramBloc.add(SubmitAuthCode(authCode));
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (error) {
            print(error.description);
          },
        ),
      ),
    );
  }
}
