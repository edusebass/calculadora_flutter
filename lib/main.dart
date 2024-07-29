import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "=") {
        try {
          _output = _calculateExpression(_input);
        } catch (e) {
          _output = "Error";
        }
        _input = _output;
      } else if (buttonText == "C") {
        _input = "";
        _output = "0";
      } else {
        _input += buttonText;
        _output = _input;
      }
    });
  }

  String _calculateExpression(String expression) {
    try {
      // Replace trigonometric functions with Dart's math functions
      expression = expression.replaceAll('sin(', 'sin(');
      expression = expression.replaceAll('cos(', 'cos(');
      expression = expression.replaceAll('tan(', 'tan(');

      // Evaluate the expression using the Expression package
      final exp = Expression.parse(expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(exp, {});
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              alignment: Alignment.centerRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                _buildButtonRow("7", "8", "9", "/"),
                _buildButtonRow("4", "5", "6", "*"),
                _buildButtonRow("1", "2", "3", "-"),
                _buildButtonRow(".", "0", "C", "+"),
                _buildButtonRow("sin(", "cos(", "tan(", ")"),
                _buildButtonRow("=", "", "", ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      String text1, String text2, String text3, String text4) {
    return Expanded(
      child: Row(
        children: <Widget>[
          _buildButton(text1),
          _buildButton(text2),
          _buildButton(text3),
          _buildButton(text4),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
