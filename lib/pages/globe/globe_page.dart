// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bingo/pages/home/home_page.dart';
import 'package:bingo/repositories/bingo_repository.dart';
import 'package:bingo/store/draw_number.dart';
import 'package:bingo/widgets/ball_bingo.dart';
import 'package:bingo/widgets/footter.dart';
import 'package:bingo/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _drawNumber = DrawNumberStore();
final _repository = BingoRepository();
bool _recovered = false;

class GlobePage extends StatelessWidget {
  GlobePage(this.sharedNumber) {
    if (!_recovered) {
      _repository.getBingoBySharedNumber(sharedNumber, (bingo) {
        _drawNumber.recovery(bingo.drawNumbers);
        _recovered = true;
      });
    }
  }

  final int sharedNumber;

  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);

    return Scaffold(
        body: SafeArea(
          child: _buildGlobe(context),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.ease,
          child: Icon(Icons.add),
          onPress: _draw,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
              onTap: _draw,
              label: 'Sortear',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.blue,
            ),
            SpeedDialChild(
              child: Icon(Icons.backup_table_rounded),
              backgroundColor: Colors.brown,
              onTap: () {},
              label: 'Cartelas',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.brown,
            ),
            SpeedDialChild(
              child: Icon(Icons.restart_alt),
              backgroundColor: Colors.yellow,
              onTap: _reset,
              label: 'Reiniciar',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.yellow,
            ),
            SpeedDialChild(
              child: Icon(Icons.logout),
              backgroundColor: Colors.red,
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setInt('shared_number', 0);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
              },
              label: 'Sair',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.red,
            ),
          ],
        ));
  }

  void _draw() {
    _drawNumber.draw(sharedNumber);
    var value = _drawNumber.number.toDouble();
    _repository.addDrawNumberToBingoBySharedNumber(
      sharedNumber,
      _drawNumber.number,
    );

    if (value <= 10) {
      _scrollTo(0);
    } else if (value >= 90) {
      _scrollTo(_scrollController.position.maxScrollExtent);
    } else {
      _scrollTo(value);
    }
  }

  void _reset() {
    _drawNumber.reset();
    _repository.cleanDrawNumbersToBingoBySharedNumber(sharedNumber);
  }

  void _scrollTo(double value) {
    _scrollController.animateTo(
      value,
      duration: Duration(seconds: 4),
      curve: Curves.ease,
    );
  }

  Widget _buildGlobe(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            "#$sharedNumber",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        _buildContent(context),
        FooterWidget(),
      ],
    );
  }

  Expanded _buildContent(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var themeData = Theme.of(context);

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Observer(builder: (context) {
              return BallBingoWidget(
                value: _drawNumber.number,
                size: queryData.size.height * 0.3,
                color: themeData.primaryColor,
              );
            }),
            _buildNumbers(context)
          ],
        ),
      ),
    );
  }

  Container _buildNumbers(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var themeData = Theme.of(context);

    return Container(
      height: queryData.size.height * 0.3,
      margin: EdgeInsets.symmetric(horizontal: queryData.size.width * 0.1),
      width: double.infinity,
      padding: EdgeInsets.all(queryData.size.height * 0.02),
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.primaryColor,
          width: queryData.size.height * 0.01,
        ),
        borderRadius: BorderRadius.circular(queryData.size.height * 0.05),
      ),
      child: GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
          ),
          itemCount: 99,
          itemBuilder: (BuildContext context, int index) {
            return Observer(builder: (context) {
              return Card(
                color: !_drawNumber.listNumbers.contains(index + 1)
                    ? themeData.primaryColor
                    : Colors.white,
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: !_drawNumber.listNumbers.contains(index + 1)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            });
          }),
    );
  }
}
