import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BubbleSpecialOne extends StatelessWidget {
  final bool isSender;
  final String text1;
  final String text2;
  final String text3;
  final String imageUrl;
  final bool tail;
  final Color color;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle1;
  final TextStyle textStyle2;
  final TextStyle textStyle3;
  final BoxConstraints? constraints;

  const BubbleSpecialOne({
    Key? key,
    this.isSender = true,
    this.constraints,
    this.text1 = "",
    this.text2 = "",
    required this.text3,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.imageUrl = "",
    this.textStyle1 = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.textStyle3 = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.textStyle2 = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon =const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon =const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon =const  Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text1.length > text2.length ? text1 : text2,
        style: const TextStyle(
            fontSize: 16.0,
            fontFamily: "Inter"), // You can adjust the font size as needed
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 210.0); // Set the maximum width
    double height = textPainter.height;

    double width = imageUrl.isEmpty ? textPainter.width + 60.0 : 300;

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: CustomPaint(
          painter: SpecialChatBubbleOne(
              color: color,
              alignment: isSender ? Alignment.topRight : Alignment.topLeft,
              tail: tail),
          child: Container(
            constraints: constraints ??
                BoxConstraints(
                  maxWidth: width,
                ),
            margin: isSender
                ? stateTick
                    ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                    : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                : const EdgeInsets.fromLTRB(17, 7, 7, 7),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: stateTick
                      ? const EdgeInsets.only(right: 20)
                      : const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text1 == ""
                          ? const SizedBox()
                          : Text(
                              text1,
                              style: textStyle1,
                              textAlign: TextAlign.left,
                            ),
                      imageUrl.isEmpty
                          ? const SizedBox()
                          :  Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                color: const Color.fromARGB(255, 131, 131, 131),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    width:
                                        MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )),
                      Stack(
                        fit: StackFit.loose,
                        children: [
                          text2.isEmpty
                              ? const SizedBox()
                              : Text(
                                  text2,
                                  style: textStyle2,
                                  textAlign: TextAlign.left,
                                ),
                          Column(
                            children: [
                              SizedBox(
                                height: height - 8,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  text3,
                                  style: textStyle3,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                stateIcon != null && stateTick
                    ? Positioned(
                        bottom: 0,
                        right: 0,
                        child: stateIcon,
                      )
                    : const SizedBox(
                        width: 1,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class SpecialChatBubbleOne extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleOne({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;
  final double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      canvas.drawShadow(Path(), Colors.grey, 10, false);
      canvas.drawPath(Path(), Paint()..color = Colors.pink);

      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.fill);
        var path =  Path();
        path.moveTo(size.width - _x, 0);
        path.lineTo(size.width - _x, 10);
        path.lineTo(size.width, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              size.width - _x,
              0.0,
              size.width,
              size.height,
              topRight:const  Radius.circular(3),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              _x,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
        var path =  Path();
        path.moveTo(_x, 0);
        path.lineTo(_x, 10);
        path.lineTo(0, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0.0,
              _x,
              size.height,
              topLeft: const Radius.circular(3),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              _x,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SpecialChatBubbleShape extends ShapeBorder {
  final bool tail;
  final double x;
  final double radius;


  const SpecialChatBubbleShape({
    required this.tail,
    required this.x,
    required this.radius,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();

    if (tail) {
      path.lineTo(rect.width - x, 0);
      path.lineTo(rect.width - x, 10);
      path.lineTo(rect.width, 0);
    }

    path.addRRect(RRect.fromLTRBAndCorners(
      tail ? 0 : x,
      0,
      tail ? rect.width : rect.width - x,
      rect.height,
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
      topLeft: Radius.circular(radius),
      topRight: tail ? const Radius.circular(3) : Radius.circular(radius),
    ));

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}
