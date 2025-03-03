/// A widget that handles voice recording functionality for the chat.
/// Long press to start recording, release to stop.
/// Uses the native web MediaRecorder API for better web compatibility.
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

class VoiceRecorder extends StatefulWidget {
  /// Callback function that receives the recorded audio URL and duration
  final Function(String, Duration) onStop;

  const VoiceRecorder({
    Key? key,
    required this.onStop,
  }) : super(key: key);

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  // Recording state variables
  bool _isRecording = false;
  Timer? _timer;
  int _recordDuration = 0;
  html.MediaRecorder? _recorder;
  final List<html.Blob> _audioChunks = [];
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  /// Initialize the recorder by requesting microphone permissions
  Future<void> _initRecorder() async {
    try {
      final stream = await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
      if (stream != null) {
        setState(() => _hasPermission = true);
      }
    } catch (e) {
      debugPrint('Error initializing recorder: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopRecording();
    super.dispose();
  }

  /// Handle incoming audio data from the MediaRecorder
  void _onDataAvailable(html.Event event) {
    if (event is html.BlobEvent && event.data != null) {
      _audioChunks.add(event.data!);
    }
  }

  /// Start recording audio using MediaRecorder
  Future<void> _startRecording() async {
    try {
      if (!_hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission not granted')),
        );
        return;
      }

      final stream = await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
      if (stream == null) {
        throw Exception('Failed to get audio stream');
      }

      _audioChunks.clear();
      _recorder = html.MediaRecorder(stream, {'mimeType': 'audio/webm'});
      
      _recorder!.addEventListener('dataavailable', _onDataAvailable);
      _recorder!.start();
      
      setState(() {
        _isRecording = true;
        _recordDuration = 0;
      });

      // Start the recording duration timer
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() => _recordDuration++);
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start recording')),
      );
    }
  }

  /// Stop recording and create a blob URL for the recorded audio
  Future<void> _stopRecording() async {
    _timer?.cancel();
    try {
      if (_recorder != null && _isRecording) {
        _recorder!.removeEventListener('dataavailable', _onDataAvailable);
        _recorder!.stop();
        setState(() => _isRecording = false);

        if (_audioChunks.isNotEmpty) {
          final blob = html.Blob(_audioChunks.toList(), 'audio/webm');
          final url = html.Url.createObjectUrlFromBlob(blob);
          widget.onStop(url, Duration(seconds: _recordDuration));
        }
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      setState(() => _isRecording = false);
    } finally {
      _recorder = null;
      _audioChunks.clear();
    }
  }

  /// Format the recording duration as MM:SS
  String _formatDuration(int duration) {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopRecording(),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isRecording ? Colors.red : const Color(0xFF6BA8A9),
        ),
        child: _isRecording
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic, color: Colors.white, size: 20),
                  Text(
                    _formatDuration(_recordDuration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            : const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}
