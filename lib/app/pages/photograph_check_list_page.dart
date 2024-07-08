import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PhotographCheckListPage extends StatefulWidget {
  const PhotographCheckListPage({super.key});

  @override
  State<PhotographCheckListPage> createState() =>
      _PhotographCheckListPageState();
}

class _PhotographCheckListPageState extends State<PhotographCheckListPage> {
  // Initial state of the checklist items for photography
  Map<String, bool> checklistItems = {
    'wide_photos'.tr(): false,
    'driver_view_simulation'.tr(): false,
    'pedestrian_view_simulation'.tr(): false,
    'vehicle_damage'.tr(): false,
    'victim_injuries'.tr(): false,
    'traces'.tr(): false,
    'gear_lever_position'.tr(): false,
    'tire_conditions'.tr(): false,
    'headlights_and_taillights'.tr(): false,
    'isolation'.tr(): false,
    'location_characteristics_and_conditions'.tr(): false,
    'traffic_signs_nearby'.tr(): false,
    'regulatory_maximum_speed'.tr(): false,
    'weather_conditions'.tr(): false,
    'vehicle_resting_point'.tr(): false,
    'pedestrian_resting_point'.tr(): false,
    'the_four_sides_of_the_vehicle'.tr(): false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'importants_photography'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: checklistItems.keys.map((String key) {
          return Card(
            color: Theme.of(context).primaryColor,
            child: CheckboxListTile(
              activeColor: Colors.white,
              checkColor: Theme.of(context).primaryColor,
              hoverColor: Colors.white,
              fillColor: WidgetStateProperty.all(Colors.white),
              title: Text(key,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.justify),
              value: checklistItems[key],
              onChanged: (bool? value) {
                setState(() {
                  checklistItems[key] = value!;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
