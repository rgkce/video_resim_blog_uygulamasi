import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resimblog/firebase_options.dart';
import 'package:resimblog/profilsayfasi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Iskele(),
    );
  }
}

class Iskele extends StatefulWidget {
  const Iskele({super.key});

  @override
  State<Iskele> createState() => _IskeleState();
}

TextEditingController t1 = TextEditingController();
TextEditingController t2 = TextEditingController();

Future<void> kayitOl() async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: t1.text, password: t2.text)
      .then((kullanici) {
    FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(t1.text)
        .set({"KullaniciEposta": t1.text, "KullanciSifre": t2.text});
  }).whenComplete(
    () {
      t1.clear();
      t2.clear();
    },
  );
}

Future<void> girisYap(BuildContext context) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: t1.text, password: t2.text)
      .then((kullanici) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfilEkrani()),
        (Route<dynamic> route) => false);
  }).whenComplete(
    () {
      t1.clear();
      t2.clear();
    },
  );
}

class _IskeleState extends State<Iskele> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: t1,
              ),
              TextFormField(
                controller: t2,
              ),
              Row(
                children: [
                  const ElevatedButton(
                      onPressed: kayitOl, child: Text("Kayıt Ol")),
                  ElevatedButton(
                      onPressed: () {
                        girisYap(context);
                      },
                      child: const Text("Giriş Yap")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
