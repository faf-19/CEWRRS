// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:io';

import 'package:e_carta_app/app/modules/report/controllers/report_controller.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/upload_dilaog.dart';
import 'package:e_carta_app/config/theme/app_colors.dart';
import 'package:e_carta_app/config/theme/app_text_styles.dart';

import 'package:flutter/material.dart';
import 'package:fepe_record/record.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:audioplayers/audioplayers.dart';

class SendaudioWidget extends StatefulWidget {
  final ReportController reportController;
  SendaudioWidget({Key? key, required this.reportController});

  @override
  _SendaudioWidgetState createState() => _SendaudioWidgetState();
}

class _SendaudioWidgetState extends State<SendaudioWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer;

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  bool isRecordingStarted = false;
  bool isPlaying = false;
  int? currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await initializeDateFormatting();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  // ---------------- Timer Logic -----------------
  void _startTimer() {
    _timer?.cancel();
    _hours = 0;
    _minutes = 0;
    _seconds = 0;

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
        if (_seconds >= 60) {
          _seconds = 0;
          _minutes++;
          if (_minutes >= 60) {
            _minutes = 0;
            _hours++;
          }
        }
      });
    });
  }

  void _stopTimer() => _timer?.cancel();

  // ---------------- Recording Logic -----------------
  Future<void> startRecording() async {
    // Check permissions using PermissionHandler directly
    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
      if (!await Permission.microphone.isGranted) {
        return;
      }
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    Directory appDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDir.path}/recording_$timestamp.m4a";

    // Start recording with fepe_record (uses MediaCodec on Android)
    await _audioRecorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );

    setState(() {
      isRecordingStarted = true;
    });

    _startTimer();
  }

  Future<void> stopRecording() async {
    // Stop recording and get the file path
    String? recordedPath = await _audioRecorder.stop();

    _stopTimer();
    setState(() => isRecordingStarted = false);

    if (recordedPath != null && File(recordedPath).existsSync()) {
      File audioFile = File(recordedPath);
      const maxSize = 5 * 1024 * 1024; // 5MB

      if (audioFile.lengthSync() <= maxSize) {
        final type = await widget.reportController.getVideoType(audioFile);
        if (type == VideoType.audio) {
          setState(() => widget.reportController.audioPaths.add(recordedPath));
        } else {
          Get.snackbar("Invalid File", "Please record audio only");
          audioFile.delete();
        }
      } else {
        Get.snackbar("Too Large", "Audio must be less than 5MB");
        audioFile.delete();
      }
    }
  }

  void StartRecording() {
    if (!isRecordingStarted && widget.reportController.audioPaths.length < 5) {
      startRecording();
    } else {
      stopRecording();
    }
  }

  // ---------------- Audio Playback -----------------
  Future<void> playFunc(String audioPath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(audioPath));

    setState(() => isPlaying = true);

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        currentlyPlayingIndex = null;
      });
    });
  }

  Future<void> pauseFunc() async {
    await _audioPlayer.pause();
    setState(() => isPlaying = false);
  }

  void deleteAudio(int index) {
    setState(() => widget.reportController.audioPaths.removeAt(index));
  }

  // ---------------- File Picker -----------------
  void _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File file = File(result.files.first.path!);
      const maxSize = 5 * 1024 * 1024;

      if (file.lengthSync() <= maxSize) {
        final type = await widget.reportController.getVideoType(file);
        if (type == VideoType.audio) {
          setState(() => widget.reportController.audioPaths.add(file.path));
        } else {
          Get.snackbar("Invalid File", "Please select valid audio");
        }
      } else {
        Get.snackbar("Too Large", "File must be under 5MB");
      }
    }
  }

  // ---------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Audio Upload'.tr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Appcolors.primary,
                ),
              ),
              if (isRecordingStarted) _buildTimer(),
              Divider(),
              Visibility(
                visible: widget.reportController.audioPaths.length < 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [_buildStartRecordingBtn(), _buildFilePickBtn()],
                ),
              ),
              _buildAudioList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartRecordingBtn() {
    return InkWell(
      onTap: () {
        if (!isRecordingStarted) {
          showDialog(
            context: context,
            builder: (_) => UploadDialog(
              onUpload: StartRecording,
              title: 'Upload Audio'.tr,
              isAudo: true,
              contentTexts: [
                'You can record 5 audio files'.tr,
                'Max size 5MB'.tr,
                'Recording starts automatically'.tr,
              ],
            ),
          );
        } else {
          stopRecording();
        }
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.mic, color: Appcolors.primary),
            SizedBox(width: 4),
            Text(
              isRecordingStarted ? "Stop Recording".tr : "Start Recording".tr,
              style: AppTextStyles.bodySmall.copyWith(
                color: isRecordingStarted ? Colors.red : Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickBtn() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => UploadDialog(
            onUpload: _pickAudioFile,
            title: 'Upload Audio'.tr,
            contentTexts: ['Upload up to 5 files'.tr, 'Max 5MB'.tr],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.file_present, color: Appcolors.primary),
            SizedBox(width: 4),
            Text(
              'Pick from File'.tr,
              style: AppTextStyles.bodySmall.copyWith(color: Appcolors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Text(
      "${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}",
      style: TextStyle(fontSize: 12, color: Colors.red),
    );
  }

  Widget _buildAudioList() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        itemCount: widget.reportController.audioPaths.length,
        itemBuilder: (_, i) {
          final audio = widget.reportController.audioPaths[i];
          final fileName = path.basename(audio);
          final isCurrent = currentlyPlayingIndex == i;

          return ListTile(
            title: Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isCurrent && isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Appcolors.primary,
                  ),
                  onPressed: () {
                    if (isCurrent && isPlaying) {
                      pauseFunc();
                    } else {
                      currentlyPlayingIndex = i;
                      playFunc(audio);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteAudio(i),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(),
      ),
    );
  }
}
