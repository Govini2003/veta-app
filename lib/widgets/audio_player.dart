/// A widget that provides audio playback functionality for voice messages.
/// Displays a play/pause button and current playback position.
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessagePlayer extends StatefulWidget {
  /// The URL or file path of the audio file to play
  final String audioPath;
  
  /// The total duration of the audio file
  final Duration duration;

  /// Whether the audio message is from the current user
  final bool isMe;

  const AudioMessagePlayer({
    Key? key,
    required this.audioPath,
    required this.duration,
    required this.isMe,
  }) : super(key: key);

  @override
  _AudioMessagePlayerState createState() => _AudioMessagePlayerState();
}

class _AudioMessagePlayerState extends State<AudioMessagePlayer> {
  // Audio player state variables
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  /// Initialize audio player and set up event listeners
  void _setupAudioPlayer() {
    // Listen for position changes
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    // Listen for player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Listen for player completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Toggle play/pause state of the audio
  Future<void> _playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // If at the end, start from beginning
        if (_position >= widget.duration) {
          _position = Duration.zero;
        }
        Source source;
        if (widget.audioPath.startsWith('http')) {
          source = UrlSource(widget.audioPath);
        } else {
          source = DeviceFileSource(widget.audioPath);
        }
        await _audioPlayer.play(source);
      }
      setState(() => _isPlaying = !_isPlaying);
    } catch (e) {
      debugPrint('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not play audio')),
      );
    }
  }

  /// Seek to a specific position in the audio
  Future<void> _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Format duration as MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isMe ? Colors.white : Color(0xFF1D4D4F);

    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _playPause,
            color: primaryColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: primaryColor,
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: primaryColor.withOpacity(0.3),
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    max: widget.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(
                          color: primaryColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDuration(widget.duration),
                        style: TextStyle(
                          color: primaryColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
