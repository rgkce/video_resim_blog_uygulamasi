import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resimblog/main.dart';
import 'package:resimblog/videoplayer.dart';
import 'package:resimblog/videoresim.dart';

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: [
          IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const VideoApp()),
                      (Route<dynamic> route) => true);
                });
              }),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Iskele()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const VideoResim()),
                (Route<dynamic> route) => true);
          }),
      body: const ProfilTasarimi(),
    );
  }
}

class ProfilTasarimi extends StatefulWidget {
  const ProfilTasarimi({super.key});

  @override
  State<ProfilTasarimi> createState() => _ProfilTasarimiState();
}

class _ProfilTasarimiState extends State<ProfilTasarimi> {
  File? yuklenecekdosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? indirmeBaglantisi;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    final ref = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .listAll();
    // ignore: unused_local_variable
    if (ref.items.isNotEmpty) {
      String baglanti = await FirebaseStorage.instance
          .ref()
          .child("profilresimleri")
          .child(auth.currentUser!.uid)
          .child("profilResmi.png")
          .getDownloadURL();

      setState(() {
        indirmeBaglantisi = baglanti;
      });
    }
  }

  kameradanYukle() async {
    var alinanDosya = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      yuklenecekdosya = File(alinanDosya!.path);
    });

    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png");

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekdosya!);
    String url = await (await yuklemeGorevi.whenComplete(() => null))
        .ref
        .getDownloadURL();

    setState(() {
      indirmeBaglantisi = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          // ignore: unnecessary_null_comparison
          child: indirmeBaglantisi == null
              ? const Text("Resim Yok")
              : Image.network(indirmeBaglantisi!,
                  width: 100, height: 100, fit: BoxFit.cover),
        ),
        ElevatedButton(
            onPressed: kameradanYukle, child: const Text("Resim Yükle")),
      ],
    );
  }
}
