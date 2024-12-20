import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/ui/cubit/anasayfa_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/detay_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kategori_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/user_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/detay.dart';
import 'package:flutter_ecommerce_app/ui/views/hesap_bilgileri.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgrounGradient),
        child: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("FusionX", style: baslikStyle),
      centerTitle: true,
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBar(context),
            _buildCategory(),
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 40,
                      ),
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
                      CupertinoPageRoute(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(kategoriler.length * 2 - 1, (index) {
                    if (index.isOdd) {
                      return const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                        color: Colors.black,
                      );
                    }
                    final kategoriIndex = index ~/ 2;
                    final kategori = kategoriler[kategoriIndex];
                    return TextButton(
                      onPressed: () {
                        context
                            .read<AnasayfaCubit>()
                            .urunleriYukle(kategori: kategori.name);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        kategori.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Literata",
                          fontWeight: FontWeight.normal,
                          fontSize: 19,
                        ),
                      ),
                    );
                  }),
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
              childAspectRatio: 3 / 3.5,
            ),
            itemBuilder: (context, index) {
              var product = productList[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
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
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "http://kasimadalan.pe.hu/urunler/resimler/${product.resim}",
                            fit: BoxFit.contain,
                            height: 90,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "₺${product.fiyat}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  context.read<DetaySayfaCubit>().urunEkle(
                                      product.ad,
                                      product.resim,
                                      product.kategori,
                                      product.fiyat,
                                      product.marka,
                                      1);
                                },
                                icon: const Icon(
                                  Icons.add_box_sharp,
                                  color: Colors.black,
                                ))
                          ],
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
    bool state = true;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
