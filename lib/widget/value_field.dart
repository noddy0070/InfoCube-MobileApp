import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;

  const CustomText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromARGB(200, 0, 0, 0),
          ),
        ));
  }
}

class ValueField extends StatefulWidget {
  final IconData icon;
  final bool cond;
  final TextInputType keyType;
  final TextEditingController controller;
  final bool hideText;
  final String labeltext;
  const ValueField({
    super.key,
    this.icon = Icons.person,
    this.keyType = TextInputType.text,
    required this.controller,
    this.hideText = false,
    this.cond = true,
    this.labeltext = "",
  });

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(103, 27, 26, 26),
            Color.fromARGB(255, 255, 255, 255)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, .1],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      child: TextField(
        enabled: widget.cond,
        keyboardType: widget.keyType,
        controller: widget.controller,
        expands: false,
        obscureText: widget.hideText,
        style: const TextStyle(fontSize: 20.0, color: Colors.black54),
        decoration: InputDecoration(
          labelText: widget.labeltext,
          contentPadding: const EdgeInsets.all(12.0),
          prefixIcon: Icon(
            widget.icon,
            color: const Color.fromARGB(200, 0, 0, 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(161, 8, 8, 8)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(160, 106, 105, 105)),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

class ValueField2 extends StatefulWidget {
  final IconData icon;
  final bool cond;
  final TextInputType keyType;
  final TextEditingController controller;
  final bool hideText;
  final String labeltext;
  const ValueField2({
    super.key,
    this.icon = Icons.person,
    this.keyType = TextInputType.text,
    required this.controller,
    this.hideText = false,
    this.cond = true,
    this.labeltext = "",
  });

  @override
  State<ValueField2> createState() => _ValueField2State();
}

class _ValueField2State extends State<ValueField2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(103, 27, 26, 26),
            Color.fromARGB(255, 255, 255, 255)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, .1],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: widget.cond
              ? const BorderRadius.all(Radius.circular(20.0))
              : const BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: TextField(
        enabled: widget.cond,
        keyboardType: widget.keyType,
        controller: widget.controller,
        expands: false,
        obscureText: widget.hideText,
        style: const TextStyle(fontSize: 20.0, color: Colors.black54),
        decoration: InputDecoration(
          labelText: widget.labeltext,
          contentPadding: const EdgeInsets.all(12.0),
          prefixIcon: Icon(
            widget.icon,
            color: const Color.fromARGB(200, 0, 0, 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(161, 8, 8, 8)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(159, 215, 215, 215)),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
