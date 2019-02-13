import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';

typedef void OnError(Exception exception);

enum PlayerState {
  stoppedAudio,
  playing,
  pauseAudio,
}
enum RecordingStatus { startRecording, stopRecording }

class Recorder {
  Recording recording = new Recording();
  AudioPlayer audioPlayer = new AudioPlayer();

  Duration duration = new Duration();
  String filePath;

  PlayerState playerState = PlayerState.stoppedAudio;
  RecordingStatus recordingStatus = RecordingStatus.stopRecording;

  void start() async {
    playerState = PlayerState.stoppedAudio;
    try {
      if (await AudioRecorder.hasPermissions) {
        String path = "recorder.m4a";
        Directory appDocDirectory = await getExternalStorageDirectory();
        filePath = appDocDirectory.path + '/' + path;

        File file = File(filePath);
        try {
          if (file.exists() != null) {
            await file.delete();
          }
        } catch (e) {
          print(e);
        }
        await AudioRecorder.start(
            path: filePath, audioOutputFormat: AudioOutputFormat.AAC);
        recording = new Recording(duration: new Duration(), path: "");
      } else {}
    } catch (e) {
      print(e);
    }
  }

  static const MethodChannel _channel = const MethodChannel('music_finder');
  void stop() async {
    var record = await AudioRecorder.stop();

    File file = new File(record.path);

    recording = record;
    duration = record.duration;
    filePath = record.path;
  }

  Future<void> playAudio(Function onComplete) async {
    await audioPlayer
        .play(
          filePath,
        )
        .then((k) {});
    playerState = PlayerState.playing;
    audioPlayer.completionHandler = () {
      onComplete();
      playerState = PlayerState.stoppedAudio;
    };
  }

  Future stopAudio() async {
    await audioPlayer.stop();
  }

  Future pauseAudio() async {
    await audioPlayer.pause();
    playerState = PlayerState.pauseAudio;
  }

  void seek(Duration position) async {
    audioPlayer.seek(position);
  }
}
