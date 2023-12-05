library timed_widget_slider;

import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimedWidgetSlider extends StatefulWidget {
  final List<Widget> widgets;
  final Duration onwardScrollDuration;
  final Duration backwardScrollDuration;
  final Duration scrollDurationOffset;
  final Curve scrollCurve;

  const TimedWidgetSlider({
    super.key,
    required this.widgets,
    required this.onwardScrollDuration,
    required this.backwardScrollDuration,
    required this.scrollDurationOffset,
    required this.scrollCurve,
  });

  @override
  State<TimedWidgetSlider> createState() => _TimedWidgetSliderState();
}

class _TimedWidgetSliderState extends State<TimedWidgetSlider> {
  final ScrollController scrollController = ScrollController();
  late Timer scrollTimer;

  @override
  void initState() {
    scrollTimer = Timer.periodic(
      widget.onwardScrollDuration +
          widget.backwardScrollDuration +
          (widget.scrollDurationOffset * 2),
          (Timer timer) => setState(
            () {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: widget.onwardScrollDuration, curve: widget.scrollCurve);
          Future.delayed(
            widget.onwardScrollDuration + widget.scrollDurationOffset,
                () {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: widget.backwardScrollDuration,
                  curve: widget.scrollCurve);
            },
          );
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    scrollTimer.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...widget.widgets.map((elem) {
              return Row(
                  children: [
                    elem
                  ]
              );
            }).toList()
          ],
        )
    );
  }
}
