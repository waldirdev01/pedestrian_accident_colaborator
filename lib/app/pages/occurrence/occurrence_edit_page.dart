// ignore_for_file: library_private_types_in_public_api, must_be_immutable
/*
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedestrian_accident_colaborator/app/helpers/wrap_helper.dart';
import 'package:pedestrian_accident_colaborator/app/models/occurrence.dart';

import '../../helpers/forward_helper.dart';
import '../../helpers/ocorrence_helper.dart';
import '../../models/forward_projection.dart';
import '../../models/wrap_projection.dart';

class OccurrenceEditPage extends StatefulWidget {
  const OccurrenceEditPage({super.key});

  @override
  _OccurrenceEditPageState createState() => _OccurrenceEditPageState();
}

class _OccurrenceEditPageState extends State<OccurrenceEditPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  late WrapProjection? wrapProjection;
  late ForwardProjection? forwardProjection;

  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _pedestrianHeightCGController;
  late TextEditingController _pedestrianFrictionCoefficientMinController;
  late TextEditingController _pedestrianFrictionCoefficientMaxController;
  late TextEditingController _pedestrianMassController;
  late TextEditingController _pedestrianProjectionSpeedMin;
  late TextEditingController _projectionDistanceController;
  late TextEditingController _vehicleHeightFrontController;
  late TextEditingController _vehicleFrictionCoefficientMinController;
  late TextEditingController _vehicleFrictionCoefficientMaxController;
  late TextEditingController _vehicleMassController;
  late TextEditingController slidingDistanceController;
  late Occurrence ocorrence;

  Future<void> _initializeControllersWrap(Occurrence ocorrence) async {
    wrapProjection =
        await WrapHelper.getWrpaProjection(ocorrence.wrapProjectionId!);

    _titleController = TextEditingController(text: ocorrence.title);
    _dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(ocorrence.date));
    _pedestrianHeightCGController = TextEditingController(
        text: wrapProjection?.pedestrianHeightCG.toString() ?? '');
    _pedestrianFrictionCoefficientMinController = TextEditingController(
        text:
            wrapProjection?.pedestrianFrictionCoefficientMin.toString() ?? '');
    _pedestrianFrictionCoefficientMaxController = TextEditingController(
        text:
            wrapProjection?.pedestrianFrictionCoefficientMax.toString() ?? '');
    _projectionDistanceController = TextEditingController(
        text: wrapProjection?.pedestrianProjectionDistance.toString() ?? '');
    _vehicleHeightFrontController = TextEditingController(
        text: wrapProjection?.vehicleHeightFront.toString() ?? '');
    _vehicleFrictionCoefficientMinController = TextEditingController(
        text: wrapProjection?.vehicleFrictionCoefficientMin.toString() ?? '');
    _vehicleFrictionCoefficientMaxController = TextEditingController(
        text: wrapProjection?.vehicleFrictionCoefficientMax.toString() ?? '');
  }

  Future<void> _initializeControllersForward(Occurrence ocorrence) async {
   forwardProjection = await ForwardHelper.getForwardProjection(ocorrence.forwardProjectionId!);
    _titleController = TextEditingController(text: ocorrence.title);
    _dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(ocorrence.date));
     _pedestrianHeightCGController = TextEditingController(
        text: forwardProjection!.pedestrianCGHeight.toString());
    _pedestrianMassController = TextEditingController(
        text: forwardProjection!.pedestrianMass.toString());
    _pedestrianFrictionCoefficientMinController = TextEditingController(
        text: forwardProjection!.pedestrianFrictionCoefficientMin.toString());
    _pedestrianFrictionCoefficientMaxController = TextEditingController(
        text: forwardProjection!.pedestrianFrictionCoefficientMax.toString());
    _projectionDistanceController = TextEditingController(
        text: forwardProjection!.pedestrianProjectionDistance.toString());
   _pedestrianProjectionSpeedMin = TextEditingController(
        text: forwardProjection!.pedestrianProjectionSpeedMin.toString());
  slidingDistanceController = TextEditingController(
        text: forwardProjection!.slidingDistance.toString());
    _vehicleMassController = TextEditingController(
        text: forwardProjection!.vehicleMass.toString());
    

      
  
   

    final double vehicleSpeedNortwesternMin;
    final double vehicleSpeedNortwesternMax;
    final double toorSpeed;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _pedestrianHeightCGController.dispose();
    _pedestrianFrictionCoefficientMinController.dispose();
    _pedestrianFrictionCoefficientMaxController.dispose();
    _projectionDistanceController.dispose();
    _vehicleHeightFrontController.dispose();
    _vehicleFrictionCoefficientMinController.dispose();
    _vehicleFrictionCoefficientMaxController.dispose();
    super.dispose();
  }

  Future<void> _showMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> _showCupertinoDatePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate ?? DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedDate = newDateTime;
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(_selectedDate!);
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await _showCupertinoDatePicker(context);
    } else {
      await _showMaterialDatePicker(context);
    }
  }

  void _updateOccurrence() {
    if (_formKey.currentState!.validate()) {
      final updatedOccurrence = Occurrence(
        id: ocorrence.id,
        title: _titleController.text,
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
        wrapProjectionId: ocorrence.wrapProjectionId,
        forwardProjectionId: ocorrence.forwardProjectionId,
      );

      final updatedWrapProjection = WrapProjection(
        id: ocorrence.wrapProjectionId,
        pedestrianHeightCG: double.parse(_pedestrianHeightCGController.text),
        pedestrianFrictionCoefficientMin:
            double.parse(_pedestrianFrictionCoefficientMinController.text),
        pedestrianFrictionCoefficientMax:
            double.parse(_pedestrianFrictionCoefficientMaxController.text),
        pedestrianProjectionSpeedMin:
            wrapProjection?.pedestrianProjectionSpeedMin ?? 0,
        pedestrianProjectionSpeedMax:
            wrapProjection?.pedestrianProjectionSpeedMax ?? 0,
        pedestrianProjectionDistance:
            double.parse(_projectionDistanceController.text),
        vehicleHeightFront: double.parse(_vehicleHeightFrontController.text),
        vehicleFrictionCoefficientMin:
            double.parse(_vehicleFrictionCoefficientMinController.text),
        vehicleFrictionCoefficientMax:
            double.parse(_vehicleFrictionCoefficientMaxController.text),
        vehicleSpeedSearleMin: wrapProjection?.vehicleSpeedSearleMin ?? 0,
        vehicleSpeedSearleMax: wrapProjection?.vehicleSpeedSearleMax ?? 0,
        vehicleSpeedLimpertMin: wrapProjection?.vehicleSpeedLimpertMin ?? 0,
        vehicleSpeedLimpertMax: wrapProjection?.vehicleSpeedLimpertMax ?? 0,
      );

     
      OccurrenceHelper()
          .updateOccurrence(updatedOccurrence.id!, updatedOccurrence);
      WrapHelper().updateWrapProjection(
          ocorrence.wrapProjectionId!, updatedWrapProjection);

      Navigator.pop(context);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira um valor';
          }
          // Adiciona uma validação extra para garantir que o valor é numérico
          if (double.tryParse(value.replaceAll(',', '.')) == null) {
            return 'Por favor, insira um número válido';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ocorrence = ModalRoute.of(context)!.settings.arguments as Occurrence;
    return FutureBuilder(
      future: _initializeControllersWrap(ocorrence),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        } else {
          return Scaffold(
            appBar: AppBar(
                title: const Text(
              'Editar Ocorrência',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'ocorrence_title'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'ocorrence_date'.tr(),
                          hintText: 'dd/MM/yyyy ou use o calendário',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => _selectDate(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma data';
                          }

                          // Regex para validar o formato dd/MM/yyyy
                          final dateRegExp = RegExp(
                            r'^\d{2}/\d{2}/\d{4}$',
                          );

                          if (!dateRegExp.hasMatch(value)) {
                            return 'Formato de data inválido. Use dd/MM/yyyy';
                          }

                          // Verificar se a data é válida
                          try {
                            _selectedDate =
                                DateFormat('dd/MM/yyyy').parseStrict(value);
                            return null;
                          } catch (e) {
                            return 'Data inválida';
                          }
                        },
                      ),
                    ),
                    _buildTextField(_pedestrianHeightCGController,
                        'Altura do CG do Pedestre'),
                    _buildTextField(_pedestrianFrictionCoefficientMinController,
                        'Coeficiente de Atrito Mínimo do Pedestre'),
                    _buildTextField(_pedestrianFrictionCoefficientMaxController,
                        'Coeficiente de Atrito Máximo do Pedestre'),
                    _buildTextField(
                        _projectionDistanceController, 'Distância de Projeção'),
                    _buildTextField(_vehicleHeightFrontController,
                        'Altura Frontal do Veículo'),
                    _buildTextField(_vehicleFrictionCoefficientMinController,
                        'Coeficiente de Atrito Mínimo do Veículo'),
                    _buildTextField(_vehicleFrictionCoefficientMaxController,
                        'Coeficiente de Atrito Máximo do Veículo'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateOccurrence,
                      child: const Text(
                        'Atualizar',
                        style: TextStyle(
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
          );
        }
      },
    );
  }
}
*/