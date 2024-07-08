import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _initApp() {
    Future.delayed(const Duration(seconds: 3), () {
      _showWarningIfNeeded();
    });
  }

  void _showWarningIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dontShowAgain = prefs.getBool('dontShowAgain') ?? false;
    if (!dontShowAgain) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.kWARNINGPAGE);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.kHOME);
    }
  }

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedestrian Accident Collaborator',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  left: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  right: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  bottom: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
