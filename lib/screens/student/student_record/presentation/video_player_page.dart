import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class GoogleDriveVideoPlayer extends StatefulWidget {
  final String driveLink;
  final String title;
  const GoogleDriveVideoPlayer(
      {Key? key, required this.driveLink, required this.title})
      : super(key: key);

  @override
  State<GoogleDriveVideoPlayer> createState() => _GoogleDriveVideoPlayerState();
}

class _GoogleDriveVideoPlayerState extends State<GoogleDriveVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _isFullscreen = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<String> getDirectVideoUrl(String driveLink) async {
    final regex = RegExp(r'd/(.*?)/');
    final match = regex.firstMatch(driveLink);
    final fileId = match?.group(1);

    if (fileId == null) throw Exception("Invalid Google Drive link");

    final exportUrl = "https://drive.google.com/uc?id=$fileId&export=download";

    final response = await http.head(Uri.parse(exportUrl));
    if (response.statusCode == 200) {
      return exportUrl;
    } else {
      throw Exception("Unable to access Google Drive file.");
    }
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final directUrl = await getDirectVideoUrl(widget.driveLink);

      final controller = VideoPlayerController.network(directUrl);
      await controller.initialize();
      if (mounted) {
        setState(() {
          _controller = controller;
          _isLoading = false;
        });
      }

      _controller?.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _togglePlayback() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Restore UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Widget _buildControls() {
    return GestureDetector(
      onTap: () {
        print('tapped');
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Bar
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        if (_isFullscreen) {
                          _toggleFullscreen();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  // Bottom Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _togglePlayback,
                          icon: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Colors.red,
                              bufferedColor: Colors.grey,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleFullscreen,
                          icon: Icon(
                            _isFullscreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(position.inHours);
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));
    return hours == "00" ? "$minutes:$seconds" : "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen ? null : AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller != null && _controller!.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    print('tapped');
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _isFullscreen
                                ? MediaQuery.of(context).size.aspectRatio
                                : _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                        if (_showControls) _buildControls(),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('Failed to load video')),
    );
  }
}
