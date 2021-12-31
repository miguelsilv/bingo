import 'package:bingo/pages/globe/globe_page.dart';
import 'package:bingo/pages/home/home_page.dart';
import 'package:bingo/pages/number_chart/bingo_card_page.dart';
import 'package:bingo/repositories/bingo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: FutureBuilder(
          future: _buildHome(),
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<Widget> _buildHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';

    if (id.isNotEmpty) {
      final BingoRepository _repository = BingoRepository();
      var card = await _repository.getBingoCardByIdAsync(id);
      return BingoCardPage(card);
    }

    int sharedNumber = prefs.getInt('shared_number') ?? 0;

    if (sharedNumber == 0) {
      return const HomePage();
    }

    return GlobePage(sharedNumber);
  }
}
