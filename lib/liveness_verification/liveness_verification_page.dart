import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_liveness_verification/liveness_verification/constant/verification_steps.dart';
import 'package:flutter_liveness_verification/liveness_verification/utils/utils.dart';
import 'package:flutter_liveness_verification/liveness_verification/widget/circular_progress_widget.dart';
import 'package:flutter_liveness_verification/liveness_verification/widget/face_area_widget.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class LivenessVerificationPage extends StatefulWidget {
  const LivenessVerificationPage({super.key});

  @override
  State<LivenessVerificationPage> createState() =>
      _LivenessVerificationPageState();
}

class _LivenessVerificationPageState extends State<LivenessVerificationPage> {
  bool _isCameraInitialize = false;
  late CameraController _controller;
  late FaceDetector _faceDetector;

  bool _isProcessing = false;

  Size? _imageSize;
  Size? _widgetSize;

  final _facesNotifier = ValueNotifier<List<Face>>([]);
  final _isFaceCenteredNotifier = ValueNotifier(false);

  final _steps = VerificationStep.values;
  final _stepNotifier = ValueNotifier(VerificationStep.lookForward);

  DateTime? _lastStepTime;
  bool _wasEyeOpen = false;
  bool _wasEyeClosed = false;

  @override
  void initState() {
    super.initState();
    _initFaceDetector();
    _initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    _facesNotifier.dispose();
    _isFaceCenteredNotifier.dispose();
    _stepNotifier.dispose();
    super.dispose();
  }

  void _initFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableTracking: true, //give id to face
        enableClassification: true, // smile probability, eyes probability
      ),
    );
  }

  void _initCamera() async {
    final cameras = await availableCameras();

    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller.initialize();
    await _controller.startImageStream(_processImage);

    setState(() {
      _isCameraInitialize = true;
    });
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      _imageSize ??= Size(image.width.toDouble(), image.height.toDouble());
      _widgetSize ??= MediaQuery.sizeOf(context);

      if (_imageSize == null) return;
      if (_widgetSize == null) return;

      final inputImage = Utils.convertToInputImage(
        image: image,
        sensorOrientation: _controller.description.sensorOrientation,
        lensDirection: _controller.description.lensDirection,
        deviceOrientation: _controller.value.deviceOrientation,
      );

      if (inputImage == null) return;
      final faces = await _faceDetector.processImage(inputImage);
      _facesNotifier.value = faces;

      _handleFaceLogic(faces);
    } catch (e) {
      debugPrint("Face processing error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void _handleFaceLogic(List<Face> faces) {
    if (faces.length != 1) return;

    final face = faces.first;

    final isCentered = _isFaceCentered(face);
    _isFaceCenteredNotifier.value = isCentered;

    if (isCentered) {
      _handleVerification(face);
    }
  }

  bool _isFaceCentered(Face face) {
    final box = Utils.normalizeRect(
      rect: face.boundingBox,
      lensDirection: _controller.description.lensDirection,
      imageSize: _imageSize ?? Size.zero,
      widgetSize: _widgetSize ?? Size.zero,
    );

    final center = box.center;

    return center.dx > _widgetSize!.width * 0.2 &&
        center.dx < _widgetSize!.width * 0.8 &&
        center.dy > _widgetSize!.height * 0.2 &&
        center.dy < _widgetSize!.height * 0.8;
  }

  void _handleVerification(Face face) {
    if (!_canProceed()) return;

    final step = _stepNotifier.value;
    final valid = switch (step) {
      VerificationStep.lookForward => _isLookingForward(face),
      VerificationStep.blink => _detectBlink(face),
      VerificationStep.lookUp => (face.headEulerAngleX ?? 0) > 15,
      VerificationStep.lookDown => (face.headEulerAngleX ?? 0) < 15,
      VerificationStep.turnLeft => (face.headEulerAngleY ?? 0) > 15,
      VerificationStep.turnRight => (face.headEulerAngleY ?? 0) < 15,
      VerificationStep.smile => (face.smilingProbability ?? 0) > 0.7,
      VerificationStep.done => false,
    };

    if (valid) _nextStep();
  }

  bool _canProceed() {
    if (_lastStepTime == null) return true;

    return DateTime.now().difference(_lastStepTime!) >
        const Duration(seconds: 1);
  }

  bool _isLookingForward(Face face) {
    final yaw = face.headEulerAngleY ?? 0;
    return yaw.abs() < 10;
  }

  bool _detectBlink(Face face) {
    final left = face.leftEyeOpenProbability ?? 1;
    final right = face.rightEyeOpenProbability ?? 1;

    final isOpen = left > 0.8 && right > 0.8;
    final isClosed = left < 0.3 && right < 0.3;

    if (isOpen && !_wasEyeOpen) {
      _wasEyeOpen = true;
    }

    if (_wasEyeOpen && isClosed) {
      _wasEyeClosed = true;
    }

    if (_wasEyeOpen && _wasEyeClosed && isOpen) {
      _wasEyeOpen = false;
      _wasEyeClosed = false;
      return true;
    }

    return false;
  }

  void _nextStep() {
    final currentIndex = _steps.indexOf(_stepNotifier.value);
    if (currentIndex >= _steps.length - 1) return;

    final nextStep = _steps[currentIndex + 1];

    _stepNotifier.value = nextStep;
    _lastStepTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialize) return Scaffold();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CameraPreview(_controller)),
            Positioned.fill(child: FaceAreaWidget()),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _isFaceCenteredNotifier,
                  _stepNotifier,
                ]),
                builder: (_, _) {
                  final isFaceCentered = _isFaceCenteredNotifier.value;
                  final step = _stepNotifier.value;
                  final progress = step.index / (_steps.length - 1);

                  return CircularProgressWidget(
                    value: progress,
                    color: isFaceCentered ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            // Positioned.fill(
            //   child: AnimatedBuilder(
            //     animation: Listenable.merge([
            //       _facesNotifier,
            //       _isFaceCenteredNotifier,
            //     ]),
            //     builder: (_, _) {
            //       final faces = _facesNotifier.value;
            //       final isCentered = _isFaceCenteredNotifier.value;

            //       return CustomPaint(
            //         painter: FacePainter(
            //           faces: faces,
            //           imageSize: _imageSize ?? Size.zero,
            //           lensDirection: CameraLensDirection.front,
            //           isCentered: isCentered,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.75,
              left: 16,
              right: 16,
              child: Column(
                spacing: 24,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Place your Face in the frame provided",
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _stepNotifier,
                    builder: (context, step, _) {
                      return Column(
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage(step.imageAsset)),
                          Text(
                            step.instruction,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
