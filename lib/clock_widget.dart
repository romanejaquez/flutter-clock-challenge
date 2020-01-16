import 'package:flutter/material.dart';

class DigitalClockWidget extends StatefulWidget {
  String hours;
  String minutes;
  String seconds;
  bool isTimeEllapsing = false;

  DigitalClockWidget({this.hours, this.minutes, this.seconds, this.isTimeEllapsing = true});

  @override
  DigitalClockWidgetState createState() => DigitalClockWidgetState();
}

class DigitalClockWidgetState extends State<DigitalClockWidget> {
  ValueNotifier<int> vNumber1 = ValueNotifier<int>(0);
  ValueNotifier<int> vNumber2 = ValueNotifier<int>(0);
  ValueNotifier<int> vNumber3 = ValueNotifier<int>(0);
  ValueNotifier<int> vNumber4 = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var firstHourDigit = widget.hours[0];
    var secondHourDigit = widget.hours[1];
    var thirdValue = widget.seconds[0];
    var fourthValue = widget.seconds[1];

    vNumber1.value = int.parse(firstHourDigit);
    vNumber2.value = int.parse(secondHourDigit);
    vNumber3.value = int.parse(thirdValue);
    vNumber4.value = int.parse(fourthValue);

    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          ClockWidget(widgetNumber: vNumber1),
          ClockWidget(widgetNumber: vNumber2),
          ClockWidget(
              widgetNumber: ValueNotifier<int>(-1), isTimeIndicator: true, isTimeEllapsing: widget.isTimeEllapsing,),
          ClockWidget(widgetNumber: vNumber3),
          ClockWidget(widgetNumber: vNumber4),
        ]));
  }
}

class ClockWidget extends StatefulWidget {
  bool isTimeIndicator;
  bool isTimeEllapsing;
  ValueNotifier<int> widgetNumber;

  ClockWidget({this.widgetNumber, this.isTimeIndicator = false, this.isTimeEllapsing = true});
  @override
  ClockWidgetState createState() => ClockWidgetState();
}

enum DigitalNumberSides {
  TopHorizontal,
  CenterHorizontal,
  BottomHorizontal,
  TopRight,
  BottomRight,
  TopLeft,
  BottomLeft,
  CenterTop,
  CenterBottom
}

class ClockWidgetState extends State<ClockWidget> {
  static const double DIGIT_WIDTH_HEIGHT = 40.0;
  static const int FAST_DURATION = 100;
  static const int SLOW_DURATION = 500;

  static BoxDecoration numberBoxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white.withOpacity(0.5)]));

  final Container digitSidesContainer =
      Container(width: 40, height: 120, decoration: numberBoxDecoration);

  final Container digitHorizontalContainer =
      Container(height: 40, decoration: numberBoxDecoration);

  Map<DigitalNumberSides, List<int>> digitalNumberSidesMapping = {
    DigitalNumberSides.TopHorizontal: [0, 2, 3, 5, 6, 7, 8, 9],
    DigitalNumberSides.CenterHorizontal: [2, 3, 4, 5, 6, 8, 9],
    DigitalNumberSides.BottomHorizontal: [0, 2, 3, 5, 6, 8, 9],
    DigitalNumberSides.TopRight: [0, 2, 3, 4, 7, 8, 9],
    DigitalNumberSides.BottomRight: [0, 3, 4, 5, 6, 7, 8, 9],
    DigitalNumberSides.TopLeft: [0, 4, 5, 6, 8, 9],
    DigitalNumberSides.BottomLeft: [0, 2, 6, 8],
    DigitalNumberSides.CenterTop: [1],
    DigitalNumberSides.CenterBottom: [1],
  };

  Map<DigitalNumberSides, bool> digitalNumberSideVisible = {
    DigitalNumberSides.TopHorizontal: false,
    DigitalNumberSides.CenterHorizontal: false,
    DigitalNumberSides.CenterTop: false,
    DigitalNumberSides.CenterBottom: false,
    DigitalNumberSides.BottomHorizontal: false,
    DigitalNumberSides.TopRight: false,
    DigitalNumberSides.BottomRight: false,
    DigitalNumberSides.TopLeft: false,
    DigitalNumberSides.BottomLeft: false
  };

  @override
  void initState() {
    super.initState();
    onExecuteAnimations();

    widget.widgetNumber.addListener(() {
      onExecuteAnimations();
    });
  }

  void onExecuteAnimations() {
    digitalNumberSidesMapping.keys.forEach((side) {
      setState(() {
        digitalNumberSideVisible[side] =
            digitalNumberSidesMapping[side].contains(widget.widgetNumber.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isTimeIndicator
        ? Container(
            width: DIGIT_WIDTH_HEIGHT,
            height: 200,
            margin: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedContainer(
                    width: !widget.isTimeEllapsing ? DIGIT_WIDTH_HEIGHT : 0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut,
                    child: Container(
                      width: DIGIT_WIDTH_HEIGHT,
                      height: DIGIT_WIDTH_HEIGHT,
                      decoration: numberBoxDecoration),
                  ),
                  AnimatedContainer(
                    width: widget.isTimeEllapsing ? DIGIT_WIDTH_HEIGHT : 0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut,
                    child: Container(
                      width: DIGIT_WIDTH_HEIGHT,
                      height: DIGIT_WIDTH_HEIGHT,
                      decoration: numberBoxDecoration)
                  )
                ]))
        : ValueListenableBuilder(
            valueListenable: widget.widgetNumber,
            builder: (context, value, child) {
              return Container(
                  margin: EdgeInsets.all(10),
                  width: 120,
                  height: 200,
                  color: Colors.transparent,
                  child: Stack(children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                            height: digitalNumberSideVisible[
                                    DigitalNumberSides.TopHorizontal]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.TopHorizontal]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitHorizontalContainer)),
                    Align(
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                            height: digitalNumberSideVisible[
                                    DigitalNumberSides.CenterHorizontal]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.CenterHorizontal]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitHorizontalContainer)),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                            height: digitalNumberSideVisible[
                                    DigitalNumberSides.BottomHorizontal]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.BottomHorizontal]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitHorizontalContainer)),
                    Align(
                        alignment: Alignment.topRight,
                        child: AnimatedContainer(
                            width: digitalNumberSideVisible[
                                    DigitalNumberSides.TopRight]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.TopRight]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitSidesContainer)),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: AnimatedContainer(
                            width: digitalNumberSideVisible[
                                    DigitalNumberSides.BottomRight]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.BottomRight]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitSidesContainer)),
                    Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                            width: digitalNumberSideVisible[
                                    DigitalNumberSides.CenterTop]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.CenterTop]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitSidesContainer)),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                            width: digitalNumberSideVisible[
                                    DigitalNumberSides.CenterBottom]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.CenterBottom]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitSidesContainer)),
                    Align(
                        alignment: Alignment.topLeft,
                        child: AnimatedContainer(
                            width: digitalNumberSideVisible[
                                    DigitalNumberSides.TopLeft]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.TopLeft]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitSidesContainer)),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: AnimatedContainer(
                            width: digitalNumberSideVisible[
                                    DigitalNumberSides.BottomLeft]
                                ? DIGIT_WIDTH_HEIGHT
                                : 0.0,
                            duration: Duration(
                                milliseconds: digitalNumberSideVisible[
                                        DigitalNumberSides.BottomLeft]
                                    ? SLOW_DURATION
                                    : FAST_DURATION),
                            curve: Curves.bounceOut,
                            child: digitSidesContainer))
                  ]));
            },
          );
  }
}
