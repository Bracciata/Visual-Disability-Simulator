import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CamTab extends StatefulWidget {
  @override
  _CamPreviewState createState() => _CamPreviewState();
}

class _CamPreviewState extends State<CamTab> {
  CameraController _controller;
  Future<void> _initCamFuture;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  _initApp() async {
    final cameras = await availableCameras();
    final firstCam = cameras.first;

    _controller = CameraController(
      firstCam,
      ResolutionPreset.medium,
    );

    _initCamFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initCamFuture,
        builder: (context, snapshot) {
            return CameraPreview(_controller);
        },
      ),
    );
  }
}