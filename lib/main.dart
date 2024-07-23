import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DartsCricketPage(),
    );
  }
}

class DartsCricketPage extends StatefulWidget {
  const DartsCricketPage({super.key});

  @override
  _DartsCricketPageState createState() => _DartsCricketPageState();
}

class _DartsCricketPageState extends State<DartsCricketPage> {
  final List<int> _playerAHits = List.filled(6, 0);
  final List<int> _playerBHits = List.filled(6, 0);
  int _playerAScore = 0;
  int _playerBScore = 0;

  final List<Map<String, dynamic>> _actionHistory = [];

  // Add the _checkWinCondition method here
  bool _checkWinCondition(
      List<int> playerHits, int playerScore, int opponentScore) {
    // Check if all numbers are closed (3 or more hits each)
    bool allClosed = playerHits.every((hits) => hits >= 3);
    // Check if player's score is less than opponent's
    bool lowerScore = playerScore < opponentScore;
    return allClosed && lowerScore;
  }

  void _incrementHit(
      List<int> playerHits, List<int> opponentHits, int index, bool isPlayerA) {
    setState(() {
      playerHits[index]++;

      if (playerHits[index] > 3 && opponentHits[index] < 3) {
        if (isPlayerA) {
          _playerBScore += (15 + index);
        } else {
          _playerAScore += (15 + index);
        }
      }

      _actionHistory.add({
        'playerHits': List.from(playerHits),
        'opponentHits': List.from(opponentHits),
        'index': index,
        'isPlayerA': isPlayerA
      });

      // Check for win condition
      if (isPlayerA) {
        if (_checkWinCondition(_playerAHits, _playerAScore, _playerBScore)) {
          _showWinDialog('Player A');
        }
      } else {
        if (_checkWinCondition(_playerBHits, _playerBScore, _playerAScore)) {
          _showWinDialog('Player B');
        }
      }
    });
  }

  void _undoLastAction() {
    if (_actionHistory.isNotEmpty) {
      final lastAction = _actionHistory.removeLast();
      final playerHits = lastAction['playerHits'];
      final opponentHits = lastAction['opponentHits'];
      final index = lastAction['index'];
      final isPlayerA = lastAction['isPlayerA'];

      setState(() {
        if (isPlayerA) {
          _playerAHits[index] = playerHits[index] - 1;
          _playerBHits[index] = opponentHits[index];

          // Adjust opponent's score if needed
          if (_playerAHits[index] >= 3 && _playerBHits[index] < 3) {
            _playerBScore -= (15 + index).toInt();
          }
        } else {
          _playerBHits[index] = playerHits[index] - 1;
          _playerAHits[index] = opponentHits[index];

          // Adjust opponent's score if needed
          if (_playerBHits[index] >= 3 && _playerAHits[index] < 3) {
            _playerAScore -= (15 + index).toInt();
          }
        }
      });
    }
  }

  void _showWinDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Victory !'),
          content: Text('$winner won'),
          actions: <Widget>[
            TextButton(
              child: const Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _playerAHits.fillRange(0, _playerAHits.length, 0);
      _playerBHits.fillRange(0, _playerBHits.length, 0);
      _playerAScore = 0;
      _playerBScore = 0;
      _actionHistory.clear();
    });
  }

  void _showNewGameConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Game'),
          content: const Text('Are you sure you want to start a new game?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _resetGame(); // Reset the game
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Darts Cutthroat Cricket by Youghz',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPlayerScore("Player A", _playerAScore),
                _buildPlayerScore("Player B", _playerBScore),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  _buildScoreColumn(_playerAHits, _playerBHits, true),
                  _buildScoreColumn(_playerBHits, _playerAHits, false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _undoLastAction,
                child: const Text(
                  "Undo",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _showNewGameConfirmation,
                child: const Text(
                  "New Game",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(String playerName, int score) {
    return Column(
      children: [
        Text(
          playerName,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          score.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ),
      ],
    );
  }

  Widget _buildScoreColumn(
      List<int> playerHits, List<int> opponentHits, bool isPlayerA) {
    return Expanded(
      child: Column(
        children: List.generate(6, (index) {
          int reverseIndex = 5 - index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _incrementHit(
                    playerHits, opponentHits, reverseIndex, isPlayerA);
              },
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  gradient: _buildHitGradient(playerHits[reverseIndex]),
                ),
                child: Center(
                  child: Text(
                    (15 + reverseIndex).toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  LinearGradient _buildHitGradient(int hits) {
    const Color darkGreen = Color(0xFF006400); // Darker green color
    const Color grey = Colors.grey;

    switch (hits) {
      case 0:
        return const LinearGradient(
          colors: [grey, grey],
          stops: [0, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      case 1:
        return const LinearGradient(
          colors: [darkGreen, darkGreen, grey, grey],
          stops: [0, 1 / 3, 1 / 3, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      case 2:
        return const LinearGradient(
          colors: [darkGreen, darkGreen, grey, grey],
          stops: [0, 2 / 3, 2 / 3, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      default:
        // This covers all cases where hits >= 3
        return const LinearGradient(
          colors: [darkGreen, darkGreen],
          stops: [0, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
    }
  }
}
