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
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    _recordSub = recorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    super.initState();
  }

  Future<void> _start() async {
    if (await recorder.hasPermission()) {
      final tmpdir = await getTemporaryDirectory();
      await recorder.start(path: "${tmpdir.path}/tmprec");
      _recordDuration = 0;

      _startTimer();
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await recorder.stop();
    final filename = await getNextAvailableNameSuffix(defaultFileName);

    encryptAndSaveRecording(path!, filename);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await recorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await recorder.resume();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          buildTimer(
              _recordDuration, counterTextStyle, counterMillisecondsTextStyle),
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
