import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ecommerce_app/ui/cubit/firebase_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/ui/cubit/anasayfa_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/detay_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kategori_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kurun_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/sepet_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => KategoriUrunCubit(),
        ),
        BlocProvider(
          create: (context) => FirebaseCubit(),
        ),
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => DetaySayfaCubit()),
        BlocProvider(create: (context) => SepetCubit()),
        BlocProvider(create: (context) => KategoriCubit()),
        BlocProvider(create: (context) => KategoriUrunCubit()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen()),
    );
  }
}
