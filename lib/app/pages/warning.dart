import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({super.key});

  @override
  State<WarningPage> createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dontShowAgain = prefs.getBool('dontShowAgain') ?? false;
    setState(() {
      _isChecked = dontShowAgain;
    });
  }

  Future<void> _savePreference(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dontShowAgain', value);
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.kHOME, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'warning_title'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        fillColor: WidgetStateProperty.all(Colors.white),
                        checkColor: Theme.of(context).primaryColor,
                        value: _isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isChecked = newValue ?? false;
                          });
                        },
                      ),
                      Text('dont_show_again'.tr(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              'warning_message'.tr(),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _savePreference(_isChecked);
        },
        label: const Text('OK', style: TextStyle(color: Colors.white)),
        icon: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
