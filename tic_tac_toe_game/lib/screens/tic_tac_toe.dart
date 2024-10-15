import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/constants/colors.dart';


class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  bool isXTurn = true;
  int xScore = 0;
  int oScore = 0;
  List<String> boxesVal = ["", "", "", "", "", "", "", "", ""];
  // List<String> boxesVal = ["0", "1", "2", "3", "4", "5", "6", "7", "8"];
  var status = "";
  List<int> winnerboxes = [];
  bool isGameStart = false;
  String btnText = "Start Play";

  Timer? timer;
  static int maxSeconds = 30;
  int seconds = maxSeconds;

  ConfettiController confettiController = ConfettiController();
  void handleBoxTap(index) {
    if (isGameStart) {
      if (boxesVal[index] == "") {
        if (isXTurn) {
          boxesVal[index] = "X";
        } else {
          boxesVal[index] = "0";
        }
        isXTurn = !isXTurn;
        checkWinner();
      }
    }
  }

  void showWinner(String winner) {
    if (winner == "X") {
      xScore++;
      status = "X Is The Winner";
    } else {
      oScore++;
      status = "0 Is The Winner";
    }
    isGameStart = false;
    btnText = "Play Again";
    confettiController.play();
    isGameStart = false;
    setState(() {});
  }

  void checkWinner() {
    if (boxesVal[0] != "" &&
        boxesVal[0] == boxesVal[1] &&
        boxesVal[0] == boxesVal[2]) {
      winnerboxes.addAll([0, 1, 2]);

      showWinner(boxesVal[0]);
    } else if (boxesVal[3] != "" &&
        boxesVal[3] == boxesVal[4] &&
        boxesVal[3] == boxesVal[5]) {
      winnerboxes.addAll([3, 4, 5]);
      showWinner(boxesVal[3]);
    } else if (boxesVal[6] != "" &&
        boxesVal[6] == boxesVal[7] &&
        boxesVal[6] == boxesVal[8]) {
      winnerboxes.addAll([6, 7, 8]);
      showWinner(boxesVal[6]);
    } else if (boxesVal[0] != "" &&
        boxesVal[0] == boxesVal[3] &&
        boxesVal[0] == boxesVal[6]) {
      winnerboxes.addAll([0, 3, 6]);
      showWinner(boxesVal[0]);
    } else if (boxesVal[1] != "" &&
        boxesVal[1] == boxesVal[4] &&
        boxesVal[1] == boxesVal[7]) {
      winnerboxes.addAll([1, 4, 7]);
      showWinner(boxesVal[1]);
    } else if (boxesVal[2] != "" &&
        boxesVal[2] == boxesVal[5] &&
        boxesVal[2] == boxesVal[8]) {
      winnerboxes.addAll([2, 5, 8]);
      showWinner(boxesVal[2]);
    } else if (boxesVal[0] != "" &&
        boxesVal[0] == boxesVal[4] &&
        boxesVal[0] == boxesVal[8]) {
      winnerboxes.addAll([0, 4, 8]);
      showWinner(boxesVal[0]);
    } else if (boxesVal[2] != "" &&
        boxesVal[2] == boxesVal[4] &&
        boxesVal[2] == boxesVal[6]) {
      winnerboxes.addAll([2, 4, 6]);
      showWinner(boxesVal[2]);
    } else if (boxesVal.every((e) => e != "")) {
      status = "Game Drawn";
      isGameStart = false;
      setState(() {});
    }
  }

  void startPlay() {
    isGameStart = true;
    btnText = "Restart";
    clear();
    startTimer();
    setState(() {});
  }

  void clear() {
    confettiController.stop();
    boxesVal.fillRange(0, 9, "");
    status = "";
    winnerboxes = [];
    seconds = maxSeconds;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
        isGameStart = false;
        status = "Game Drawn";
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.primaryColor,
      body: ConfettiWidget(
        confettiController: confettiController,
        blastDirection: pi / 4,
        blastDirectionality: BlastDirectionality.explosive,
        gravity: .7,
        minBlastForce: 10,
        numberOfParticles: 100,

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Player X",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(xScore.toString(),
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text("Player 0",
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          oScore.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  status,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(
                  flex: 2,
                ),
                SizedBox(
                  height: 430,
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          handleBoxTap(index);
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: winnerboxes.contains(index)
                                  ? AssetColors.accentColor
                                  : AssetColors.secondaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            boxesVal[index],
                            style: TextStyle(
                                color: AssetColors.primaryColor,
                                fontSize: 80,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Text("Player X Wins",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 20,
                ),
                isGameStart
                    ? SizedBox(
                        height: 80,
                        width: 80,
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 6,
                              valueColor: AlwaysStoppedAnimation(
                                AssetColors.accentColor,
                              ),
                              value: 1 - seconds / maxSeconds,
                            ),
                            Center(
                              child: Text(
                                seconds.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () {
                          startPlay();
                        },
                        child: Text(
                          btnText,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
