import 'package:bingo/pages/globe/globe_page.dart';
import 'package:bingo/pages/number_chart/number_chart_page.dart';
import 'package:bingo/widgets/footter.dart';
import 'package:bingo/widgets/header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildScreen(context),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GlobePage()),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NumberChartPage()),
                    );
                  },
                  child: const Text("ENTRAR NO JOGO"),
                ),
              ),
            ],
          ),
        )),
        const FooterWidget(),
      ],
    );
  }
}
