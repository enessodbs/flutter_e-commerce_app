import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/ui/cubit/detay_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/sepet.dart';

// ignore: must_be_immutable
class DetaySayfa extends StatefulWidget {
  Product product;
  DetaySayfa({
    super.key,
    required this.product,
  });

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("FusionX", style: baslikStyle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Sepet(),
                      ));
                },
                icon: const Icon(Icons.shopping_bag_outlined)),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  BlocBuilder<DetaySayfaCubit, void> _buildBody() {
    return BlocBuilder<DetaySayfaCubit, void>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    "http://kasimadalan.pe.hu/urunler/resimler/${widget.product.resim}",
                    height: 450,
                    width: MediaQuery.of(context).size.width - 32,
                    fit: BoxFit.contain,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${widget.product.marka} ${widget.product.ad}",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "NotoSerif"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Kategori: ${widget.product.kategori}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: "NotoSerif"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountText(),
                      const SizedBox(width: 20),
                      Text(
                        "₺${widget.product.fiyat}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      _buildButton(context),
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

  Row _buildCountText() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (count > 1) count--;
            });
          },
          icon: const Icon(Icons.remove, size: 30, color: Colors.black),
        ),
        const SizedBox(width: 10),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          icon: const Icon(Icons.add, size: 30, color: Colors.black),
        ),
      ],
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<DetaySayfaCubit>().urunEkle(
              widget.product.ad,
              widget.product.resim,
              widget.product.kategori,
              widget.product.fiyat,
              widget.product.marka,
              count,
            );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        elevation: 0,
      ),
      child: const Text(
        "Sepete Ekle",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "NotoSerif"),
      ),
    );
  }
}
