import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/video_create/video_preview_screen.dart';

class VideoCreateScreen extends StatefulWidget {
  const VideoCreateScreen({super.key});
  static const routeName = '/video_create_screen';

  @override
  State<VideoCreateScreen> createState() => _VideoCreateScreenState();
}

class _VideoCreateScreenState extends State<VideoCreateScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;

  bool _isSelfieMode = false;
  bool _isRecording = false;
  bool _isfirstRecording = true;

  late double progressValue;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 0.2).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late FlashMode _flashMode;
  late CameraController _cameraController;
  double currentSecond = 0;
  int roundedSecond = 0;

  @override
  void initState() {
    super.initState();
    initPermissions();
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    _cameraController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      // enableAudio: false,
    );

    await _cameraController.initialize();

    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode;

    // setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Timer? _timer;

  Future<void> _startRecording() async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      currentSecond += 0.5;
      roundedSecond = currentSecond.round();
    });

    _isfirstRecording = false;
    _isRecording = true;
    _buttonAnimationController.forward().whenComplete(() {
      _buttonAnimationController.reverse();
    });
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
    _timer?.cancel();
    currentSecond = 0;
    roundedSecond = 0;
    _isRecording = false;
    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Initializing...",
                    style:
                        TextStyle(color: Colors.white, fontSize: Sizes.size20),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive()
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    bottom: Sizes.size80 + Sizes.size6,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        if (_isfirstRecording)
                          const Text(
                            "버튼을 눌러 지금 여기를",
                            style: TextStyle(
                              fontSize: Sizes.size24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        Gaps.v4,
                        if (_isfirstRecording)
                          const Text(
                            "3초동안 기록해요",
                            style: TextStyle(
                              fontSize: Sizes.size24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        else if (roundedSecond >= 1)
                          Text(
                            "$roundedSecond초",
                            style: const TextStyle(
                              fontSize: Sizes.size44,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        if (_isfirstRecording) Gaps.v16 else Gaps.v10,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size32,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _startRecording,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const SizedBox(
                                      width: Sizes.size64 + Sizes.size14,
                                      height: Sizes.size64 + Sizes.size14,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: Sizes.size4,
                                          value: 1),
                                    ),
                                    ScaleTransition(
                                      scale: _buttonAnimation,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: !_isRecording
                                            ? Sizes.size60
                                            : Sizes.size48,
                                        height: !_isRecording
                                            ? Sizes.size60
                                            : Sizes.size48,
                                        decoration: BoxDecoration(
                                          shape: !_isRecording
                                              ? BoxShape.rectangle
                                              : BoxShape.rectangle,
                                          color: const Color(0xFFE9435A),
                                          borderRadius: !_isRecording
                                              ? BorderRadius.circular(
                                                  Sizes.size64 / 2)
                                              : BorderRadius.circular(12.0),
                                        ),
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
                  ),
                  Positioned(
                      right: Sizes.size32,
                      bottom: Sizes.size96,
                      child: IconButton(
                        iconSize: Sizes.size40,
                        color: Colors.white,
                        onPressed: _toggleSelfieMode,
                        icon: const Icon(
                          Icons.cameraswitch_rounded,
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}
