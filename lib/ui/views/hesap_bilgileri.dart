import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/ui/cubit/firebase_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/user_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/home.dart';

class HesapBilgileri extends StatefulWidget {
  const HesapBilgileri({super.key});

  @override
  State<HesapBilgileri> createState() => _HesapBilgileriState();
}

class _HesapBilgileriState extends State<HesapBilgileri> {
  // TextController'ları tanımlıyoruz
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firebaseUserNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde kullanıcı bilgilerini çek
    context.read<UserCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Container(
          decoration: BoxDecoration(gradient: backgrounGradient),
          child: _buildBody()),
    );
  }

  BlocBuilder<UserCubit, Map<String, String?>> _buildBody() {
    return BlocBuilder<UserCubit, Map<String, String?>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        userNameController.text = state['userName'] ?? 'Yükleniyor...';
        emailController.text = state['email'] ?? 'Yükleniyor...';
        firebaseUserNameController.text =
            state['kullaniciAdi'] ?? 'Yükleniyor...';

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hesap Bilgileri",
                style: baslikStyle,
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                readOnly: true,
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: "Ad - Soyad",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "E-posta",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: firebaseUserNameController,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  _buildResetPass(context),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    firebaseUserNameController.dispose();
    super.dispose();
  }

  TextButton _buildResetPass(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController resetPassEmail = TextEditingController();
            return AlertDialog(
              backgroundColor: backgroundColor,
              title: Text(
                "Şifre Sıfırla",
                style: TextStyle(color: textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: resetPassEmail,
                    decoration: const InputDecoration(
                      labelText: "E-posta",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "İptal",
                    style: TextStyle(color: textColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    var email = resetPassEmail.text;
                    if (email.isNotEmpty) {
                      context
                          .read<FirebaseCubit>()
                          .resetPassword(context, email)
                          .then((_) {
                        context.read<FirebaseCubit>().logOut(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Lütfen mailinizi kontrol ediniz!"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Hata: $error"),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lütfen e-posta adresinizi giriniz!"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Şifre Sıfırla",
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Text(
        "Şifre Sıfırla",
        style: TextStyle(color: textColor),
      ),
    );
  }
}
