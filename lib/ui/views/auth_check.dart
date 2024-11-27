import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/ui/views/home.dart';
import 'package:flutter_ecommerce_app/ui/views/products.dart';
import 'package:flutter_ecommerce_app/ui/views/user_register_login/giris_sayfa.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance.authStateChanges(), // Oturum durumunu dinliyor
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Yükleniyor ekranı
        } else if (snapshot.hasData) {
          return Anasayfa(); // Oturum açıkken
        } else {
          return const GirisSayfa(); // Oturum kapalıysa
        }
      },
    );
  }
}
