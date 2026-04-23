import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_split/bloc/Auth/auth_bloc.dart';
import 'package:easy_split/bloc/image_picker/image_picker_bloc.dart';
import 'package:easy_split/ui/elements/mybox.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

final _formKey = GlobalKey<FormState>();

// ignore: must_be_immutable
class MyForm extends StatelessWidget {
  MyForm({super.key});
  final fields = {
    "Name": "Chhava",
    "Bio": "Raj nahi... Swarajya chahiye",
    "UPI ID": "798****636@paytm",
  };
  XFile? pfp;
  late final Map<String, TextEditingController> mp = makeDict(fields.keys);
  @override
  Widget build(BuildContext context) {
    pfp = context.select((ImagePickerBloc b) {
      final s = b.state;
      return (s is ImagePicked) ? s.image : null;
    });
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            for (var entry in mp.entries) ...[
              SizedBox(
                width: 300,
                child: TextFormField(
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: entry.value,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),

                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    hintText: fields[entry.key],
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor.withAlpha(80),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "This field is required";
                    } else if (entry.key == "UPI ID") {
                      if (!RegExp(
                        r'^[\w.-]{2,256}@[a-zA-Z]{2,64}$',
                      ).hasMatch(value)) {
                        return "Invalid UPI ID";
                      }
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
            ],

            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await saveData(context);
                }
              },
              child: MyBox(child: Text("Submit")),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, TextEditingController> makeDict(Iterable<String> a) {
    Map<String, TextEditingController> mp = {};
    for (String s in a) {
      mp[s] = TextEditingController();
    }
    return mp;
  }

  Future<void> saveData(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final im = context.read<ImagePickerBloc>().state.image;
    String? url;

    showLoader(context);
    if (im != null) url = await uploadToCloudinary(File(im.path));

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      'id': uid,
      "name": mp["Name"]!.text,
      "bio": mp["Bio"]!.text,
      "upi": mp["UPI ID"]!.text,
      "isRegistered": true,
      "pfp": url,
      "CreatedAt": Timestamp.now(),
    });
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    // ignore: use_build_context_synchronously
    context.read<AuthBloc>().add(LogIn(uid));
  }

  Future<String?> uploadToCloudinary(File image) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/dgx6nzlof/image/upload",
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'pfp_upload'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData = json.decode(await response.stream.bytesToString());
      return resData['secure_url']; // ✅ THIS is your image URL
    } else {
      return null;
    }
  }
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

void hideLoader(BuildContext context) {
  Navigator.of(context).pop();
}
