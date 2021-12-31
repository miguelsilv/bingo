import 'package:cloud_firestore/cloud_firestore.dart';

class BingoCard {
  late String playerName;
  late List<int> numbers;
  late int sharedNumber;

  BingoCard({
    required this.playerName,
    required this.numbers,
    required this.sharedNumber,
  });

  BingoCard.fromJson(Map<String, dynamic> json) {
    playerName = json['playerName'];
    numbers = json['numbers'].cast<int>();
    sharedNumber = json['sharedNumber'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['playerName'] = playerName;
    data['numbers'] = numbers;
    data['sharedNumber'] = sharedNumber;

    return data;
  }
}

class Bingo {
  late int sharedNumber;
  late List<int> drawNumbers;

  Bingo({
    required this.sharedNumber,
    required this.drawNumbers,
  });

  Bingo.fromJson(Map<String, dynamic> json) {
    sharedNumber = json['sharedNumber'];
    drawNumbers = json['drawNumbers'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sharedNumber'] = sharedNumber;
    data['drawNumbers'] = drawNumbers;
    return data;
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class BingoRepository {
  final CollectionReference _bingos = firestore.collection('bingos');
  final CollectionReference _bingoCards = firestore.collection('cards');

  void addBingo(Bingo bingo) {
    _bingos.add(bingo.toJson());
  }

  void addDrawNumberToBingoBySharedNumber(int sharedNumber, int drawNumber) {
    _bingos
        .where('sharedNumber', isEqualTo: sharedNumber)
        .get()
        .then((querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        _bingos.doc(documentSnapshot.id).update({
          'drawNumbers': FieldValue.arrayUnion([drawNumber])
        });
      }
    });
  }

  void cleanDrawNumbersToBingoBySharedNumber(int sharedNumber) {
    _bingos
        .where('sharedNumber', isEqualTo: sharedNumber)
        .get()
        .then((querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        _bingos.doc(documentSnapshot.id).update({'drawNumbers': []});
      }
    });
  }

  void getBingoBySharedNumber(int sharedNumber, Function(Bingo) onSuccess) {
    _bingos
        .where('sharedNumber', isEqualTo: sharedNumber)
        .get()
        .then((querySnapshot) {
      Bingo bingo = Bingo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      onSuccess(bingo);
    });
  }

  Future<String> addBingoCard(BingoCard bingoCard) {
    return _bingoCards.add(bingoCard.toJson()).then((added) => added.id);
  }

  Future<Bingo> getBingoBySharedNumberAsync(int sharedNumber) async {
    return _bingos
        .where('sharedNumber', isEqualTo: sharedNumber)
        .get()
        .then((querySnapshot) {
      return Bingo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    });
  }

  Future<BingoCard> getBingoCardByIdAsync(String id) async {
    return _bingoCards.doc(id).get().then((documentSnapshot) {
      return BingoCard.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    });
  }

  // listen to bingo drawNumbers changes
  Stream<List<int>> getBingoDrawNumbersStream(int sharedNumber) {
    return _bingos
        .where('sharedNumber', isEqualTo: sharedNumber)
        .snapshots()
        .map((querySnapshot) {
      return (querySnapshot.docs.first.data()
              as Map<String, dynamic>)['drawNumbers']
          .cast<int>();
    });
  }
}
