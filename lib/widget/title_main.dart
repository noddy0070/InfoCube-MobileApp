import 'package:flutter/material.dart';

class TitleMain extends StatelessWidget {
  final Color color;
  const TitleMain({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(children: [
          // Title Name --------------------------------------------------------------------------------------------------
          SizedBox(
            height: .15 * MediaQuery.of(context).size.height,
            child: Text(
              "InfoCube",
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.bold,
                fontFamily: "Iceland",
                color: color,
              ),
            ),
          ),
        ]));
  }
}
