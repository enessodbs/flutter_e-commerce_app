import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/sepet.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class SepetCubit extends Cubit<List<CartProduct>> {
  SepetCubit() : super([]);

  var productRepo = ProductRepo();

  Future<void> sepetListele() async {
    try {
      var liste = await productRepo.sepetListele();
      print(liste);
      emit(liste);
    } catch (error) {
      print('Error fetching cart list: $error');
      emit([]);
    }
  }

  Future<void> urunSil( int sepetId) async {
    try {
      await productRepo.sepetUrunSil(sepetId);
      await sepetListele();
    } catch (error) {
      print('Error removing product from cart: $error');
    }
  }

  int toplamHesapla(List<CartProduct> cartProducts) {
    int toplamUcret = 0;

    for (var cartProduct in cartProducts) {
      toplamUcret += cartProduct.product.fiyat * cartProduct.siparisAdeti;
    }

    if (toplamUcret < 5000) {
      toplamUcret += kargoUcretiHesapla(toplamUcret, cartProducts);
    }

    return toplamUcret;
  }

  int kargoUcretiHesapla(int toplamTutar, List<CartProduct> cartProducts) {
    if (toplamTutar >= 5000) {
      return 0;
    }
    int kargoUcreti = 0;
    for (var product in cartProducts) {
      kargoUcreti += product.siparisAdeti * 50;
    }

    return kargoUcreti;
  }

  Future<void> sepetiBosalt() async {
    var sepetListesi = state;
    await productRepo.sepetiBosalt(sepetListesi);
    emit([]);
  }
}
