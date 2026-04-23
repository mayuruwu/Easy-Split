part of 'image_picker_bloc.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class PickFromGallery extends ImagePickerEvent {}

class PickFromCamera extends ImagePickerEvent {}

class SelectImageEvent extends ImagePickerEvent {}
