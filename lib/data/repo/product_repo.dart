import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/data/entity/sepet.dart';

class ProductRepo {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> getUserName() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("Kullanıcı oturum açmamış.");
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      return userDoc.get('kullaniciAdi');
    } catch (e) {
      print("Kullanıcı adı alınamadı: $e");
      return null;
    }
  }

  // Firebase üzerinden kullanıcı bilgilerini çeker
 Future<Map<String, String?>> fetchUserInfo() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("Kullanıcı oturum açmamış.");
    }

    // Kullanıcı dokümanını al
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    // Doküman verilerini kontrol et
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    if (userData == null) {
      throw Exception("Kullanıcı bilgileri bulunamadı.");
    }

    // Alanları kontrol et ve nullable olarak ayarla
    String? userName = userData['ad'] as String?;
    String? email = userData['email'] as String?;
    String? kullaniciAdi = userData['kullaniciAdi'] as String?;

    return {
      'userName': userName,
      'email': email,
      'kullaniciAdi': kullaniciAdi,
    };
  } catch (e) {
    // Hata durumunda dönen değer
    return {'userName': 'Hata', 'email': 'Hata', 'kullaniciAdi': 'Hata'};
  }
}

  // Ürünleri JSON'dan parse etme metodu
  List<Product> parseProductCevap(String result) {
    try {
      var jsonResult = json.decode(result); // JSON verisini ayrıştırıyoruz
      print("JSON Verisi: $jsonResult");

      if (jsonResult['urunler'] == null) {
        print("Product verisi bulunamadı");
        return []; // Boş liste döndür
      }

      // JSON verisi doğruysa, 'urunler' alanını listeye çevirip döndürüyoruz
      var productList = (jsonResult['urunler'] as List)
          .map((item) => Product.fromJson(item))
          .toList();

      return productList;
    } catch (e) {
      print("JSON Ayrıştırma Hatası: $e");
      return [];
    }
  }

  //Firebase Giriş ve Kayıt işlemleri

  Future<void> createUser(
      String email, String password, String username, String ad) async {
    try {
      // Kullanıcıyı Firebase Auth ile oluşturuyoruz
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Kullanıcı başarılı bir şekilde oluşturulursa, Firestore'a kullanıcı adı kaydediyoruz
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({'kullaniciAdi': username, 'ad': ad, 'email': email});
    } on FirebaseAuthException catch (e) {
      // Firebase Auth hatası alınırsa, hata mesajını döndür
      print('Error: ${e.message}');
      throw Exception('Kayıt sırasında hata oluştu: ${e.message}');
    } catch (e) {
      // Diğer hataları yakalayıp, genel bir hata mesajı veririz
      print('Error: $e');
      throw Exception('Beklenmeyen bir hata oluştu');
    }
  }

  Future<void> userLogin(String email, String password) async {
    try {
      var userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception("Kullanıcı bilgisi alınamadı.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("Kullanıcı bulunamadı.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Hatalı şifre.");
      } else {
        throw Exception("Firebase hatası: ${e.message}");
      }
    } catch (e) {
      throw Exception("Beklenmeyen hata: $e");
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Şifre yenileme işlemi başarısız: $e");
    }
  }

   

  // Ürünleri yükleme metodu
  Future<List<Product>> urunleriYukle({String kategori = "Tüm Ürünler"}) async {
    var url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
    var cevap = await Dio().get(url);
    var tumUrunler = parseProductCevap(cevap.data.toString());

    // Kategoriye göre filtreleme işlemi
    if (kategori != "Tüm Ürünler") {
      return tumUrunler.where((urun) => urun.kategori == kategori).toList();
    } else {
      return tumUrunler;
    }
  }

  // Sepetteki ürünleri listeleme metodu
  Future<List<CartProduct>> sepetListele() async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php";
    String? kullaniciAdi = await getUserName();
    if (kullaniciAdi == null) {
      print("Kullanıcı adı alınamadı.");
    }
    var veri = {"kullaniciAdi": kullaniciAdi};
    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("API Yanıtı: ${cevap.data.toString()}");
      var jsonResult = json.decode(cevap.data.toString());

      var sepetListesi = (jsonResult['urunler_sepeti'] as List?)
              ?.map((item) => CartProduct.fromJson(item))
              .toList() ??
          [];

      return sepetListesi;
    } catch (e) {
      print("Sepet Listeleme Hatası: $e");
      return [];
    }
  }

  // Ürün arama metodu
  Future<List<Product>> urunAra(String aramaKelimesi) async {
    try {
      List<Product> urunler = await urunleriYukle();
      List<Product> aramaSonucu = urunler
          .where((urun) => (urun.marka.toLowerCase() + urun.ad.toLowerCase())
              .contains(aramaKelimesi.toLowerCase()))
          .toList();
      return aramaSonucu;
    } catch (e) {
      print("Ürün Arama Hatası: $e");
      return [];
    }
  }

  // Sepete ürün ekleme metodu
  Future<void> urunEkle(String ad, String resim, String kategori, int fiyat,
      String marka, int siparisAdeti) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php";
    String? kullaniciAdi = await getUserName();
    if (kullaniciAdi == null) {
      print("Kullanıcı adı alınamadı.");
    }
    var veri = {
      "ad": ad,
      "resim": resim,
      "kategori": kategori,
      "fiyat": fiyat,
      "marka": marka,
      "siparisAdeti": siparisAdeti,
      "kullaniciAdi": kullaniciAdi
    };
    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Ürün Ekleme Başarılı: ${cevap.data.toString()}");
    } catch (e) {
      print("Ürün Ekleme Hatası: $e");
    }
  }

  // Sepetten ürün silme metodu
  Future<void> sepetUrunSil(int sepetId) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php";
    String? kullaniciAdi = await getUserName();
    if (kullaniciAdi == null) {
      print("Kullanıcı adı alınamadı.");
    }
    var veri = {"kullaniciAdi": kullaniciAdi, "sepetId": sepetId};
    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Sepet Ürün Silme Başarılı: ${cevap.data.toString()}");
    } catch (e) {
      print("Sepet Ürün Silme Hatası: $e");
    }
  }

  Future<void> sepetiBosalt(List<CartProduct> sepetListesi) async {
    for (var cartProduct in sepetListesi) {
      sepetUrunSil(cartProduct.sepetId);
    }
  }

  // Kategorileri yükleme metodu
  Future<List<Kategori>> kategoriler() async {
    var kategoriler = <Kategori>[];

    var teknoloji = Kategori(
      name: "Teknoloji",
    );
    var kozmetik = Kategori(
      name: "Kozmetik",
    );
    var aksesuar = Kategori(
      name: "Aksesuar",
    );
    var tumUrunler = Kategori(
      name: "Tüm Ürünler",
    );
    kategoriler.add(tumUrunler);
    kategoriler.add(teknoloji);
    kategoriler.add(aksesuar);
    kategoriler.add(kozmetik);

    return kategoriler;
  }

  // Kategoriye göre ürün yükleme metodu
  Future<List<Product>> urunleriKategoriyeGoreYukle(String kategori) async {
    var url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
    var cevap = await Dio().get(url);
    var tumUrunler = parseProductCevap(cevap.data.toString());

    // Kategoriye göre filtreleme işlemi
    return tumUrunler.where((urun) => urun.kategori == kategori).toList();
  }

  //Fiyata göre ürün sıralama
  Future<List<Product>> sortProducts(bool state) async {
    List<Product> products = await urunleriYukle();

    if (state) {
      products.sort((a, b) => a.fiyat.compareTo(b.fiyat));
    } else {
      products.sort((b, a) => a.fiyat.compareTo(b.fiyat));
    }

    return products;
  }
}
