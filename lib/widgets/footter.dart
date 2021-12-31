import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var themeData = Theme.of(context);

    return Container(
      height: queryData.size.height * 0.05,
      width: double.infinity,
      color: themeData.primaryColorDark,
      child: const Center(
          child: Text(
        "Powered by Miguel",
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
