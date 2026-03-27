import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ControleHabitosApp());
}

class ControleHabitosApp extends StatefulWidget {
  const ControleHabitosApp({super.key});

  @override
  State<ControleHabitosApp> createState() => _ControleHabitosAppState();
}

class _ControleHabitosAppState extends State<ControleHabitosApp> {
  bool _modoNoturno = false;

  void _alternarTema() {
    setState(() {
      _modoNoturno = !_modoNoturno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Hábitos',
      theme: _modoNoturno
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
      home: HomeScreen(
        modoNoturno: _modoNoturno,
        aoAlternarTema: _alternarTema,
      ),
    );
  }
}