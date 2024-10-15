import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/screens/tic_tac_toe.dart';


void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      // fontFamily: "Coiny",
      textTheme: const TextTheme(
        titleLarge: TextStyle(

          color: Colors.white,
          fontSize: 30,
        ),
      ),
    ),
  
    home: const TicTacToe(),
    debugShowCheckedModeBanner: false,
    
  ));
}
