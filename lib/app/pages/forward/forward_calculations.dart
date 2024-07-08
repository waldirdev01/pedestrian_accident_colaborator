import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../helpers/forward_helper.dart';
import '../../helpers/ocorrence_helper.dart';
import '../../models/forward_projection.dart';
import '../../models/occurrence.dart';
import '../../utils/routes.dart';

class ForwardCalculations extends StatefulWidget {
  const ForwardCalculations({super.key});

  @override
  ForwardCalculationsState createState() => ForwardCalculationsState();
}

class ForwardCalculationsState extends State<ForwardCalculations> {
  final _formKey = GlobalKey<FormState>();

  double pedestrianProjectionSpeedMin = 0;
  double pedestrianProjectionSpeedMax = 0;
  double vehicleSpeedNortwesternMin = 0;
  double vehicleSpeedNortwesternMax = 0;
  double slidingDistance = 0;
  double toorSpeed = 0;

  final _pedestrianCGHeightController = TextEditingController();
  final _frictionPedestrianCoefficientMinController = TextEditingController();
  final _frictionPedestrianCoefficientMaxController = TextEditingController();
  final _frictionVehicleCoefficientMinController = TextEditingController();
  final _frictionVehicleCoefficientMaxController = TextEditingController();
  final _projectionDistanceController = TextEditingController();
  final _vehicleMassController = TextEditingController();
  final _pedestrianMassController = TextEditingController();

  @override
  void dispose() {
    _pedestrianCGHeightController.dispose();
    _frictionPedestrianCoefficientMinController.dispose();
    _frictionPedestrianCoefficientMaxController.dispose();
    _projectionDistanceController.dispose();
    _vehicleMassController.dispose();
    _pedestrianMassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final occurrence = ModalRoute.of(context)!.settings.arguments as Occurrence;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'data_for_calculations'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                _pedestrianCGHeightController,
                'pedestrian_cg_height'.tr(),
              ),
              _buildTextField(
                _frictionPedestrianCoefficientMinController,
                'pedestrian_friction_min_coefficient'.tr(),
              ),
              _buildTextField(
                _frictionPedestrianCoefficientMaxController,
                'pedestrian_friction_max_coefficient'.tr(),
              ),
              _buildTextField(
                _frictionVehicleCoefficientMinController,
                'vehicle_friction_min_coefficient'.tr(),
              ),
              _buildTextField(
                _frictionVehicleCoefficientMaxController,
                'vehicle_friction_max_coefficient'.tr(),
              ),
              _buildTextField(
                _projectionDistanceController,
                'total_projection_distance'.tr(),
              ),
              _buildTextField(
                _vehicleMassController,
                'vehicle_mass'.tr(),
              ),
              _buildTextField(
                _pedestrianMassController,
                'pedestrian_mass'.tr(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _calculateCollinsModelMin();
                    _calculateCollinsModelMax();
                    _calculateToorModel();
                    _addForwardProjection(occurrence);

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'calculate'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateCollinsModelMin() {
    double hcg = double.parse(_pedestrianCGHeightController.text);
    double mi = double.parse(_frictionPedestrianCoefficientMinController.text);
    double dp = double.parse(_projectionDistanceController.text);
    double mv = double.parse(_vehicleMassController.text);
    double mp = double.parse(_pedestrianMassController.text);

    double df =
        -(2 * mi * hcg) - 2 * (-hcg) * sqrt(pow(mi, 2) - (mi * dp / (-hcg)));
    double vp = df * sqrt(9.81 / (2 * hcg));
    double efp = mv / (mv + mp);
    double vt = vp / efp;

    setState(() {
      pedestrianProjectionSpeedMin = 3.6 * vp;
      vehicleSpeedNortwesternMin = 3.6 * vt;
      slidingDistance = dp - df;
    });
  }

  void _calculateCollinsModelMax() {
    double hcg = double.parse(_pedestrianCGHeightController.text);
    double ma = double.parse(_frictionPedestrianCoefficientMaxController.text);
    double dp = double.parse(_projectionDistanceController.text);
    double mv = double.parse(_vehicleMassController.text);
    double mp = double.parse(_pedestrianMassController.text);

    double df =
        -(2 * ma * hcg) - 2 * (-hcg) * sqrt(pow(ma, 2) - (ma * dp / (-hcg)));
    double vp = df * sqrt(9.81 / (2 * hcg));
    double efp = mv / (mv + mp);
    double vt = vp / efp;

    setState(() {
      pedestrianProjectionSpeedMax = 3.6 * vp;
      vehicleSpeedNortwesternMax = 3.6 * vt;
    });
  }

  void _calculateToorModel() {
    double S = double.parse(_projectionDistanceController.text);
    setState(() {
      toorSpeed = 8.25 * pow(S, 0.61);
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
  ) {
    // Adiciona um listener no controller para substituir vírgulas por pontos.
    controller.addListener(() {
      String text = controller.text;
      if (text.contains(',')) {
        text = text.replaceAll(',', '.');
        controller.value = controller.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'please_enter_value'.tr();
          }
          // Adiciona uma validação extra para garantir que o valor é numérico
          if (double.tryParse(value.replaceAll(',', '.')) == null) {
            return 'please_enter_valid_number'
                .tr(); // Adicione a tradução adequada
          }
          return null;
        },
      ),
    );
  }

  Future<void> _addForwardProjection(Occurrence occurrence) async {
    final forwardProjection = ForwardProjection(
        pedestrianCGHeight: double.parse(_pedestrianCGHeightController.text),
        pedestrianMass: double.parse(_pedestrianMassController.text),
        pedestrianFrictionCoefficientMin:
            double.parse(_frictionPedestrianCoefficientMinController.text),
        pedestrianFrictionCoefficientMax:
            double.parse(_frictionPedestrianCoefficientMaxController.text),
        vehicleFrictionCoefficientMin:
            double.parse(_frictionVehicleCoefficientMinController.text),
        vehicleFrictionCoefficientMax:
            double.parse(_frictionVehicleCoefficientMaxController.text),
        pedestrianProjectionSpeedMin:
            double.parse(pedestrianProjectionSpeedMin.toStringAsFixed(0)),
        pedestrianProjectionSpeedMax:
            double.parse(pedestrianProjectionSpeedMax.toStringAsFixed(0)),
        pedestrianProjectionDistance:
            double.parse(_projectionDistanceController.text),
        slidingDistance: double.parse(slidingDistance.toStringAsFixed(2)),
        vehicleMass: double.parse(_vehicleMassController.text),
        vehicleSpeedNortwesternMin: vehicleSpeedNortwesternMin,
        vehicleSpeedNortwesternMax: vehicleSpeedNortwesternMax,
        toorSpeed: toorSpeed);
    await ForwardHelper().addForwardProjection(forwardProjection, occurrence);

    OccurrenceHelper().updateOccurrence(occurrence.id!, occurrence);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.kHOME, (route) => false);
  }
}
