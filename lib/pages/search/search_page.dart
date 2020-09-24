import 'package:flutter/material.dart';
import 'package:xopa_app/pages/search/search_tab.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: const Text('Search'),
      ),
      body: SearchTab(),
    );
  }
}
