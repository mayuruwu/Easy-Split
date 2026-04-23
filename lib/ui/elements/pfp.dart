import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_split/bloc/image_picker/image_picker_bloc.dart'; // Replace with the actual path to your ImagePickerBloc
import 'package:easy_split/ui/elements/pop_up.dart';

class Pfp extends StatelessWidget {
  final bool group;
  const Pfp({super.key, this.group = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => popUp(context),
        child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
          builder: (context, state) {
            final image = state.image;
            return Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  foregroundImage: image != null
                      ? FileImage(File(image.path))
                      : (group
                            ? AssetImage("assets/images/group.png")
                            : AssetImage("assets/images/personal.jpg")),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 70),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,

                      borderRadius: BorderRadius.circular(10),
                      backgroundBlendMode: BlendMode.darken,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
