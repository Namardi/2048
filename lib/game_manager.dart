import 'dart:math';
import 'package:flutter/material.dart';

/// Enum describing different display modes for tiles.
enum TileMode { numbers, icons, pictures }

/// Directions the board can be moved in.
enum Direction { up, down, left, right }

/// Core 2048 game logic with customizable board size and tile style.
class GameManager extends ChangeNotifier {
  GameManager({this.size = 4, this.mode = TileMode.numbers}) {
    _initBoard();
  }

  int size;
  TileMode mode;

  late List<List<int>> _board;
  final Random _rng = Random();

  List<List<int>> get board => _board;

  /// Starts a new game.
  void newGame({int? newSize}) {
    if (newSize != null) {
      size = newSize;
    }
    _initBoard();
    notifyListeners();
  }

  void setMode(TileMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void _initBoard() {
    _board = List.generate(size, (_) => List.filled(size, 0));
    _spawnTile();
    _spawnTile();
  }

  bool move(Direction dir) {
    bool moved = false;
    switch (dir) {
      case Direction.left:
        moved = _moveLeft();
        break;
      case Direction.right:
        moved = _moveRight();
        break;
      case Direction.up:
        moved = _moveUp();
        break;
      case Direction.down:
        moved = _moveDown();
        break;
    }
    if (moved) {
      _spawnTile();
      notifyListeners();
    }
    return moved;
  }

  bool _moveLeft() {
    bool moved = false;
    for (int i = 0; i < size; i++) {
      List<int> row = _board[i];
      List<int> merged = _merge(_compress(row));
      if (!_listEquals(row, merged)) {
        _board[i] = merged;
        moved = true;
      }
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int i = 0; i < size; i++) {
      List<int> row = List.from(_board[i].reversed);
      List<int> merged = _merge(_compress(row));
      merged = merged.reversed.toList();
      if (!_listEquals(_board[i], merged)) {
        _board[i] = merged;
        moved = true;
      }
    }
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    for (int j = 0; j < size; j++) {
      List<int> column = List.generate(size, (i) => _board[i][j]);
      List<int> merged = _merge(_compress(column));
      for (int i = 0; i < size; i++) {
        if (_board[i][j] != merged[i]) {
          _board[i][j] = merged[i];
          moved = true;
        }
      }
    }
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    for (int j = 0; j < size; j++) {
      List<int> column = List.generate(size, (i) => _board[i][j]).reversed.toList();
      List<int> merged = _merge(_compress(column));
      merged = merged.reversed.toList();
      for (int i = 0; i < size; i++) {
        if (_board[i][j] != merged[i]) {
          _board[i][j] = merged[i];
          moved = true;
        }
      }
    }
    return moved;
  }

  List<int> _compress(List<int> line) {
    line.removeWhere((v) => v == 0);
    while (line.length < size) {
      line.add(0);
    }
    return line;
  }

  List<int> _merge(List<int> line) {
    for (int i = 0; i < line.length - 1; i++) {
      if (line[i] != 0 && line[i] == line[i + 1]) {
        line[i] *= 2;
        line.removeAt(i + 1);
        line.add(0);
      }
    }
    return line;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _spawnTile() {
    List<Point<int>> empty = [];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (_board[i][j] == 0) empty.add(Point(i, j));
      }
    }
    if (empty.isEmpty) return;
    Point<int> p = empty[_rng.nextInt(empty.length)];
    _board[p.x][p.y] = _rng.nextInt(10) == 0 ? 4 : 2;
  }

  bool get hasMoves {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (_board[i][j] == 0) return true;
        if (i < size - 1 && _board[i][j] == _board[i + 1][j]) return true;
        if (j < size - 1 && _board[i][j] == _board[i][j + 1]) return true;
      }
    }
    return false;
  }
}

/// Predefined icon sets used for icon/picture modes.
class TileSets {
  static const List<IconData> icons = [
    Icons.filter_1,
    Icons.filter_2,
    Icons.filter_3,
    Icons.filter_4,
    Icons.filter_5,
    Icons.filter_6,
    Icons.filter_7,
    Icons.filter_8,
    Icons.filter_9,
    Icons.star,
  ];

  static const List<String> emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯'
  ];
}
