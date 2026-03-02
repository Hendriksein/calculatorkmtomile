import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CalculatorUI(),
        '/converter': (context) => KilometerToMileConverter(),
      },
    );
  }
}


class CalculatorModel {
  double calculate(double num1, double num2, String operator) {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        if (num2 != 0) {
          return num1 / num2;
        } else {
          throw ArgumentError("Nulliga ei saa jagada");
        }
      default:
        throw ArgumentError("Viga");
    }
  }
}


class CalculatorController {
  final CalculatorModel _model = CalculatorModel();
  String _output = "0";
  double? _firstOperand;
  double? _secondOperand;
  String? _operator;

  String get output => _output;

  void input(String value) {
    if (value == 'C') {
      _clear();
    } else if (value == '+' || value == '-' || value == '*' || value == '/') {
      _operator = value;
      _firstOperand = double.tryParse(_output);
      _output = "0";
    } else if (value == '=') {
      if (_firstOperand != null && _operator != null) {
        _secondOperand = double.tryParse(_output);
        if (_secondOperand != null) {
          try {
            double result = _model.calculate(_firstOperand!, _secondOperand!, _operator!);
            _output = result.toString();
          } catch (e) {
            _output = "Error";
          }
        }
      }
    } else {
      if (_output == "0") {
        _output = value;
      } else {
        _output += value;
      }
    }
  }

  void _clear() {
    _output = "0";
    _firstOperand = null;
    _secondOperand = null;
    _operator = null;
  }
}


class CalculatorUI extends StatefulWidget {
  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  final CalculatorController _controller = CalculatorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulaator'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _controller.output,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  buildButtonRow(['7', '8', '9', '/']),
                  buildButtonRow(['4', '5', '6', '*']),
                  buildButtonRow(['1', '2', '3', '-']),
                  buildButtonRow(['C', '0', '=', '+']),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/converter');
              },
              child: Text('Mine kilomeetri miilidesse teisendaja lehele'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) => buildButton(text)).toList(),
      ),
    );
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _controller.input(text);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class KilometerToMileConverter extends StatefulWidget {
  @override
  _KilometerToMileConverterState createState() => _KilometerToMileConverterState();
}

class _KilometerToMileConverterState extends State<KilometerToMileConverter> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";

  void _convert() {
    final String input = _controller.text;
    final double? kilometers = double.tryParse(input);
    if (kilometers != null) {
      final double miles = kilometers * 0.621371;
      setState(() {
        _result = "$kilometers km = ${miles.toStringAsFixed(2)} miles";
      });
    } else {
      setState(() {
        _result = "Invalid input";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kilomeetri miilidesse teisendaja'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sisesta kilomeetrid',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Teisenda miilidesse'),
            ),
            SizedBox(height: 16),
            Text(
              _result,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tagasi kalkulaatori juurde'),
            ),
          ],
        ),
      ),
    );
  }
}
