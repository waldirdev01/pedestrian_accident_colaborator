// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ForWardChecklistPage extends StatefulWidget {
  const ForWardChecklistPage({super.key});

  @override
  _ForWardChecklistPageState createState() => _ForWardChecklistPageState();
}

class _ForWardChecklistPageState extends State<ForWardChecklistPage> {
  // Initial state of the checklist items
  Map<String, bool> checklistItems = {
    'weight_occupants'.tr(): false,
    'damage'.tr(): false,
    'lighting_conditions'.tr(): false,
    'tire_condition_forward'.tr(): false,
    'mechanical_conditions'.tr(): false,
    'gear_position'.tr(): false,
    'wheelbase'.tr(): false,
    'track_width'.tr(): false,
    'road_slope'.tr(): false,
    'pavement_type'.tr(): false,
    'traffic_signage'.tr(): false,
    'site_of_pedestrian_impact'.tr(): false,
    'skid_marks'.tr(): false,
    'point_of_pedestrian_impact_against_ground'.tr(): false,
    'total_projection_distance'.tr(): false,
    'pedestrian_mass'.tr(): false,
    'pedestrian_height'.tr(): false,
    'pedestrian_cg_height'.tr(): false,
    'pedestrian_injuries'.tr(): false,
    'neighborhood'.tr(): false,
    'colision_point'.tr(): false,
    'under_vehicle'.tr(): false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'checklist'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
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
      ),
    );
  }
}
