import 'dart:math';

import 'package:ariana/widgets/choice_tab.dart';
import 'package:ariana/widgets/models.dart';
import 'package:ariana/widgets/song_tile.dart';
import 'package:ariana/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ariana Grande',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: const MyHomePage(),
    );
  }
}

const coverImage =
    "https://cdn-s-www.ledauphine.com/images/C4A2656A-FDD7-40A0-A8F3-414D00B3A519/NW_raw/ariana-grande-en-janvier-2020-photo-frazer-harrison-getty-images-for-the-recording-academy-afp-1621312560.jpg";

const expandedHeight = 240.0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ScrollController();
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _offset = min(max(0, _controller.offset / 6 - 16), 32);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: 90,
            stretch: true,
            backgroundColor: Colors.black,
            foregroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Image.network(
                  coverImage,
                  fit: BoxFit.cover,
                ),
                expandedTitleScale: 1,
                titlePadding: const EdgeInsets.all(24),
                title: const Title(),
              ),
            ),
          ),
          // Used to get the stretch effect to not be above the SliverAppBar
          const SliverToBoxAdapter(),
          SliverAppBar(
            backgroundColor: Colors.black,
            toolbarHeight: _offset + kToolbarHeight,
            title: Column(
              children: [
                SizedBox(height: _offset),
                const ChoiceTab(),
              ],
            ),
            primary: false,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SongTile(
                  index: index,
                );
              },
              childCount: listArianaGrandeAlbums.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
