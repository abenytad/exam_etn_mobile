// video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VlcPlayerController _vlcPlayerController;
  bool isPlaying = true;
  bool isFinished = false;
  String position = "00:00"; // For minute counter

  @override
  void initState() {
    super.initState();

    _vlcPlayerController = VlcPlayerController.network(
      widget.videoUrl,
      autoPlay: true,
      hwAcc: HwAcc.full,
      onInit: () {
        _vlcPlayerController.addListener(() {
          setState(() {
            position = _vlcPlayerController.value.position.inMinutes
                    .toString()
                    .padLeft(2, '0') +
                ":" +
                (_vlcPlayerController.value.position.inSeconds % 60)
                    .toString()
                    .padLeft(2, '0');

            // Check if video is finished
            if (_vlcPlayerController.value.isEnded) {
              isPlaying = false;
              isFinished = true;
            }
          });
        });
      },
    );
  }

  void _togglePlayPause() {
    if (isFinished) {
      _restartVideo();
    } else {
      setState(() {
        if (isPlaying) {
          _vlcPlayerController.pause();
        } else {
          _vlcPlayerController.play();
        }
        isPlaying = !isPlaying;
      });
    }
  }

  void _rotateScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      setState(() {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      });
    } else {
      setState(() {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });
    }
  }

  void _restartVideo() {
    _vlcPlayerController.stop();
    _vlcPlayerController.play();
    setState(() {
      isPlaying = true;
      isFinished = false;
    });
  }

  void _seekForward() {
    final newPosition = _vlcPlayerController.value.position + Duration(seconds: 3);
    _vlcPlayerController.seekTo(newPosition);
  }

  void _seekBackward() {
    final newPosition = _vlcPlayerController.value.position - Duration(seconds: 3);
    _vlcPlayerController.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VLC Video Player'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            icon: Icon(Icons.replay_10), // Skip backward icon
            onPressed: _seekBackward,
          ),
          IconButton(
            icon: Icon(isFinished
                ? Icons.replay // Show restart icon when finished
                : isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: Icon(Icons.forward_10), // Skip forward icon
            onPressed: _seekForward,
          ),
          IconButton(
            icon: Icon(Icons.screen_rotation),
            onPressed: _rotateScreen,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: VlcPlayer(
                controller: _vlcPlayerController,
                aspectRatio: 16 / 9,
                placeholder: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Elapsed Time: $position',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();
  }
}
