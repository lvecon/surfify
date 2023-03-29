import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surfify/constants/gaps.dart';
import 'package:surfify/constants/sizes.dart';
import 'package:surfify/features/video/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});
  static const routeName = '/video_recording_screen';

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;

  bool _isSelfieMode = false;
  bool _goTutorial = false;

  late double progressValue;

  void _tapTutorial() {
    _goTutorial = true;
    setState(() {});
  }

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.2).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late FlashMode _flashMode;
  late CameraController _cameraController;

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

    setState(() {});
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

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    _goTutorial = false;
    setState(() {});
  }

  Future<void> _starRecording() async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

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
    final mediaSize = MediaQuery.of(context).size;
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
            : !_goTutorial
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: 1 /
                            (_cameraController.value.aspectRatio *
                                mediaSize.aspectRatio),
                        child: CameraPreview(_cameraController),
                      ),
                      Positioned(
                        bottom: Sizes.size80,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const Text(
                              "우리는 지금...",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.v4,
                            const Text(
                              "여기에 있어요!",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.v28,
                            SizedBox(
                              width: 330,
                              height: Sizes.size64,
                              child: CupertinoButton(
                                onPressed: _tapTutorial,
                                color: Theme.of(context).primaryColor,
                                child: const Text(
                                  "맞아!",
                                  style: TextStyle(
                                    fontSize: Sizes.size18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
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
                            const Text(
                              "버튼을 눌러 지금 여기를",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.v4,
                            const Text(
                              "3초동안 기록해요",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.v16,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size32,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    iconSize: Sizes.size40,
                                    color: _flashMode == FlashMode.torch
                                        ? Colors.amber.shade200
                                        : Colors.white,
                                    onPressed: () =>
                                        _setFlashMode(FlashMode.torch),
                                    icon: const Icon(
                                      Icons.flashlight_on_rounded,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _starRecording,
                                    child: ScaleTransition(
                                      scale: _buttonAnimation,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: Sizes.size64 + Sizes.size14,
                                            height: Sizes.size64 + Sizes.size14,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: Sizes.size4,
                                              value: (_progressAnimationController
                                                          .value ==
                                                      0)
                                                  ? 1
                                                  : _progressAnimationController
                                                      .value,
                                            ),
                                          ),
                                          Container(
                                            width: Sizes.size64,
                                            height: Sizes.size64,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFE9435A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: Sizes.size40,
                                    color: Colors.white,
                                    onPressed: _toggleSelfieMode,
                                    icon: const Icon(
                                      Icons.cameraswitch,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
