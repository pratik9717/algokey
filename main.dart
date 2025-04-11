
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() => runApp(ALGOKEYApp());

class ALGOKEYApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALGOKEY',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PasswordScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 2),
          child: Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    );
  }
}

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String _password = '';
  String _formattedDate = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
    Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.minute == 0) {
        _generatePassword();
      }
    });
  }

  void _generatePassword() {
    final now = DateTime.now();
    final hourOnly = DateTime(now.year, now.month, now.day, now.hour);
    final dateStr = DateFormat("dMMMMuuuuyyyyha").format(hourOnly).toLowerCase();
    final dateDisplay = DateFormat('EEEE, d MMMM yyyy – h:00 a').format(hourOnly);

    final bytes = utf8.encode(dateStr);
    final digest = sha256.convert(bytes);
    final password = digest.toString().substring(0, 10);

    setState(() {
      _password = password;
      _formattedDate = dateDisplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Time',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                _formattedDate,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Text(
                'Your Password',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                '>>> $_password <<<',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 80),
              Text(
                'ALGOKEY',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white24,
                  letterSpacing: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
