import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/data/entity/sepet.dart';
import 'package:flutter_ecommerce_app/ui/cubit/sepet_cubit.dart';
import 'package:lottie/lottie.dart';

class Sepet extends StatefulWidget {
  const Sepet({super.key});

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  @override
  void initState() {
    super.initState();
    // Sepeti listele
    context.read<SepetCubit>().sepetListele();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Sepetim", style: baslikStyle),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgrounGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardProduct(),
            const SizedBox(
              height: 200,
            )
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  BlocBuilder<SepetCubit, List<CartProduct>> _buildBottomSheet() {
    return BlocBuilder<SepetCubit, List<CartProduct>>(
      builder: (context, cartProducts) {
        int toplam = context.read<SepetCubit>().toplamHesapla(cartProducts);

        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toplam : ",
                        style: TextStyle(
                            fontSize: 20,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "NotoSerif"),
                      ),
                      Text(
                        "$toplam ₺",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Kargo Ücreti : ${context.read<SepetCubit>().kargoUcretiHesapla(toplam, cartProducts)}"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          if (cartProducts.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                content: const Text(
                                  "Lütfen Sepetinize Ürün Ekleyiniz!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Kapat",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Sepet Onay",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: const Text(
                                  "Sepeti Onaylıyor musunuz?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Hayır",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Sepeti boşalt
                                      await context
                                          .read<SepetCubit>()
                                          .sepetiBosalt();
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              height: 170,
                                              width: 200,
                                              child: LottieBuilder.asset(
                                                "animation/0yUzzY85RU.json",
                                                repeat: false,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      await Future.delayed(
                                          const Duration(seconds: 3));
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Evet",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Sepeti Onayla",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BlocBuilder<SepetCubit, List<CartProduct>> _buildCardProduct() {
    return BlocBuilder<SepetCubit, List<CartProduct>>(
      builder: (context, cartProducts) {
        return cartProducts.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sepetinizde Ürün Bulunmamaktadır!",
                      style: TextStyle(fontFamily: "NotoSerif"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    var cartProduct = cartProducts[index];
                    var product = cartProduct.product;
                    return Card(
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image.network(
                              "http://kasimadalan.pe.hu/urunler/resimler/${product.resim}",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${product.marka} ${product.ad}",
                                    style: productNameStyle),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Fiyat: ${cartProduct.product.fiyat} ₺",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("Adet: ${cartProduct.siparisAdeti}"),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text(
                                          "Ürün Sil",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        content: const Text(
                                          "Bu ürünü sepetinizden silmek istediğinizden emin misiniz?",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Hayır",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<SepetCubit>()
                                                  .urunSil(cartProduct.sepetId);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Evet",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                Text(
                                  "${cartProduct.siparisAdeti * product.fiyat} ₺",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
