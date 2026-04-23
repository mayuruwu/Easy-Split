part of 'image_picker_bloc.dart';

sealed class ImagePickerState extends Equatable {
  final XFile? image;

  const ImagePickerState({this.image});
  @override
  List<Object?> get props => [image];
}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePicked extends ImagePickerState {
  const ImagePicked({required XFile image}) : super(image: image);
}
