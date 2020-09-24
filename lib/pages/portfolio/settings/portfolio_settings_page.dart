import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/common/media_grid.dart';
import 'package:xopa_app/pages/home_page.dart';
import 'package:xopa_app/pages/portfolio/settings/portfolio_settings_bloc.dart';
import 'package:xopa_app/pages/portfolio/settings/portfolio_social_media_settings_bloc.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/repository/models/portfolio/social_media.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';
import 'package:xopa_app/theme/widgets/themed_dialog.dart';
import 'package:xopa_app/theme/widgets/themed_textfield.dart';

class PortfolioSettingsPage extends StatefulWidget {
  final Portfolio initialPortfolio;

  PortfolioSettingsPage(this.initialPortfolio);

  @override
  _PortfolioSettingsPageState createState() => _PortfolioSettingsPageState();
}

class _PortfolioSettingsPageState extends State<PortfolioSettingsPage> {
  PortfolioSettingsBloc _portfolioSettingsBloc;
  PortfolioSocialMediaSettingsBloc _portfolioSocialMediaSettingsBloc;

  TextEditingController _fbController;
  TextEditingController _liController;
  TextEditingController _twController;

  @override
  void initState() {
    _portfolioSettingsBloc = new PortfolioSettingsBloc();
    _portfolioSettingsBloc.add(FetchPortfolioSettings(widget.initialPortfolio));
    _portfolioSocialMediaSettingsBloc = new PortfolioSocialMediaSettingsBloc();
    _portfolioSocialMediaSettingsBloc
        .listen((PortfolioSocialMediaSettingsState state) {
      if (state is FormError) {
        showDialog(
            context: context,
            builder: (_) => ThemedDialog.dialog(
                  context: context,
                  title: const Text('Error saving social media'),
                  content: Text(state.message),
                ));
      }

      if (state is Success) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => HomePage(),
        ));
      }
    });

    _fbController = new TextEditingController(
        text: widget.initialPortfolio.socialMedia.facebookUsername);
    _liController = new TextEditingController(
        text: widget.initialPortfolio.socialMedia.linkedinUsername);
    _twController = new TextEditingController(
        text: widget.initialPortfolio.socialMedia.twitterUsername);

    super.initState();
  }

  @override
  void dispose() {
    _portfolioSettingsBloc.close();
    _portfolioSocialMediaSettingsBloc.close();
    _fbController.dispose();
    _liController.dispose();
    _twController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: const Text('Portfolio Settings')),
      body: WillPopScope(
        onWillPop: () {
          //We need to pass down the new portfolio to the profile page so it doesn't
          //have to do a redundant network call to get the latest version.
          final currentState = _portfolioSettingsBloc.state;
          if (currentState is FetchedPortfolioSettings) {
            Navigator.of(context).pop(currentState.currentPortfolio);
          } else {
            Navigator.of(context).pop();
          }
          return Future(() => false);
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BlocBuilder(
                bloc: _portfolioSettingsBloc,
                builder: (context, PortfolioSettingsState state) {
                  final public = state is FetchedPortfolioSettings &&
                      state.currentPortfolio.public;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Switch.adaptive(
                          value: public,
                          onChanged: (value) {
                            _portfolioSettingsBloc
                                .add(TogglePortfolioPublicity(value));
                          }),
                      const SizedBox(width: 4),
                      Text(public
                          ? 'Portfolio is public'
                          : 'Make portfolio public'),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const Text('Social Media Profiles'),
                    ThemedTextField(
                      controller: _fbController,
                      label: 'https://facebook.com/',
                      hint: 'Username',
                    ),
                    const SizedBox(height: 8),
                    ThemedTextField(
                      controller: _twController,
                      label: 'https://twitter.com/',
                      hint: 'Username',
                    ),
                    const SizedBox(height: 8),
                    ThemedTextField(
                      controller: _liController,
                      label: 'https://linkedin.com/in/',
                      hint: 'Username',
                    ),
                    const SizedBox(height: 8),
                    ThemedButton(
                      child: const Text('Save Social Media'),
                      onPressed: () {
                        _portfolioSocialMediaSettingsBloc
                            .add(SubmitPortfolioSocialMediaSettings(
                          SocialMedia(
                            facebookUsername: _fbController.text,
                            twitterUsername: _twController.text,
                            linkedinUsername: _liController.text,
                          ),
                        ));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder(
                  bloc: _portfolioSettingsBloc,
                  builder: (context, PortfolioSettingsState state) {
                    if (state is LoadingPortfolioSettings) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is ErrorFetchingPortfolioSettings) {
                      return Center(
                        child: Text(state.message),
                      );
                    }

                    if (state is FetchedPortfolioSettings) {
                      return MediaGrid(
                        state.allMedia,
                        scrollable: true,
                        onTap: (item, selected) {
                          if (selected) {
                            _portfolioSettingsBloc
                                .add(RemovePortfolioMedia(item));
                          } else {
                            _portfolioSettingsBloc.add(AddPortfolioMedia(item));
                          }
                        },
                        selectedMedia: state.currentPortfolio.media.toSet(),
                      );
                    }

                    return Container();
                  },
                ),
              ),
//              const SizedBox(height: 16),
//                BlocBuilder(
//                  bloc: _portfolioSettingsBloc,
//                  builder: (context, PortfolioSettingsState state) {
//                    if (state is FetchedPortfolioSettings) {
//                      final linked = state.currentPortfolio.instagramUsername.isNotEmpty;
//                      if(!linked) return Container();
//
//                      return ThemedButton.icon(
//                        icon: const ImageIcon(
//                            AssetImage('assets/images/instagram.png')),
//                        label: Text(linked
//                            ? 'Unlink Instagram Account'
//                            : 'Link Instagram Account'),
//                        filled: false,
//                        onPressed: () async {
//                          if (linked) {
//                            showDialog(
//                              context: context,
//                              builder: (context) => ThemedDialog.confirmation(
//                                context: context,
//                                title: const Text('Are you sure?'),
//                                content: const Text('Are you sure you would like to unlink your Instagram account?'),
//                                onConfirm: () {
//                                  _portfolioSettingsBloc.add(UnlinkInstagramAccount());
//                                },
//                              ),
//                            );
//                          }
//                        },
//                      );
//                    }
//                    return Container();
//                  },
//                ),
            ],
          ),
        ),
      ),
    );
  }
}
