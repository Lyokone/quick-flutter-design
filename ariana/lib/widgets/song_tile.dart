import 'package:ariana/widgets/models.dart';
import 'package:flutter/material.dart';

class SongTile extends StatefulWidget {
  const SongTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final album = listArianaGrandeAlbums[widget.index];

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('#${widget.index + 1}',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[400]!,
                )),
            const SizedBox(
              width: 12,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                album.albumCoverUrl,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        title: Text(
          album.albumName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(children: [
            Icon(
              Icons.headphones,
              color: Colors.grey[400]!,
              size: 15,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              '63,527,129',
              style: TextStyle(
                color: Colors.grey[400]!,
                fontSize: 13,
              ),
            )
          ]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selected = !selected;
                });
              },
              icon: Icon(
                selected ? Icons.favorite : Icons.favorite_border,
                color: selected ? Colors.green : Colors.white,
              ),
            ),
            const Icon(
              Icons.more_horiz,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
