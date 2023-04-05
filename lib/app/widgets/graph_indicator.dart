import 'package:flutter/material.dart';

class GraphIndicator extends StatelessWidget {
  const GraphIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: Colors.red,
            ),
            const SizedBox(width: 5),
            Text("X")
          ],
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: Colors.green,
            ),
            const SizedBox(width: 5),
            Text("Y")
          ],
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: Colors.blue,
            ),
            const SizedBox(width: 5),
            Text("Z")
          ],
        ),
      ],
    );
  }
}
