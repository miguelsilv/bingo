import 'dart:math';
import 'package:bingo/repositories/bingo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bingo/pages/globe/globe_page.dart';
import 'package:bingo/pages/number_chart/bingo_card_page.dart';
import 'package:bingo/widgets/footter.dart';
import 'package:bingo/widgets/header.dart';
import 'package:flutter/material.dart';

final _repository = BingoRepository();

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(child: _buildScreen(context)),
            ),
          );
        }),
      ),
    );
  }

  Column _buildScreen(BuildContext context) {
    var queryData = MediaQuery.of(context);

    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: queryData.size.height * 0.05),
                  child: Text("BEM VINDO AO JOGO DE BINGO!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: queryData.size.width * 0.06,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(
                  height: queryData.size.height * 0.05,
                ),
                SizedBox(
                  width: queryData.size.width * 0.8,
                  height: queryData.size.height * 0.1,
                  child: ElevatedButton(
                    onPressed: () {
                      _createNewGame(context);
                    },
                    child: const Text("CRIAR JOGO"),
                  ),
                ),
                SizedBox(
                  height: queryData.size.height * 0.02,
                ),
                SizedBox(
                  width: queryData.size.width * 0.8,
                  height: queryData.size.height * 0.1,
                  child: ElevatedButton(
                    onPressed: () {
                      _enterGame(context);
                    },
                    child: const Text("ENTRAR NO JOGO"),
                  ),
                ),
              ],
            ),
          ),
        ),
        const FooterWidget(),
      ],
    );
  }

  int _generateCode() {
    var code = "";
    var random = Random();
    for (var i = 0; i < 5; i++) {
      code += random.nextInt(10).toString();
    }
    return int.parse(code);
  }

  void _createNewGame(BuildContext context) {
    int code = _generateCode();
    _repository.addBingo(Bingo(sharedNumber: code, drawNumbers: []));
    _saveSharedNumber(code);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Jogo criado!"),
          content: Text("O código do seu jogo é: $code"),
          actions: [
            TextButton(
              child: const Text("Vamos lá!"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GlobePage(code)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _enterGame(BuildContext context) {
    int code = 0;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Digite o código do jogo:"),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              code = int.parse(value);
            },
          ),
          actions: [
            TextButton(
              child: const Text("Continuar"),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _repository.getBingoBySharedNumberAsync(code);
                  _confirmPlayerName(context, code);
                } catch (e) {
                  _gameNotFound(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmPlayerName(BuildContext context, int code) {
    String name = "";
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Digite o seu nome:"),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              name = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text("Continuar"),
              onPressed: () async {
                Navigator.of(context).pop();

                BingoCard card = BingoCard(
                  playerName: name,
                  sharedNumber: code,
                  numbers: _getRandomNumbers(),
                );

                String id = await _repository.addBingoCard(card);
                print("id: $id");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("id", id);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BingoCardPage(card)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<int> _getRandomNumbers() {
    List<int> list = [];
    for (int i = 0; i < 24; i++) {
      var value = Random().nextInt(99) + 1;
      if (!list.contains(value)) {
        list.add(value);
      } else {
        i--;
      }
    }
    list.sort();
    list.insert(12, 0);
    return list;
  }

  void _gameNotFound(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Jogo não encontrado!"),
          content: const Text("O código do jogo não foi encontrado."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSharedNumber(int number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('shared_number', number);
  }
}
