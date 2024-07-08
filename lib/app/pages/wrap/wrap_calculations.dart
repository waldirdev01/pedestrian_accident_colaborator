import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/ocorrence_helper.dart';
import '../../helpers/wrap_helper.dart';
import '../../models/occurrence.dart';
import '../../models/wrap_projection.dart';
import '../../utils/routes.dart';

class WrapCalculations extends StatefulWidget {
  const WrapCalculations({super.key});

  @override
  WrapCalculationsState createState() => WrapCalculationsState();
}

class WrapCalculationsState extends State<WrapCalculations> {
  final _formKey = GlobalKey<FormState>();

  double _pedestrianProjectionSpeedMin = 0;
  double _pedestrianProjectionSpeedMax = 0;
  double _vehicleSpeedSearleMin = 0;
  double _vehicleSpeedSearleMax = 0;
  double _vehicleSpeedLimpertMin = 0;
  double _vehicleSpeedLimpertMax = 0;
  final _pedestrianHeightCGController = TextEditingController();
  final _pedestrianFrictionCoefficientMinController = TextEditingController();
  final _pedestrianFrictionCoefficientMaxController = TextEditingController();
  final _projectionDistanceController = TextEditingController();
  final _vehicleHeightFrontController = TextEditingController();
  final _vehicleFrictionCoefficientMinController = TextEditingController();
  final _vehicleFrictionCoefficientMaxController = TextEditingController();

  @override
  void dispose() {
    _pedestrianHeightCGController.dispose();
    _pedestrianFrictionCoefficientMinController.dispose();
    _pedestrianFrictionCoefficientMaxController.dispose();
    _projectionDistanceController.dispose();
    _vehicleHeightFrontController.dispose();
    _vehicleFrictionCoefficientMinController.dispose();
    _vehicleFrictionCoefficientMaxController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ocorrence = ModalRoute.of(context)!.settings.arguments as Occurrence;

    return Scaffold(
      appBar: AppBar(
        title: Text('data_for_calculations'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                    _pedestrianHeightCGController, 'pedestrian_cg_height'.tr()),
                _buildTextField(_pedestrianFrictionCoefficientMinController,
                    'pedestrian_friction_min_coefficient'.tr()),
                _buildTextField(_pedestrianFrictionCoefficientMaxController,
                    'pedestrian_friction_max_coefficient'.tr()),
                _buildTextField(_projectionDistanceController,
                    'total_projection_distance'.tr()),
                _buildTextField(
                    _vehicleHeightFrontController, 'height_front_vehicle'.tr()),
                _buildTextField(_vehicleFrictionCoefficientMinController,
                    'vehicle_friction_min_coefficient'.tr()),
                _buildTextField(_vehicleFrictionCoefficientMaxController,
                    'vehicle_friction_max_coefficient'.tr()),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _calculateSearleModelMin();
                      _calculateSearleModelMax();
                      _calculateLimpertModelMin();
                      _calculateLimpertModelMax();
                      _ocurrenceAddWrapProjection(ocorrence);
                    }
                  },
                  child: Text(
                    'calculate'.tr(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateSearleModelMin() {
    _calculateSearleModel(
        _pedestrianFrictionCoefficientMinController.text, true);
  }

  void _calculateSearleModelMax() {
    _calculateSearleModel(
        _pedestrianFrictionCoefficientMaxController.text, false);
  }

  void _calculateSearleModel(String frictionCoefficient, bool isMin) {
    double muP = double.parse(frictionCoefficient);
    double S = double.parse(_projectionDistanceController.text);
    double hcg = double.parse(_pedestrianHeightCGController.text);
    double hv = double.parse(_vehicleHeightFrontController.text);

    double efp = hv / hcg;
    double pedestrianProjectionSpeed =
        3.6 * sqrt(2 * muP * 9.81 * S / (1 + muP * muP));

    setState(() {
      if (isMin) {
        _pedestrianProjectionSpeedMin = pedestrianProjectionSpeed;
        _vehicleSpeedSearleMin = pedestrianProjectionSpeed / efp;
      } else {
        _pedestrianProjectionSpeedMax = pedestrianProjectionSpeed;
        _vehicleSpeedSearleMax = pedestrianProjectionSpeed / efp;
      }
    });
  }

  void _calculateLimpertModelMin() {
    _calculateLimpertModel(_vehicleFrictionCoefficientMinController.text, true);
  }

  void _calculateLimpertModelMax() {
    _calculateLimpertModel(
        _vehicleFrictionCoefficientMaxController.text, false);
  }

  void _calculateLimpertModel(String frictionCoefficient, bool isMin) {
    double disPedProj = double.parse(_projectionDistanceController.text);
    double vehicleFriction = double.parse(frictionCoefficient);
    double speed = 19.2 *
            sqrt(
                2.56 * pow(vehicleFriction, 4) + vehicleFriction * disPedProj) -
        32 * pow(vehicleFriction, 2) +
        4;
    setState(() {
      if (isMin) {
        _vehicleSpeedLimpertMin = speed;
      } else {
        _vehicleSpeedLimpertMax = speed;
      }
    });
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String? hint}) {
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
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
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

  void _ocurrenceAddWrapProjection(Occurrence ocorrence) async {
    final wrapProjection = WrapProjection(
        pedestrianHeightCG: double.parse(_pedestrianHeightCGController.text),
        pedestrianFrictionCoefficientMin:
            double.parse(_pedestrianFrictionCoefficientMinController.text),
        pedestrianFrictionCoefficientMax:
            double.parse(_pedestrianFrictionCoefficientMaxController.text),
        pedestrianProjectionSpeedMin:
            double.parse(_pedestrianProjectionSpeedMin.toStringAsFixed(0)),
        pedestrianProjectionSpeedMax:
            double.parse(_pedestrianProjectionSpeedMax.toStringAsFixed(0)),
        pedestrianProjectionDistance: double.parse(
            _projectionDistanceController.text.replaceAll(',', '.')),
        vehicleHeightFront: double.parse(_vehicleHeightFrontController.text),
        vehicleFrictionCoefficientMin:
            double.parse(_vehicleFrictionCoefficientMinController.text),
        vehicleFrictionCoefficientMax:
            double.parse(_vehicleFrictionCoefficientMaxController.text),
        vehicleSpeedSearleMin:
            double.parse(_vehicleSpeedSearleMin.toStringAsFixed(0)),
        vehicleSpeedSearleMax:
            double.parse(_vehicleSpeedSearleMax.toStringAsFixed(0)),
        vehicleSpeedLimpertMin:
            double.parse(_vehicleSpeedLimpertMin.toStringAsFixed(0)),
        vehicleSpeedLimpertMax:
            double.parse(_vehicleSpeedLimpertMax.toStringAsFixed(0)));
    await WrapHelper().addWrapProjection(wrapProjection, ocorrence);
    OccurrenceHelper().updateOccurrence(ocorrence.id!, ocorrence);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.kHOME, (route) => false);
  }
}
