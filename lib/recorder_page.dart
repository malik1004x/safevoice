import 'package:flutter/material.dart';
import "package:record/record.dart";
import "package:path_provider/path_provider.dart";
import "encryptor.dart";
import "main.dart";
import "build_timer.dart";
import "styles.dart";
import 'dart:async';

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final recorder = Record();
  final stopwatch = Stopwatch();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  late Timer _refreshTimer;
  bool fractionsEnabled = prefs.getBool("settings.show_fractions") ?? false;

  @override
  void initState() {
    _recordSub = recorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _refreshTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // re-render the page periodically for the stopwatch to update.
      if (stopwatch.isRunning) {
        setState(() {});
      }
    });

    super.initState();
  }

  Future<void> _start() async {
    if (await recorder.hasPermission()) {
      final tmpdir = await getTemporaryDirectory();
      await recorder.start(path: "${tmpdir.path}/tmprec");
      stopwatch.start();
    }
  }

  Future<void> _stop() async {
    stopwatch.stop();
    stopwatch.reset();

    final path = await recorder.stop();
    final filename = await getNextAvailableNameSuffix(defaultFileName);

    encryptAndSaveRecording(path!, filename);
  }

  Future<void> _pause() async {
    stopwatch.stop();
    await recorder.pause();
  }

  Future<void> _resume() async {
    stopwatch.start();
    await recorder.resume();
  }

  @override
  void dispose() {
    stopwatch.reset();
    _recordSub?.cancel();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildTimer(stopwatch.elapsedMilliseconds, counterTextStyle,
              counterFractionsTextStyle, fractionsEnabled),
          Column(
            children: [
              OutlinedButton(
                  // main record button.
                  style: recordButtonStyle,
                  onPressed: () {
                    (_recordState != RecordState.stop) ? _stop() : _start();
                  },
                  child: (_recordState != RecordState.stop)
                      ? stopIcon
                      : recordIcon),
              const SizedBox(height: 5.0),
              Visibility(
                // pause button. visible only when we're recording.
                visible: _recordState != RecordState.stop,
                // this prevents the recording button from jumping around.
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: OutlinedButton(
                    style: pauseButtonStyle,
                    onPressed: () {
                      (_recordState == RecordState.pause)
                          ? _resume()
                          : _pause();
                    },
                    child: (_recordState == RecordState.pause)
                        ? resumeIcon
                        : pauseIcon),
              )
            ],
          )
        ],
      ),
    );
  }
}
