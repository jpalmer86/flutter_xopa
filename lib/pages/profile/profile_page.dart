import 'package:flutter/material.dart';
import 'package:xopa_app/pages/profile/profile_tab.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';

class ProfilePage extends StatelessWidget {

  final String portfolioId;

  ProfilePage(this.portfolioId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: const Text('Xopa'),
      ),
      body: ProfileTab(portfolioId: portfolioId),
    );
  }

}
