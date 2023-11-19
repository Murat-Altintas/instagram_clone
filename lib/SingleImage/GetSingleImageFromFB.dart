import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/extensions.dart';

class GetSingleImageFromFB extends StatefulWidget {
  const GetSingleImageFromFB({super.key});

  @override
  State<GetSingleImageFromFB> createState() => _GetSingleImageFromFBState();
}

class _GetSingleImageFromFBState extends State<GetSingleImageFromFB> {
  final storage = FirebaseStorage.instance.ref();
  String url = "";
  final ImagePicker picker = ImagePicker();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(url == "" ? "https://fastly.picsum.photos/id/724/200/200.jpg?hmac=sUKRpiwXopeRQ36cEVnZgrG3Wd73G8iet9dfVSvmi8k" : url, height: 350, width: 350),
        ElevatedButton(
            onPressed: () async {
              var pictures = storage.child("images/guzel.jpg");
              url = await pictures.getDownloadURL();
              setState(() {});
              url.log();
            },
            child: const Text("Show JPG")),
      ],
    );
  }

  Future<void> getSingleImageFromPhoneToFB(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);

    try {
      file = File(pickedFile!.path);
      storage.child("images/").putFile(file!);
    } on FirebaseException catch (e) {
      e.log();
    }
    setState(() {});
  }
}
