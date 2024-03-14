import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:music_player/views/home.dart';
import 'package:path_provider/path_provider.dart';

import 'mdels/model_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  final directory = await getApplicationDocumentsDirectory() ;
  Hive.init(directory.path) ;
  Hive.registerAdapter(ModelClassAdapter()) ;
  await Hive.openBox("fav");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beats',
      theme: ThemeData(
        fontFamily: "Montserrat",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
