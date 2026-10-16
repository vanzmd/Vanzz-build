import 'package:flutter/material.dart';

void main() {
  runApp(const KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  const KalkulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const KalkulatorHomePage(),
    );
  }
}

class KalkulatorHomePage extends StatefulWidget {
  const KalkulatorHomePage({super.key});

  @override
  State<KalkulatorHomePage> createState() => _KalkulatorHomePageState();
}

class _KalkulatorHomePageState extends State<KalkulatorHomePage> {
  String _output = '0';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _output = '0';
      } else if (value == '=') {
        _output = _evaluate(_output);
      } else {
        if (_output == '0' && value != '.' && !_isOperator(value)) {
          _output = value;
        } else {
          _output += value;
        }
      }
    });
  }

  bool _isOperator(String s) {
    return s == '+' || s == '-' || s == '×' || s == '÷';
  }

  String _evaluate(String expression) {
    try {
      String exp = expression.replaceAll('×', '*').replaceAll('÷', '/');
      List<String> tokens = [];
      String number = '';
      for (int i = 0; i < exp.length; i++) {
        String ch = exp[i];
        if ('0123456789.'.contains(ch)) {
          number += ch;
        } else {
          if (number.isNotEmpty) {
            tokens.add(number);
            number = '';
          }
          tokens.add(ch);
        }
      }
      if (number.isNotEmpty) tokens.add(number);
      double result = double.parse(tokens[0]);
      for (int i = 1; i < tokens.length; i += 2) {
        String op = tokens[i];
        double next = double.parse(tokens[i + 1]);
        switch (op) {
          case '+':
            result += next;
            break;
          case '-':
            result -= next;
            break;
          case '*':
            result *= next;
            break;
          case '/':
            result /= next;
            break;
        }
      }
      if (result % 1 == 0) {
        return result.toInt().toString();
      }
      return result.toString();
    } catch (_) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      ['C', '÷', '×', '⌫'],
      ['7', '8', '9', '-'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '='],
      ['0', '.', '', ''],
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          ...buttonLabels.map((row) {
            return Row(
              children: row.map((label) {
                if (label.isEmpty) {
                  return const Expanded(child: SizedBox());
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: () {
                        if (label == '⌫') {
                          setState(() {
                            if (_output.length > 1) {
                              _output = _output.substring(0, _output.length - 1);
                            } else {
                              _output = '0';
                            }
                          });
                        } else {
                          _onPressed(label);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: _isOperator(label) || label == '='
                            ? Colors.orangeAccent
                            : Colors.grey.shade800,
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}
