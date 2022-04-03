import 'dart:math';

import 'package:ariana/widgets/choice_tab.dart';
import 'package:ariana/widgets/expandable.dart';
import 'package:ariana/widgets/models.dart';
import 'package:ariana/widgets/player.dart';
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
      debugShowCheckedModeBanner: false,
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
  late final double _maxSizeBottomNavigationBar =
      MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

  late double _percentageOpen = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(moveOffset);
  }

  moveOffset() {
    setState(() {
      _offset = min(max(0, _controller.offset / 6 - 16), 32);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(moveOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: SizedBox(
        height: max(0, (1 - _percentageOpen) * _maxSizeBottomNavigationBar),
        child: SingleChildScrollView(
          child: BottomNavigationBar(
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.grey[900],
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined),
                  label: 'Library',
                ),
              ]),
        ),
      ),
      body: ExpandableBottomSheet(
        background: CustomScrollView(
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
        persistentContentHeight: 64,
        expandableContent: Player(percentageOpen: _percentageOpen),
        onOffsetChanged: (offset, minOffset, maxOffset) {
          if (maxOffset == null || offset == null || minOffset == null) {
            return;
          }
          final range = maxOffset - minOffset;
          final currentOffset = offset - minOffset;
          setState(() {
            _percentageOpen = max(0, 1 - (currentOffset / range));
          });
        },
        enableToggle: true,
        isDraggable: true,
      ),
    );
  }
}
