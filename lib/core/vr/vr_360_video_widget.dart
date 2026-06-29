import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vr_player/vr_player.dart';

class Vr360VideoWidget extends StatefulWidget {
  final String assetPath;
  final bool isVrMode;

  const Vr360VideoWidget({
    super.key,
    required this.assetPath,
    required this.isVrMode,
  });

  @override
  State<Vr360VideoWidget> createState() => _Vr360VideoWidgetState();
}

class _Vr360VideoWidgetState extends State<Vr360VideoWidget> {
  VrPlayerController? _playerController;
  String? _localPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _prepareVideoFile();
  }

  Future<void> _prepareVideoFile() async {
    try {
      final byteData = await rootBundle.load(widget.assetPath);
      // Usiamo ApplicationDocumentsDirectory invece di TemporaryDirectory su iOS per evitare restrizioni di lettura
      final dir = await getApplicationDocumentsDirectory();
      final String safeName = widget.assetPath
          .split('/')
          .last
          .replaceAll(' ', '_');
      final tempFile = File('${dir.path}/$safeName');

      if (!await tempFile.exists()) {
        await tempFile.writeAsBytes(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
          flush: true,
        );
      }

      setState(() {
        _localPath = tempFile.path;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error preparing video file: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onPlayerCreated(
    VrPlayerController controller,
    VrPlayerObserver observer,
  ) {
    _playerController = controller;

    observer.onStateChange = (state) {
      if (state == VrState.ready) {
        _playerController!.play();
        _playerController!.setVolume(
          0.0,
        ); // Mute the video to avoid double audio
        if (widget.isVrMode) {
          _playerController!.toggleVRMode();
        }
      }
    };

    if (_localPath != null) {
      _playerController!.loadVideo(videoPath: _localPath!);
    }
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_localPath == null) {
      return const SizedBox.shrink(); // Fail silently
    }

    return VrPlayer(
      x: 0,
      y: 0,
      onCreated: _onPlayerCreated,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
  }
}
