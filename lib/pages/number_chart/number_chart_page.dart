import 'dart:math';

import 'package:bingo/widgets/ball_bingo.dart';
import 'package:bingo/widgets/footter.dart';
import 'package:bingo/widgets/header.dart';
import 'package:flutter/material.dart';

List<int> _getRandomChart() {
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

final List<int> randomNumbers = _getRandomChart();

class NumberChartPage extends StatelessWidget {
  const NumberChartPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildScreen(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.emoji_events),
        onPressed: () {},
      ),
    );
  }

  Widget _buildScreen(BuildContext context) {
    var themeData = Theme.of(context);
    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          flex: 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: BallBingoWidget(
                  value: 2,
                  size: 80,
                  color: themeData.primaryColor,
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: _buildNumbers(context),
          ),
        ),
        const FooterWidget(),
      ],
    );
  }

  Widget _buildNumbers(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.1,
      ),
      itemCount: randomNumbers.length,
      itemBuilder: (context, index) {
        return CardButton(
          value: randomNumbers[index],
          onChange: (isActive) {
            isActive = isActive;
          },
        );
      },
    );

    // return GridView.count(
    //   primary: false,
    //   childAspectRatio: 1.1,
    //   padding: const EdgeInsets.all(15),
    //   crossAxisCount: 5,
    //   children: List.generate(
    //     25,
    //     (index) {
    //       return CardButton(
    //         value: index != 12 ? index + 1 : 0,
    //         onChange: (isActive) {
    //           isActive = isActive;
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}

class CardButton extends StatefulWidget {
  final int value;
  final Function(bool isActive)? onChange;

  const CardButton({required this.onChange, this.value = 0});

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.value != 0 && !isActive
          ? Colors.white
          : Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
          setState(() {
            isActive = !isActive;
            widget.onChange!(isActive);
          });
        },
        child: Center(
          child: widget.value == 0
              ? const Icon(
                  Icons.emoji_events_outlined,
                  size: 40,
                  color: Colors.white,
                )
              : Text(
                  "${widget.value}",
                  style: TextStyle(
                    fontSize: 20,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}
