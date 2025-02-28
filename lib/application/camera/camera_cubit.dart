import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_chat/application/camera/camera_state.dart';
import 'package:flutter_social_chat/domain/camera/i_camera_service.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class CameraCubit extends Cubit<CameraState> {
  final ICameraService _cameraService;
  late StreamSubscription<PermissionStatus>? _cameraPermissionSubscription;

  CameraCubit(this._cameraService) : super(CameraState.empty()) {
    _cameraPermissionSubscription = _cameraService.cameraStateChanges.listen(_listenCameraStateChangesStream);
  }

  @override
  Future<void> close() async {
    await _cameraPermissionSubscription?.cancel();
    super.close();
  }

  void refresh() {
    emit(state.copyWith(pathOfTheTakenPhoto: ''));
  }

  Future<void> _listenCameraStateChangesStream(PermissionStatus cameraPermission) async {
    if (cameraPermission.isGranted || cameraPermission.isLimited) {
      emit(state.copyWith(isCameraPermissionGranted: true));
    } else if (cameraPermission.isDenied || cameraPermission.isRestricted) {
      final requestPermission = await _cameraService.requestPermission();

      if (requestPermission.isGranted || requestPermission.isLimited) {
        emit(state.copyWith(isCameraPermissionGranted: true));
      } else {
        emit(state.copyWith(isCameraPermissionGranted: false));
      }
    } else {
      _cameraService.openAppSettingsForTheCameraPermission();
    }
  }

  Future<List<CameraDescription>> getCamerasOfTheDevice() async {
    emit(state.copyWith(isInProgress: true));

    final availableCamerasOfTheDevice = await availableCameras();

    emit(state.copyWith(isInProgress: false));

    return availableCamerasOfTheDevice;
  }

  Future<void> takePicture({
    required Future<XFile?> xfile,
    required CameraLensDirection? cameraLensDirection,
  }) async {
    String pathOfTheTakenPhoto;
    int sizeOfTheTakenPhoto;

    if (state.isInProgress) {
      return;
    }

    emit(state.copyWith(isInProgress: true));

    final file = await xfile;

    if (file == null) {
      emit(state.copyWith(pathOfTheTakenPhoto: '', isInProgress: false));
    } else {
      sizeOfTheTakenPhoto = await file.length();

      // It's for the mirror image when the cameralens is front.
      if (cameraLensDirection == CameraLensDirection.front) {
        final imageBytes = await file.readAsBytes();

        final img.Image? originalImage = img.decodeImage(imageBytes);
        final img.Image fixedImage = img.flipHorizontal(originalImage!);

        final File temporaryFile = File(file.path);
        final File fixedFile = await temporaryFile.writeAsBytes(
          img.encodeJpg(fixedImage),
          flush: true,
        );

        pathOfTheTakenPhoto = fixedFile.path;

        emit(
          state.copyWith(
            pathOfTheTakenPhoto: pathOfTheTakenPhoto,
            sizeOfTheTakenPhoto: sizeOfTheTakenPhoto,
            isInProgress: false,
          ),
        );
      }
      if (cameraLensDirection == CameraLensDirection.back) {
        pathOfTheTakenPhoto = file.path;
        emit(
          state.copyWith(
            pathOfTheTakenPhoto: pathOfTheTakenPhoto,
            sizeOfTheTakenPhoto: sizeOfTheTakenPhoto,
            isInProgress: false,
          ),
        );
      }
    }
  }
}
