import 'package:flutter/material.dart';
import 'package:easy_split/bloc/image_picker/image_picker_bloc.dart';
import 'package:easy_split/ui/elements/app_bar.dart';
import 'package:easy_split/ui/elements/my_form.dart';
import 'package:easy_split/ui/elements/pfp.dart';
import 'package:easy_split/ui/elements/welcome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showWelcomePopup(context),
    );
    return BlocProvider(
      create: (_) => ImagePickerBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: myAppBar(title: "Easy Split"),
            body: Stack(
              children: [
                SizedBox.expand(
                  child: Image.asset(
                    'assets/images/NMK1.png',
                    fit: BoxFit.cover,
                  ),
                ),

                Container(color: Colors.black.withValues(alpha: 0.8)),

                Center(
                  // prevents overflow
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 50,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Pfp(),
                      ),
                      MyForm(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
