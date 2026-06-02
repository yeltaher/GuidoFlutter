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
      if (!mounted) return;
      
      // Usa .asset invece di rootBundle.load per evitare problemi di memoria su iOS
      _controller = VideoPlayerController.asset(widget.assetPath);
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
    
    final videoWidth = _controller!.value.size.width;
    final videoHeight = _controller!.value.size.height;
    final aspectRatio = videoWidth > 0 && videoHeight > 0 
        ? videoWidth / videoHeight 
        : 16 / 9;

    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.88,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: const Color(0xFF6B9AC4).withOpacity(0.1),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
