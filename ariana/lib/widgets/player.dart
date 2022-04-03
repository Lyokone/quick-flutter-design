import 'dart:math';

import 'package:ariana/widgets/models.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    Key? key,
    required this.percentageOpen,
  }) : super(key: key);

  final double percentageOpen;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final imageHeight = 64 + (percentageOpen * height * 0.5);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.grey[900],
            height: height,
          ),
          Opacity(
            opacity: max(0, 1 - (percentageOpen * 4)),
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 64),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Thank u, Next',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ariana Grande',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {},
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {},
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Opacity(
            opacity: percentageOpen > 0.5
                ? min(1, max(0, percentageOpen - 0.5) * 2)
                : 0,
            child: Column(
              children: [
                SizedBox(
                  height: imageHeight * 0.9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.thumb_down_alt_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    Column(
                      children: [
                        const Text(
                          'Thank u, Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ariana Grande',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.thumb_up_alt_outlined,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0:00',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        '3:27',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.shuffle,
                        size: 32,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.skip_previous,
                        size: 32,
                        color: Colors.white,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.play_arrow,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.skip_next,
                        size: 32,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.repeat,
                        size: 32,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: imageHeight,
            padding: const EdgeInsets.all(8.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
              child: Image.network(listArianaGrandeAlbums[1].albumCoverUrl),
            ),
          ),
        ],
      ),
    );
  }
}
