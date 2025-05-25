import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFB3E5FC), // biru langit muda
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0288D1), // biru laut tua
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF0288D1),
          unselectedItemColor: Colors.grey,
        ),
      ),
      title: 'Kalkulator',
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _input = '';
  String _result = '0';
  final List<String> _history = [];

  static const List<String> buttons = [
    '(', ')', '÷', '.', 'C',
    '7', '8', '9', '+', '-',
    '4', '5', '6', '×', ' ',
    '1', '2', '3', '0', '=',
  ];

  static const List<String> orangeButtons = [
    '(', ')', '÷', 'C', '+', '-', '×', '.'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void _calculate() {
    try {
      if (_input.isEmpty) {
        setState(() {
          _result = '0';
        });
        return;
      }

      String evalInput = _input.replaceAll('×', '*').replaceAll('÷', '/');
      if (evalInput.contains('/0')) {
        _result = 'Error: Division by zero';
      } else {
        const evaluator = ExpressionEvaluator();
        var expression = Expression.parse(evalInput);
        var value = evaluator.eval(expression, {});
        _result = value.toString();
        _history.add('$_input = $_result');
      }
    } catch (e) {
      _result = 'Error: Invalid expression';
    }
    setState(() {});
  }

  void _clear() {
    setState(() {
      _input = '';
      _result = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    switch (_selectedIndex) {
      case 0:
        currentScreen = _buildCalculatorScreen();
        break;
      case 1:
        currentScreen = _buildHistoryScreen();
        break;
      case 2:
        currentScreen = _buildProfileScreen();
        break;
      default:
        currentScreen = _buildCalculatorScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator App',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 400,
            minHeight: 600,
            maxHeight: 600,
          ),
          child: currentScreen,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCalculatorScreen() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // krem pasir
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 150, maxHeight: 150),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7), // biru laut
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input.isEmpty ? '0' : _input,
                    style: const TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    if (buttons[index] == 'C') {
                      _clear();
                    } else if (buttons[index] == '=') {
                      _calculate();
                    } else if (buttons[index] != ' ') {
                      _updateInput(buttons[index]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttons[index] == '='
                        ? const Color(0xFF0288D1) // biru laut tua
                        : orangeButtons.contains(buttons[index])
                            ? const Color(0xFF4FC3F7) // operator
                            : const Color(0xFFFFF8E1), // pasir
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    buttons[index],
                    style: TextStyle(
                      fontSize: 24,
                      color: orangeButtons.contains(buttons[index])
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryScreen() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Riwayat Perhitungan',
            style: TextStyle(fontSize: 24, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _history.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada riwayat',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _history[index],
                          style: const TextStyle(color: Colors.black87),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/splash.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 120,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lutfi Faisal Nur Arkarna',
              style: TextStyle(fontSize: 24, color: Colors.black87),
            ),
            const Text(
              'Contact : icalll@gmail.com',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
