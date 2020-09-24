import 'package:flutter/material.dart';
import 'package:xopa_app/common/media_grid.dart';
import 'package:xopa_app/pages/portfolio/link/link_instagram_page.dart';
import 'package:xopa_app/repository/client.dart';
import 'package:xopa_app/repository/models/portfolio/portfolio.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';

class PortfolioSection extends StatelessWidget {
  final Portfolio portfolio;
  final bool instagramLinked;
  final VoidCallback onRefresh;

  PortfolioSection(
    this.portfolio,
    this.instagramLinked, {
    @required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          if (portfolio?.media?.isEmpty ?? true)
            const Text('No images yet!')
          else
            MediaGrid(portfolio?.media),
          if (!instagramLinked && Client.userId == portfolio?.userId)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ThemedButton.icon(
                icon: ImageIcon(const AssetImage('assets/images/instagram.png'),
                    color: Theme.of(context).colorScheme.onPrimary),
                label: Text('Link Instagram Account',
                    style: Theme.of(context).primaryTextTheme.button),
                onPressed: () async {
                  final linked =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LinkInstagramPage(),
                  ));
                  if (linked != null && linked) {
                    onRefresh();
                  }
                },
                filled: true,
                expanded: false,
              ),
            ),
        ],
      ),
    );
  }
}
