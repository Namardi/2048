import 'dart:math';
import 'package:flutter/material.dart';
import 'game_manager.dart';

/// Widget that renders the game board and handles user interaction.
class GameBoard extends StatelessWidget {
  const GameBoard({super.key, required this.game});

  final GameManager game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0) {
          game.move(Direction.up);
        } else {
          game.move(Direction.down);
        }
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0) {
          game.move(Direction.left);
        } else {
          game.move(Direction.right);
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: game.size * game.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: game.size,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final x = index ~/ game.size;
            final y = index % game.size;
            final value = game.board[x][y];
            return _Tile(value: value, mode: game.mode);
          },
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.value, required this.mode});

  final int value;
  final TileMode mode;

  Color _colorForValue(int value) {
    final int pow = (log(value) / log(2)).toInt();
    final List<Color> colors = [
      Colors.grey.shade300,
      Colors.lightBlue.shade100,
      Colors.lightBlue.shade200,
      Colors.lightBlue.shade300,
      Colors.lightBlue.shade400,
      Colors.lightBlue.shade500,
      Colors.lightBlue.shade600,
      Colors.lightBlue.shade700,
      Colors.lightBlue.shade800,
      Colors.lightBlue.shade900,
    ];
    return colors[pow.clamp(0, colors.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return Container(color: Colors.grey.shade200);
    }
    final index = (log(value) / log(2)).toInt() - 1;
    Widget child;
    switch (mode) {
      case TileMode.numbers:
        child = Text(
          '$value',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.black),
        );
        break;
      case TileMode.icons:
        child = Icon(TileSets.icons[index % TileSets.icons.length]);
        break;
      case TileMode.pictures:
        child = Image.network(
          'https://picsum.photos/200?image=${index + 10}',
          fit: BoxFit.cover,
        );
        break;
    }
    return Container(
      color: _colorForValue(value),
      child: Center(child: child),
    );
  }
}
