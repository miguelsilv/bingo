import 'dart:math';

import 'package:bingo/repositories/bingo_repository.dart';
import 'package:bingo/widgets/ball_bingo.dart';
import 'package:bingo/widgets/footter.dart';
import 'package:bingo/widgets/header.dart';
import 'package:flutter/material.dart';

final _repository = BingoRepository();

class BingoCardPage extends StatelessWidget {
  const BingoCardPage(this.card);

  final BingoCard card;

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
    var queryData = MediaQuery.of(context);

    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          flex: 1,
          child: StreamBuilder(
            stream: _repository.getBingoDrawNumbersStream(card.sharedNumber),
            builder: (context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.hasError) {
                return const Text('Aconteceu um erro!');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: snapshot.data!.map((int number) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: BallBingoWidget(
                        value: number,
                        size: 80,
                        color: themeData.primaryColor,
                      ),
                    );
                  }).toList());
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: _buildNumbers(context),
          ),
        ),
        Text(
          "${card.playerName}#${card.sharedNumber}",
          style: TextStyle(
              fontSize: queryData.size.width * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600]),
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
      itemCount: card.numbers.length,
      itemBuilder: (context, index) {
        return CardButton(
          value: card.numbers[index],
          onChange: (isActive) {
            isActive = isActive;
          },
        );
      },
    );
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
