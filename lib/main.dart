import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int players = 0, current = 1, imposter = 1;
  bool show = false, started = false;

  final List<String> words = [
    "University", "Hospital", "School", "Teacher", "Doctor",
    "Car", "Bike", "Burger", "Pizza", "Restaurant",
    "Park", "Library", "Beach", "Cinema", "Market",
    "Coffee", "Laptop", "Phone", "Hotel", "Museum"
  ];

  String word = "";
  final controller = TextEditingController();

  
  String getRandomWord() => words[Random().nextInt(words.length)];

  
  Widget gameButton(String text, VoidCallback onPressed, {Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.deepPurple,
      ),
      child: Text(text),
    );
  }

  void start() {
    players = int.tryParse(controller.text) ?? 3;
    players = players.clamp(3, 10);
    imposter = Random().nextInt(players) + 1;
    current = 1;
    show = false;
    started = true;
    word = getRandomWord();
    setState(() {});
  }

  void reveal() => setState(() => show = true);

  void next() {
    current++;
    show = false;
    setState(() {});
  }

  void restart() {
    started = false;
    controller.clear();
    setState(() {});
  }

  
  Widget buildGameColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: !started
            ? buildGameColumn([
                const Text("Imposter Game",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("Enter number of players", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                gameButton("Start", start),
              ])
            : current <= players
                ? buildGameColumn([
                    Text("Player $current", style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 30),
                    show
                        ? Text(
                            current == imposter ? "😈 You are the Imposter" : "Word: $word",
                            style: const TextStyle(fontSize: 22),
                          )
                        : gameButton("Show", reveal),
                    const SizedBox(height: 20),
                    if (show) gameButton("Next", next),
                  ])
                : buildGameColumn([
                    const Text("let's talk now", style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 20),
                    gameButton("Restart", restart),
                  ]),
      ),
    );
  }
}