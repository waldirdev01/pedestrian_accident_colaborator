import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InstructionsForUse extends StatelessWidget {
  const InstructionsForUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'instructions_use'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'usage_criteria_forward'.tr(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              Divider(
                thickness: 3,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'wrap_sugestion'.tr(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
