import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/ui/cubit/firebase_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/user_register_login/giris_sayfa.dart';

class KayitSayfa extends StatefulWidget {
  const KayitSayfa({super.key});

  @override
  State<KayitSayfa> createState() => _KayitSayfaState();
}

class _KayitSayfaState extends State<KayitSayfa> {
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adSoyadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("FusionX", style: firebaseText),
            _buildRegister(),
          ],
        ));
  }

  BlocBuilder<FirebaseCubit, String?> _buildRegister() {
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
                _buildTextField(_adSoyadController, "Ad - Soyad", false),
                _buildTextField(_userNameController, "Kullanıcı Adı", false),
                const SizedBox(height: 16),
                _buildTextField(_emailController, "E-posta", false),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, "Şifre", true),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        final ad = _adSoyadController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        final userName = _userNameController.text;
                        if (email.isEmpty ||
                            password.isEmpty ||
                            userName.isEmpty ||
                            ad.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Tüm alanları doldurun!")),
                          );
                          return;
                        }
                        context
                            .read<FirebaseCubit>()
                            .createUser(email, password, userName, ad);
                      },
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GirisSayfa(),
                            )),
                        child: const Text(
                          "Giriş Yap",
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                ),
                if (state == 'success')
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Kayıt başarılı!",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                if (state == 'error')
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Kayıt başarısız!",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
