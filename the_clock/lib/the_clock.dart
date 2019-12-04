// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:the_clock/time_bloc/bloc.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class TheClock extends StatefulWidget {
  const TheClock(this.model);

  final ClockModel model;

  @override
  _TheClockState createState() => _TheClockState();
}

class _TheClockState extends State<TheClock> {
  Timer _timer;

  TimeBloc _timeBloc;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _launchBlocTimer();
    _updateModel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeBloc?.close();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _launchBlocTimer() {
    _timeBloc = TimeBloc();

    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => _timeBloc.add(UpdateTimeEvent()),
    );
  }

  String _format2digits(int number) => number.toString().padLeft(2, '0');

  int _formatHour(int hour) => (widget.model.is24HourFormat || hour == 12 ? hour : hour % 12);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light ? _lightTheme : _darkTheme;
    final fontSize = MediaQuery.of(context).size.width / 6;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return BlocProvider(
      create: (context) => _timeBloc,
      child: Container(
        color: colors[_Element.background],
        child: Center(
          child: DefaultTextStyle(
            style: defaultStyle,
            child: Stack(
              children: <Widget>[
                BlocBuilder<TimeBloc, TimeState>(
                  builder: (context, state) {
                    return Positioned(
                      left: offset,
                      top: 0,
                      child: Text(_format2digits(_formatHour(state.hour))),
                    );
                  },
                  condition: (prev, curr) => prev.hour != curr.hour,
                ),
                BlocBuilder<TimeBloc, TimeState>(
                  builder: (context, state) {
                    return Positioned(
                      left: offset,
                      bottom: offset,
                      child: Text(_format2digits(state.minute)),
                    );
                  },
                  condition: (prev, curr) => prev.minute != curr.minute,
                ),
                BlocBuilder<TimeBloc, TimeState>(
                  builder: (context, state) {
                    return Positioned(
                      right: offset,
                      bottom: offset,
                      child: Text(_format2digits(state.second)),
                    );
                  },
                  condition: (prev, curr) => prev.second != curr.second,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
