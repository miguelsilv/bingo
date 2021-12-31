import 'dart:math';
import 'package:mobx/mobx.dart';

part 'draw_number.g.dart';

class DrawNumberStore = _DrawNumberStore with _$DrawNumberStore;

abstract class _DrawNumberStore with Store {
  @observable
  int number = 0;

  @observable
  var listNumbers = ObservableList<int>.of([for (var i = 1; i <= 100; i++) i]);

  @action
  void draw(int sharedNumber) {
    number = listNumbers[Random().nextInt(listNumbers.length)];
    listNumbers.remove(number);
  }

  @action
  void reset() {
    number = 0;
    listNumbers = ObservableList<int>.of([for (var i = 1; i <= 100; i++) i]);
  }

  @action
  void recovery(List<int> draws) {
    draws.forEach((element) {
      listNumbers.remove(element);
    });
  }
}
