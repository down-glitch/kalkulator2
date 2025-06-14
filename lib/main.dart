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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFF1E88E5),
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
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 500,
            minHeight: 600,
            maxHeight: 800,
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
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _input.isEmpty ? '0' : _input,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  _result,
                  style: const TextStyle(fontSize: 24, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                ...['C', '(', ')', '÷',
                   '7', '8', '9', '×',
                   '4', '5', '6', '-',
                   '1', '2', '3', '+',
                   '.', '0', '=']
                    .map((label) => _buildCalcButton(label))
                    .toList()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcButton(String label) {
    final isOperator = ['+', '-', '×', '÷', '=', 'C', '(', ')'].contains(label);
    final isEquals = label == '=';

    return ElevatedButton(
      onPressed: () {
        if (label == 'C') {
          _clear();
        } else if (label == '=') {
          _calculate();
        } else {
          _updateInput(label);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isEquals
            ? const Color(0xFF1E88E5)
            : isOperator
                ? const Color(0xFF333333)
                : const Color(0xFF2C2C2C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOperator
              ? const BorderSide(color: Color(0xFF1E88E5), width: 1)
              : BorderSide.none,
        ),
        padding: const EdgeInsets.all(8),
        elevation: 4,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHistoryScreen() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Riwayat Perhitungan',
            style: TextStyle(fontSize: 24, color: Colors.white),
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
                          style: const TextStyle(color: Colors.white70),
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
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 2),
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
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const Text(
              'Contact : icalll@gmail.com',
              style: TextStyle(fontSize: 18, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
