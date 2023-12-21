import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStopwatch extends StatefulWidget {
  final Stopwatch stopwatch;

  const MyStopwatch({super.key, required this.stopwatch});
  // MyStopwatch({})
  @override
  _MyStopwatchState createState() => _MyStopwatchState();
}

class _MyStopwatchState extends State<MyStopwatch> {
  // final _stopwatch = Stopwatch();
  late StreamController<int> _streamController;
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>();
    _timerStream = _streamController.stream;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (widget.stopwatch.isRunning) {
        _streamController.add(widget.stopwatch.elapsedMilliseconds);
      }
    });
  }

  @override
  void dispose() {
    widget.stopwatch.stop();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (context, snapshot) {
        final milliseconds = snapshot.data ?? 0;
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time_rounded),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 100,
                child: Text(
                  formatTime(milliseconds),
                  style: GoogleFonts.bangers(fontSize: 24.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatTime(int milliseconds) {
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }
}
