import 'package:flutter/material.dart';

class ChoiceTab extends StatelessWidget {
  const ChoiceTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: TabBar(
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.white,
        tabs: [
          Tab(text: 'Popular'),
          Tab(text: 'Albums'),
          Tab(text: 'Songs'),
          Tab(text: 'Fans also like'),
        ],
      ),
    );
  }
}
