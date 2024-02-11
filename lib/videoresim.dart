import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoResim extends StatelessWidget {
  const VideoResim({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ButonEkrani(),
    );
  }
}

class ButonEkrani extends StatefulWidget {
  const ButonEkrani({super.key});

  @override
  State<ButonEkrani> createState() => _ButonEkraniState();
}

class _ButonEkraniState extends State<ButonEkrani> {
  late File yuklenecekdosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String indirmeBaglantisi;

  kameradanVideoYukle() async {
    var alinanDosya = await ImagePicker().pickVideo(source: ImageSource.camera);
    setState(() {
      yuklenecekdosya = File(alinanDosya!.path);
    });

    Reference referansYol =
        FirebaseStorage.instance.ref().child("videolar").child("video.mp4");

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekdosya);
    String url = await (await yuklemeGorevi.whenComplete(() => null))
        .ref
        .getDownloadURL();

    setState(() {
      indirmeBaglantisi = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: kameradanVideoYukle, child: const Text("Video Yükle")),
      ],
    );
  }
}
