import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class FlatVideoWidget extends StatefulWidget {
  final String assetPath;
  final VoidCallback? onVideoFinished;

  const FlatVideoWidget({
    Key? key,
    required this.assetPath,
    this.onVideoFinished,
  }) : super(key: key);

  @override
  State<FlatVideoWidget> createState() => _FlatVideoWidgetState();
}

class _FlatVideoWidgetState extends State<FlatVideoWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _prepareAndPlayVideo();
  }

  Future<void> _prepareAndPlayVideo() async {
    try {
      // Copy asset to a temp file with a safe name (no spaces)
      final ByteData data = await rootBundle.load(widget.assetPath);
      final Directory tempDir = await getTemporaryDirectory();
      final String safeName = widget.assetPath.split('/').last.replaceAll(' ', '_');
      final File tempFile = File('${tempDir.path}/$safeName');
      
      if (!await tempFile.exists()) {
        await tempFile.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          flush: true,
        );
      }
      
      if (!mounted) return;
      
      _controller = VideoPlayerController.file(tempFile);
      await _controller!.initialize();
      
      if (!mounted) return;
      
      setState(() {
        _isInitialized = true;
      });
      _controller!.setVolume(0.0);
      _controller!.setLooping(true);
      _controller!.play();
      _controller!.addListener(_videoListener);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error loading video file: $e";
        });
      }
    }
  }

  void _videoListener() {
    if (_controller != null && _controller!.value.isInitialized &&
        !_controller!.value.isPlaying &&
        _controller!.value.position >= _controller!.value.duration) {
      if (widget.onVideoFinished != null) {
        widget.onVideoFinished!();
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    
    return SizedBox.expand(
      child: Transform.scale(
        scale: 0.85,
        child: FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }
}
