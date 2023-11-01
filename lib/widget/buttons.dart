import 'package:flutter/material.dart';

class InterestBtn extends StatefulWidget {
  final double width;
  final VoidCallback fnc;
  final String title;
  final Color color;
  const InterestBtn(
      {super.key,
      required this.width,
      required this.fnc,
      required this.title,
      this.color = Colors.redAccent});
  @override
  State<InterestBtn> createState() => _InterestBtnState();
}

class _InterestBtnState extends State<InterestBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 50,
            width: widget.width,
            child: ElevatedButton(
                onPressed: widget.fnc,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 25,
                  shadowColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: widget.color,
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))),
      ],
    );
  }
}

class MainBtn extends StatefulWidget {
  final double width;
  final VoidCallback fnc;
  final String title;
  final Color color;
  final Color bordercolor;
  final TextStyle textStyle;
  final double height;
  final double elevation;
  const MainBtn(
      {super.key,
      required this.width,
      required this.fnc,
      required this.title,
      this.height = 50,
      this.elevation = 25,
      this.color = const Color.fromARGB(255, 227, 117, 117),
      this.bordercolor = const Color.fromARGB(255, 227, 117, 117),
      this.textStyle = const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)});
  @override
  State<MainBtn> createState() => _MainBtnState();
}

class _MainBtnState extends State<MainBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: widget.height,
            width: widget.width,
            child: ElevatedButton(
                onPressed: widget.fnc,
                style: ElevatedButton.styleFrom(
                    elevation: widget.elevation,
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: widget.color,
                    side: BorderSide(color: widget.bordercolor)),
                child: Text(
                  widget.title,
                  style: widget.textStyle,
                ))),
      ],
    );
  }
}
