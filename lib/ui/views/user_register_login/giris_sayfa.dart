import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/ui/cubit/firebase_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/home.dart';
import 'package:flutter_ecommerce_app/ui/views/user_register_login/kayit_sayfa.dart';

class GirisSayfa extends StatefulWidget {
  const GirisSayfa({super.key});

  @override
  State<GirisSayfa> createState() => _GirisSayfaState();
}

class _GirisSayfaState extends State<GirisSayfa> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("FusionX", style: firebaseText),
            _buildLogin(),
          ],
        ));
  }

  BlocBuilder<FirebaseCubit, String?> _buildLogin() {
    return BlocBuilder<FirebaseCubit, String?>(
      builder: (context, state) {
        if (state == 'loading') {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                _buildTextField(_emailController, "E-posta", false),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, "Şifre", true),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Tüm alanları doldurun!")),
                          );
                          return;
                        }

                        try {
                          // Giriş işlemini bekle
                          await context
                              .read<FirebaseCubit>()
                              .userLogin(email, password);

                          // Başarılıysa yönlendirme
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => Anasayfa()),
                          );
                        } catch (error) {
                          // Hata durumunda mesaj göster
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        }
                      },
                      child:
                          Text("Giriş Yap", style: TextStyle(color: textColor)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const KayitSayfa(),
                          )),
                      child: Text(
                        "Kayıt Ol",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
                _buildResetPass(context),
              ],
            ),
          ),
        );
      },
    );
  }

  TextButton _buildResetPass(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Şifre sıfırlama formu için Dialog'u göster
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController resetPassEmail = TextEditingController();

            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Şifre Sıfırla",
                style: TextStyle(color: textColor),
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min, // Dialog boyutunu içeriğe göre ayarla
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
                // İptal Butonu
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dialog'u kapat
                  },
                  child: Text(
                    "İptal",
                    style: TextStyle(color: textColor),
                  ),
                ),
                // Şifreyi sıfırlama butonu
                TextButton(
                  onPressed: () {
                    var email = resetPassEmail.text;

                    if (email.isNotEmpty) {
                      // Şifre sıfırlama işlemi başlat
                      context
                          .read<FirebaseCubit>()
                          .resetPassword(context, email)
                          .then((_) {
                        Navigator.pop(context); // Dialog'u kapat
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
                      // E-posta girilmediyse uyarı ver
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
        "Şifremi Unuttum",
        style: TextStyle(color: textColor),
      ),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String? labelText, bool obscureText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
    );
  }
}
