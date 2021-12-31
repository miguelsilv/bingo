import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget();

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);

    return AppBar(
      elevation: 0,
      title: Text(
        'BINGO!',
        style: TextStyle(
          fontSize: queryData.size.height / 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      toolbarHeight: queryData.size.height * 0.15,
    );
  }
}
