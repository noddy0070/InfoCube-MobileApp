import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularImageWidget extends StatelessWidget {
  final double size;
  final double width;
  final String imageurl;
  final Color widthcolor;
  const CircularImageWidget(
      {super.key,
      this.size = 100,
      this.width = 3,
      this.widthcolor = const Color.fromARGB(255, 6, 6, 6),
      this.imageurl = 'assets/images/defaultprofile.jpg'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + (size * .1), // Adjust the width and height as needed
      height: size + (size * .1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widthcolor, // Border color
          width: width, // Border width
        ),
      ),
      child: ClipOval(
        child: Container(
          width: size, // Adjust the width and height as needed
          height: size,
          color: const Color.fromARGB(255, 230, 244,
              255), // You can set the background color of the circle
          child: Center(
            child: Image.asset(
              imageurl,
              width: 120.0,
              height: 120.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularImageWidget2 extends StatelessWidget {
  final double size;
  final double width;
  final String imageurl;
  final Color widthcolor;
  const CircularImageWidget2(
      {super.key,
      this.size = 100,
      this.width = 3,
      this.imageurl = 'assets/images/defaultprofile.jpg',
      this.widthcolor = const Color.fromARGB(255, 6, 6, 6)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + (size * .1), // Adjust the width and height as needed
      height: size + (size * .1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widthcolor, // Border color
          width: width, // Border width
        ),
      ),
      child: ClipOval(
        child: Container(
          width: size, // Adjust the width and height as needed
          height: size,
          color: const Color.fromARGB(255, 230, 244,
              255), // You can set the background color of the circle
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageurl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularImageWidget3 extends StatelessWidget {
  final double size;
  final double width;
  final File imagefile;
  final Color widthcolor;
  const CircularImageWidget3(
      {super.key,
      this.size = 100,
      this.width = 3,
      required this.imagefile,
      this.widthcolor = const Color.fromARGB(255, 6, 6, 6)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + (size * .1), // Adjust the width and height as needed
      height: size + (size * .1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widthcolor, // Border color
          width: width, // Border width
        ),
      ),
      child: ClipOval(
        child: Container(
          width: size, // Adjust the width and height as needed
          height: size,
          color: const Color.fromARGB(255, 230, 244,
              255), // You can set the background color of the circle
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Center(
              child: Image.file(
                imagefile,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
