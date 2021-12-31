// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_number.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DrawNumberStore on _DrawNumberStore, Store {
  final _$numberAtom = Atom(name: '_DrawNumberStore.number');

  @override
  int get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(int value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  final _$listNumbersAtom = Atom(name: '_DrawNumberStore.listNumbers');

  @override
  ObservableList<int> get listNumbers {
    _$listNumbersAtom.reportRead();
    return super.listNumbers;
  }

  @override
  set listNumbers(ObservableList<int> value) {
    _$listNumbersAtom.reportWrite(value, super.listNumbers, () {
      super.listNumbers = value;
    });
  }

  final _$_DrawNumberStoreActionController =
      ActionController(name: '_DrawNumberStore');

  @override
  void draw() {
    final _$actionInfo = _$_DrawNumberStoreActionController.startAction(
        name: '_DrawNumberStore.draw');
    try {
      return super.draw();
    } finally {
      _$_DrawNumberStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
number: ${number},
listNumbers: ${listNumbers}
    ''';
  }
}
