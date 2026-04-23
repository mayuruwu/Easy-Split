import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:image/image.dart' as img;
part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<PickFromCamera>(pickFromCamera);
    on<PickFromGallery>(pickFromGallery);
  }
}

Future<XFile?> pickImage(ImageSource i) async {
  final ImagePicker picker = ImagePicker();
  try {
    XFile? im = await picker.pickImage(source: ImageSource.camera);

    if (im != null) {
      im = await cropXFileToSquare(im);
      if (im != null) {
        return im;
      }
    }
  } catch (e) {
    return null;
  }
  return null;
}

void pickFromCamera(
  PickFromCamera event,
  Emitter<ImagePickerState> emit,
) async {}

void pickFromGallery(
  PickFromGallery event,
  Emitter<ImagePickerState> emit,
) async {
  emit(ImagePickerLoading());
  XFile? im = await pickImage(ImageSource.gallery);
  if (im != null) {
    emit(ImagePicked(image: im));
  } else {
    emit(ImagePickerInitial());
  }
}

Future<XFile?> cropXFileToSquare(XFile file) async {
  // Read image bytes
  Uint8List bytes = await file.readAsBytes();

  // Decode image
  img.Image? image = img.decodeImage(bytes);
  if (image == null) return null;

  // Determine square size
  int size = image.width < image.height ? image.width : image.height;
  int x = (image.width - size) ~/ 2;
  int y = (image.height - size) ~/ 2;

  // Crop to square
  img.Image square = img.copyCrop(image, x: x, y: y, width: size, height: size);

  // Encode back to PNG or JPEG
  Uint8List squareBytes = Uint8List.fromList(img.encodeJpg(square));

  // Save to temp file
  String path = '${Directory.systemTemp.path}/square_${file.name}';
  File newFile = await File(path).writeAsBytes(squareBytes);

  return XFile(newFile.path);
}

// Future<File?> cropper(XFile im) async {
//   final croppedFile = await ImageCropper().cropImage(
//     sourcePath: im.path,
//     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // square PFP
//     uiSettings: [
//       AndroidUiSettings(
//         toolbarTitle: 'Crop Image',
//         lockAspectRatio: true,
//         initAspectRatio: CropAspectRatioPreset.square,
//       ),
//     ],
//   );
//   return croppedFile == null ? null : File(croppedFile.path);
// }
