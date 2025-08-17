import 'package:flutter/material.dart';
import 'game_board.dart';
import 'game_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameManager _game;
  int _size = 4;
  TileMode _mode = TileMode.numbers;

  @override
  void initState() {
    super.initState();
    _game = GameManager(size: _size, mode: _mode);
  }

  void _restart() {
    setState(() {
      _game = GameManager(size: _size, mode: _mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restart,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: _size,
                  items: List.generate(7, (i) => i + 2)
                      .map((s) => DropdownMenuItem(value: s, child: Text('${s}x$s')))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _size = v;
                      _game.newGame(newSize: _size);
                    });
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<TileMode>(
                  value: _mode,
                  items: const [
                    DropdownMenuItem(value: TileMode.numbers, child: Text('Numbers')),
                    DropdownMenuItem(value: TileMode.icons, child: Text('Icons')),
                    DropdownMenuItem(value: TileMode.pictures, child: Text('Pictures')),
                  ],
                  onChanged: (m) {
                    if (m == null) return;
                    setState(() {
                      _mode = m;
                      _game.setMode(m);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _game,
              builder: (context, _) => Center(
                child: GameBoard(game: _game),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
