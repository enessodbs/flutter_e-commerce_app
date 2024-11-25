import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';
import 'package:flutter_ecommerce_app/ui/views/user_register_login/giris_sayfa.dart';

class FirebaseCubit extends Cubit<String?> {
  FirebaseCubit() : super(null);

  final ProductRepo productRepo = ProductRepo();

  Future<void> createUser(
      String email, String password, String username, String ad) async {
    emit('loading'); // Yükleme durumu
    try {
      await productRepo.createUser(
          email, password, username, ad); // Kullanıcı oluştur
      emit('success'); // Başarılı durum
    } catch (e) {
      emit('error'); // Hata durumu
    }
  }

  Future<void> userLogin(String email, String password) async {
    try {
      await productRepo.userLogin(email, password);
      emit('success'); // Başarılı durum
    } catch (e) {
      emit('error'); // Hata durumu
      rethrow; // Hata mesajını UI'a iletmek için tekrar fırlat
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      await productRepo.logOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GirisSayfa()),
        (route) => false,
      );
    } catch (e) {
      print("Log Out Error: $e");
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await productRepo.resetPassword(email);
      emit(
          "Şifre yenileme e-postası gönderildi. Lütfen e-postanızı kontrol edin.");
    } catch (e) {
      emit(
          "Şifre yenileme e-postası gönderildi. Lütfen e-postanızı kontrol edin.");
    }
  }

 
}
