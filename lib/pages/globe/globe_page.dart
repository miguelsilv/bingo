// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bingo/store/draw_number.dart';
import 'package:bingo/widgets/ball_bingo.dart';
import 'package:bingo/widgets/footter.dart';
import 'package:bingo/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

final drawNumber = DrawNumberStore();

class GlobePage extends StatelessWidget {
  GlobePage();

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          drawNumber.draw();
          var value = drawNumber.number.toDouble();
          if (value <= 10) {
            scrollTo(0);
          } else if (value >= 90) {
            scrollTo(_scrollController.position.maxScrollExtent);
          } else {
            scrollTo(value);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void scrollTo(double value) {
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
            "#1453",
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
                value: drawNumber.number,
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
                color: !drawNumber.listNumbers.contains(index + 1)
                    ? themeData.primaryColor
                    : Colors.white,
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: !drawNumber.listNumbers.contains(index + 1)
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
