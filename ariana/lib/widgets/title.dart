import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  const Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ARTIST",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Text(
              "Ariana Grande",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.white,
                  height: 10,
                  width: 10,
                ),
                const Icon(Icons.verified, color: Colors.blue),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: const [
            Text(
              "62,354,659",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Monthly listeners",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            )
          ],
        ),
      ],
    );
  }
}
