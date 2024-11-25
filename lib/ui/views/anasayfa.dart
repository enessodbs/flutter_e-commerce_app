import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/ui/cubit/anasayfa_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/firebase_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kategori_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/user_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/detay.dart';
import 'package:flutter_ecommerce_app/ui/views/hesap_bilgileri.dart';
import 'package:flutter_ecommerce_app/ui/views/sepet.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnasayfaCubit>().urunleriYukle();
      context.read<KategoriCubit>().kategoriler();
      context.read<UserCubit>().fetchUserInfo();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            _buildSearchBar(context),

            // Category List
            _buildCategory(),
            // List of products (Grid of Cards)
            _buildProductsGrid(),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: BlocBuilder<UserCubit, Map<String, String?>>(
        builder: (context, state) {
          return ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              context.read<FirebaseCubit>().logOut(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state['userName'] ?? 'Yükleniyor...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      state['email'] ?? 'Yükleniyor...',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text('Hesap Bilgileri'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HesapBilgileri(),
                      ));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  BlocBuilder<KategoriCubit, List<Kategori>> _buildCategory() {
    return BlocBuilder<KategoriCubit, List<Kategori>>(
      builder: (context, kategoriler) {
        if (kategoriler.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: kategoriler.map((kategori) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<AnasayfaCubit>()
                              .urunleriYukle(kategori: kategori.name);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            kategori.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Literata",
                              fontWeight: FontWeight.normal,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Kategoriler yüklenemedi veya boş."),
          );
        }
      },
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<AnasayfaCubit, List<Product>>(
      builder: (context, productList) {
        if (productList.isNotEmpty) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 4.1,
            ),
            itemBuilder: (context, index) {
              var product = productList[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetaySayfa(
                        product: product,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: backgroundColor,
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "http://kasimadalan.pe.hu/urunler/resimler/${product.resim}",
                            fit: BoxFit.cover,
                            height: 120,
                            width: 130,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${product.marka} ${product.ad}",
                          textAlign: TextAlign.center,
                          style: productNameStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₺${product.fiyat}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 102, 102, 102),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    // Başlangıçta küçükten büyüğe sıralama
    bool state = true;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search Bar
          Expanded(
            child: CupertinoSearchTextField(
              backgroundColor: Colors.white,
              placeholder: "Ara",
              placeholderStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              onChanged: (searchText) {
                context.read<AnasayfaCubit>().ara(searchText);
              },
            ),
          ),
          // Sort Button
          IconButton(
            onPressed: () {
              state = !state;
              context.read<AnasayfaCubit>().sortProducts(state);
            },
            icon: const Icon(
              Icons.sort,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
