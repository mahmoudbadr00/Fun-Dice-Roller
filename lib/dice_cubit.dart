import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';

class DiceState {
  final int dice1;
  final int dice2;
  final int sum;
  final bool isRolling;

  DiceState({
    required this.dice1,
    required this.dice2,
    required this.sum,
    required this.isRolling,
  });
}

class DiceCubit extends Cubit<DiceState> {
  Timer? _timer;

  DiceCubit() : super(DiceState(dice1: 2, dice2: 2, sum: 4, isRolling: false));

  void rollDice() {
    final random = Random();
    int newDice1 = random.nextInt(6) + 1;
    int newDice2 = random.nextInt(6) + 1;
    int newSum = newDice1 + newDice2;

    emit(DiceState(
        dice1: newDice1,
        dice2: newDice2,
        sum: newSum,
        isRolling: state.isRolling));
  }

  void startRolling() {
    if (_timer == null || !_timer!.isActive) {
      emit(DiceState(
          dice1: state.dice1, dice2: state.dice2, sum: 0, isRolling: true));
      _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        rollDice();
      });
    }
  }

  void stopRolling() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      emit(DiceState(
          dice1: state.dice1,
          dice2: state.dice2,
          sum: state.dice1 + state.dice2,
          isRolling: false));
    }
  }
}
