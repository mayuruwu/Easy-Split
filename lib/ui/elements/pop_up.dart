import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_split/bloc/image_picker/image_picker_bloc.dart';
import 'package:easy_split/ui/elements/mybox.dart';

void popUp(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Select",
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (dialogcontext, animation, secondaryAnimation) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle gallery selection
                    context.read<ImagePickerBloc>().add(PickFromGallery());
                    Navigator.pop(dialogcontext);
                  },
                  child: MyBox(child: Text("Gallery")),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle camera selection
                    context.read<ImagePickerBloc>().add(PickFromCamera());
                    Navigator.pop(dialogcontext);
                  },
                  child: MyBox(child: Text("Camera")),
                ),
              ],
            ),
          ],
        ),
      );
    },

    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}
