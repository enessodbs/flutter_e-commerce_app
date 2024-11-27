// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/ui/cubit/firebase_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/products.dart';
import 'package:flutter_ecommerce_app/ui/views/sepet.dart';
import 'package:flutter_ecommerce_app/ui/views/user_register_login/giris_sayfa.dart';

class Anasayfa extends StatefulWidget {
  int? index;
  Anasayfa({
    Key? key,
    this.index,
  }) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
  }

  final List<Widget> _pages = [
    const Products(),
    const GirisSayfa(),
    const Sepet(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color(0xFFB0BEC5),
        buttonBackgroundColor: Colors.black,
        height: 60,
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.logout, size: 30, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          if (index == 1) {
            context.read<FirebaseCubit>().logOut(context);
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
