import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/messages/create_conversation_page.dart';
import 'package:xopa_app/pages/portfolio/portfolio_section.dart';
import 'package:xopa_app/pages/portfolio/settings/portfolio_settings_page.dart';
import 'package:xopa_app/pages/profile/profile_bloc.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/conversation/group.dart';
import 'package:xopa_app/theme/widgets/themed_prompt_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileTab extends StatefulWidget {
  final String portfolioId;

  ProfileTab({Key key, this.portfolioId = ''}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileTab> {
  ProfileBloc _profileBloc;

  @override
  void initState() {
    final state =
        PageStorage.of(context).readState(context, identifier: widget.key);
    if (state != null) {
      _profileBloc = new ProfileBloc(initialState: state);
    } else {
      _profileBloc = new ProfileBloc();
      _profileBloc.add(FetchProfile(widget.portfolioId));
    }
    _profileBloc.listen((ProfileState state) {
      PageStorage.of(context)
          .writeState(context, state, identifier: widget.key);
      if (state is ErrorSavingProfile) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error saving profile'),
                content: Text(state.message),
              );
            });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            BlocBuilder(
              bloc: _profileBloc,
              builder: (context, ProfileState state) => Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (state is FetchedProfile &&
                      state.portfolio.instagramUsername.isNotEmpty)
                    Align(
                      alignment: const Alignment(0.65, 0),
                      child: IconButton(
                        icon: const ImageIcon(
                            AssetImage('assets/images/instagram.png'),
                            size: 32),
                        onPressed: () {
                          launch(
                              'https://instagram.com/${state.portfolio.instagramUsername}/');
                        },
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: _buildUserAvatar(state),
                  ),
                  if (widget.portfolioId.isNotEmpty &&
                      widget.portfolioId != Client.userId)
                    Align(
                      alignment: const Alignment(-0.65, 0),
                      child: IconButton(
                        icon: Icon(Icons.message, size: 32),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CreateConversationPage(
                                Group(ids: [Client.userId, widget.portfolioId]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder(
              bloc: _profileBloc,
              builder: (context, ProfileState state) {
                if (state is LoadingProfile) {
                  return Container(height: 24);
                }

                if (state is FetchedProfile) {
                  return Text(
                    state.portfolio.name,
                    style: Theme.of(context).textTheme.headline6,
                  );
                }

                return Container();
              },
            ),
            const SizedBox(height: 24),
            Material(
              color: Theme.of(context).colorScheme.secondary,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BlocBuilder(
                          bloc: _profileBloc,
                          builder: (context, ProfileState state) => BorderTitle(
                            'ABOUT ME',
                            color: Theme.of(context).colorScheme.onSecondary,
                            actions: [
                              if ((widget.portfolioId.isEmpty ||
                                      widget.portfolioId == Client.userId) &&
                                  state is FetchedProfile)
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                  onPressed: () async {
                                    final newBio = await showDialog(
                                      context: context,
                                      builder: (_) => ThemedPromptDialog(
                                        initialText: state.portfolio.bio,
                                        title: 'Edit Bio',
                                        promptLabel: 'Bio',
                                        multiline: true,
                                      ),
                                    );
                                    if (newBio != null) {
                                      _profileBloc.add(EditBio(newBio));
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder(
                        bloc: _profileBloc,
                        builder: (context, ProfileState state) {
                          if (state is LoadingProfile) {
                            return Container();
                          }

                          if (state is FetchedProfile) {
                            return Text(
                              state.portfolio.bio,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).accentTextTheme.bodyText1,
                            );
                          }

                          if (state is ErrorFetchingProfile) {
                            return Text(
                              'Error fetching profile: ${state.message}',
                              style:
                                  Theme.of(context).accentTextTheme.bodyText1,
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder(
                      bloc: _profileBloc,
                      builder: (context, ProfileState state) {
                        if (state is FetchedProfile) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (state.portfolio.instagramUsername?.isNotEmpty ?? false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: IconButton(
                                    icon: ImageIcon(
                                      const AssetImage(
                                          'assets/images/instagram.png'),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      launch('https://instagram.com/${state.portfolio.instagramUsername}/');
                                    },
                                  ),
                                ),
                              if (state.portfolio.socialMedia?.facebookUsername
                                      ?.isNotEmpty ??
                                  false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: IconButton(
                                    icon: ImageIcon(
                                      const AssetImage(
                                          'assets/images/facebook.png'),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      launch(
                                          'https://facebook.com/${state.portfolio.socialMedia.facebookUsername}/');
                                    },
                                  ),
                                ),
                              if (state.portfolio.socialMedia?.twitterUsername
                                      ?.isNotEmpty ??
                                  false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: IconButton(
                                    icon: ImageIcon(
                                      const AssetImage(
                                          'assets/images/twitter.png'),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      launch(
                                          'https://twitter.com/${state.portfolio.socialMedia.twitterUsername}/');
                                    },
                                  ),
                                ),
                              if (state.portfolio.socialMedia?.linkedinUsername
                                      ?.isNotEmpty ??
                                  false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: IconButton(
                                    icon: ImageIcon(
                                      const AssetImage(
                                          'assets/images/linkedin.png'),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      launch(
                                          'https://linkedin.com/in/${state.portfolio.socialMedia.linkedinUsername}/');
                                    },
                                  ),
                                ),
                            ],
                          );
                        }

                        return Container();
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder(
                bloc: _profileBloc,
                builder: (context, ProfileState state) => BorderTitle(
                  'PORTFOLIO',
                  actions: [
                    if ((widget.portfolioId.isEmpty ||
                            widget.portfolioId == Client.userId) &&
                        state is FetchedProfile &&
                        (state.portfolio.instagramUsername?.isNotEmpty ??
                            false))
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () async {
                          final newPortfolio = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (_) =>
                                PortfolioSettingsPage(state.portfolio),
                          ));
                          if (newPortfolio != null) {
                            _profileBloc.add(SetPortfolio(newPortfolio));
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            BlocBuilder(
              bloc: _profileBloc,
              builder: (context, ProfileState state) {
                if (state is LoadingProfile) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return PortfolioSection(
                  state is FetchedProfile ? state.portfolio : null,
                  state is FetchedProfile &&
                      (state.portfolio.instagramUsername?.isNotEmpty ?? false),
                  onRefresh: () {
                    _profileBloc.add(FetchProfile(widget.portfolioId));
                  },
                );
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(ProfileState state) {
    if (state is LoadingProfile) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: CircleAvatar(
          child: const CircularProgressIndicator(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 75,
        ),
      );
    }

    if (state is FetchedProfile) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: CachedNetworkImage(
          imageUrl: state.portfolio.profilePicture,
          imageBuilder: (context, provider) => CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage: provider,
            radius: 75,
          ),
          placeholder: (context, _) => CircleAvatar(
            child: const CircularProgressIndicator(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 75,
          ),
          errorWidget: (context, _, __) => CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 75,
          ),
          progressIndicatorBuilder: (context, _, progress) => CircleAvatar(
            child: CircularProgressIndicator(value: progress.progress),
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 75,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(32),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 75,
      ),
    );
  }
}

class BorderTitle extends StatelessWidget {
  final String text;
  final List<Widget> actions;
  final Color color;

  BorderTitle(this.text, {this.actions = const [], this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Text(
                text,
                style:
                    Theme.of(context).textTheme.overline.copyWith(color: color),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.85, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          ),
        )
      ],
    );
  }
}
