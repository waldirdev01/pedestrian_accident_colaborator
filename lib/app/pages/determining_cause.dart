import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedestrian_accident_colaborator/app/models/forward_projection.dart';
import 'package:pedestrian_accident_colaborator/app/models/wrap_projection.dart';

import '../models/occurrence.dart';

class DeterminingCause extends StatefulWidget {
  final Occurrence occurrence;
  final WrapProjection? wrapProjection;
  final ForwardProjection? forwardProjection;

  const DeterminingCause({
    super.key,
    required this.occurrence,
    this.wrapProjection,
    this.forwardProjection,
  });

  @override
  State<DeterminingCause> createState() => _DeterminingCauseState();
}

class _DeterminingCauseState extends State<DeterminingCause> {
  final _formKey = GlobalKey<FormState>();

  final _distancePedestrianController = TextEditingController();
  final _roadSpeedController = TextEditingController();
  final _brakingDistanceController = TextEditingController();
  final _perceptiotnTimeController = TextEditingController();
  double _trafficSpeedKmh = 0.0;
  String? _speedComparisonResult;
  // ignore: unused_field
  String? _selectedAgeGroup;
  String _determiningCause = '';
  bool _brakingBeforeImpact = false;
  bool _hasForwardProjection = false;
  double? _pedestrianSpeed;
  double _timeBase = 0.0;
  double _possiblePerceptionPoint = 0.0;
  double _percpetionPoint = 0.0;
  double _vehicleSpeedMin = 0.0;
  double _pneSign = 0.0;
  double _brakingTime = 0.0;
  double _frictionCoefficientMin = 0.0;
  double? _percpetionTime;
  double _pontoNaoEscpadaVeiculo = 0.0;

  void _determineInicialSpeedMinAndCoeficientMin() {
    if (widget.wrapProjection != null) {
      _frictionCoefficientMin =
          widget.wrapProjection!.vehicleFrictionCoefficientMin;
      _vehicleSpeedMin = min(
          widget.wrapProjection!.vehicleSpeedLimpertMin / 3.6,
          widget.wrapProjection!.vehicleSpeedSearleMin / 3.6);
    } else if (widget.forwardProjection != null) {
      _frictionCoefficientMin =
          widget.forwardProjection!.vehicleFrictionCoefficientMin;
      _hasForwardProjection = true;
      _vehicleSpeedMin = min(
          widget.forwardProjection!.vehicleSpeedNortwesternMin / 3.6,
          widget.forwardProjection!.toorSpeed / 3.6);
    }
  }

  void _calculateBaseTime() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _timeBase = double.tryParse(_distancePedestrianController.text)! /
            _pedestrianSpeed!;
      });
    }
  }

  void _calculatePNERegularSpeed() {
    if (_formKey.currentState!.validate()) {
      if (_roadSpeedController.text.isEmpty) {
        return;
      }

      final loadeSpeed = double.tryParse(_roadSpeedController.text);
      final roadeSpeed = loadeSpeed! / 3.6;
      setState(() {
        _pneSign = roadeSpeed * _percpetionTime! +
            pow(roadeSpeed, 2) / (2 * _frictionCoefficientMin * 9.81);
      });
    }
  }

  void _determineTrafficSpeedAndPPP() {
    double deltaT = 0;
    if (_formKey.currentState!.validate()) {
      if (_roadSpeedController.text.isEmpty) {
        return;
      }
      if (_brakingBeforeImpact) {
        final brakingDistance =
            double.tryParse(_brakingDistanceController.text);
        double dissipatedVelocity = _hasForwardProjection
            ? sqrt(2 *
                widget.forwardProjection!.vehicleFrictionCoefficientMin *
                9.81 *
                brakingDistance!)
            : sqrt(2 *
                widget.wrapProjection!.vehicleFrictionCoefficientMin *
                9.81 *
                brakingDistance!);
        setState(() {
          _trafficSpeedKmh =
              sqrt(pow(dissipatedVelocity, 2) + pow(_vehicleSpeedMin, 2));

          _brakingTime = (_trafficSpeedKmh - _vehicleSpeedMin) /
              (9.81 * _frictionCoefficientMin);

          _pontoNaoEscpadaVeiculo = _trafficSpeedKmh * _percpetionTime! +
              pow(_trafficSpeedKmh, 2) / (2 * _frictionCoefficientMin * 9.81);

          deltaT = _timeBase - _brakingTime;
        });

        if (deltaT > 0) {
          setState(() {
            _percpetionPoint = _trafficSpeedKmh * _percpetionTime! +
                double.parse(_brakingDistanceController.text);
            _possiblePerceptionPoint = _trafficSpeedKmh * deltaT +
                double.parse(_brakingDistanceController.text);
            _trafficSpeedKmh = _trafficSpeedKmh * 3.6;
          });
        } else {
          setState(() {
            _trafficSpeedKmh = _vehicleSpeedMin;
          });
        }
      } else {
        setState(() {
          _possiblePerceptionPoint = _vehicleSpeedMin * _timeBase;
          _pontoNaoEscpadaVeiculo = _vehicleSpeedMin * _percpetionTime! +
              pow(_vehicleSpeedMin, 2) / (2 * _frictionCoefficientMin * 9.81);

          _trafficSpeedKmh = _vehicleSpeedMin * 3.6;
        });
      }
    }
  }

  void _determinantCause() {
    if (_formKey.currentState!.validate()) {
      if (_roadSpeedController.text.isEmpty) {
        return;
      }
      if (_brakingDistanceController.text.isEmpty) {
        if (_vehicleSpeedMin >
            (double.parse(_roadSpeedController.text) / 3.6)) {
          if (_possiblePerceptionPoint >= _pneSign) {
            setState(() {
              _determiningCause = 'Excesso de velocidade do veículo.';
            });
          } else {
            if (_pontoNaoEscpadaVeiculo >= _pneSign) {
              _determiningCause = 'Reação tardia do motorista.';
            } else {
              setState(() {
                _determiningCause = 'Entrada inopinada do pedestre.';
              });
            }
          }
        } else {
          if (_percpetionPoint >= _pneSign) {
            setState(() {
              _determiningCause = 'Excesso de velocidade do veículo.';
            });
          } else {
            if (_possiblePerceptionPoint > _pneSign) {
              _determiningCause = 'Reação tardia do motorista.';
            } else {
              setState(() {
                _determiningCause = 'Entrada inopinada do pedestre.';
              });
            }
          }
        }
      } else {
        if (_vehicleSpeedMin > double.parse(_roadSpeedController.text) / 3.6) {
          if (_percpetionPoint >= _pneSign) {
            setState(() {
              _determiningCause = 'Excesso de velocidade do veículo.';
            });
          } else {
            if (_possiblePerceptionPoint > _pneSign) {
              _determiningCause = 'Reação tardia do motorista.';
            } else {
              setState(() {
                _determiningCause = 'Entrada inopinada do pedestre.';
              });
            }
          }
        } else {
          if (_percpetionPoint >= _pneSign) {
            setState(() {
              _determiningCause = 'Excesso de velocidade do veículo.';
            });
          } else {
            if (_possiblePerceptionPoint > _pneSign) {
              _determiningCause = 'Reação tardia do motorista.';
            } else {
              setState(() {
                _determiningCause = 'Entrada inopinada do pedestre.';
              });
            }
          }
        }
      }
    }
  }

  final Map<String, double> ageGroupSpeeds = {
    '5-9': 2.41,
    '10-14': 2.10,
    '15-19': 2.07,
    '20-24': 1.86,
    '25-34': 1.98,
    '35-44': 1.95,
    '45-54': 1.74,
    '55-64': 1.68,
    '65+': 1.46,
  };

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Esconde o teclado

      _calculateBaseTime();
      _determineTrafficSpeedAndPPP();
      _calculatePNERegularSpeed();
      _determineTrafficSpeedAndPPP();
      _determinantCause();
    }
  }

  @override
  void initState() {
    _determineInicialSpeedMinAndCoeficientMin();
    super.initState();
  }

  @override
  void dispose() {
    _distancePedestrianController.dispose();
    _roadSpeedController.dispose();
    _brakingDistanceController.dispose();
    _perceptiotnTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encontrar a causa determinante',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Faixa Etária do Pedestre'),
                items: ageGroupSpeeds.keys
                    .map((ageGroup) => DropdownMenuItem<String>(
                          value: ageGroup,
                          child: Text(ageGroup),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAgeGroup = value;
                    _pedestrianSpeed = ageGroupSpeeds[value!];
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a faixa etária do pedestre';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _distancePedestrianController,
                decoration: const InputDecoration(
                  labelText: 'Distância Percorrida pelo Pedestre (m)',
                  hintText:
                      'Distância desde a borda da via até o ponto de impacto',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a distância percorrida pelo pedestre';
                  }
                  final distance = double.tryParse(value);
                  if (distance == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _perceptiotnTimeController,
                decoration: const InputDecoration(
                    labelText: 'Tempo de Percepção (s)', hintText: '1.5'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tempo de percepção (s)';
                  }
                  _percpetionTime = double.tryParse(value);
                  if (_percpetionTime == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _roadSpeedController,
                decoration: const InputDecoration(
                  labelText: 'Velocidade da via (km/h)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a velocidade da via (km/h)';
                  }
                  final speed = double.tryParse(value);
                  if (speed == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Houve frenagem antes do atropelamento?'),
                trailing: DropdownButton<bool>(
                  value: _brakingBeforeImpact,
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Sim'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('Não'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _brakingBeforeImpact = value!;
                    });
                  },
                ),
              ),
              _brakingBeforeImpact
                  ? TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _brakingDistanceController,
                      decoration: const InputDecoration(
                        labelText: 'Comprimento da Marca de Frenagem (m)',
                        hintText:
                            'Comprimento da frenagem até o ponto de impacto',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o comprimento da marca de frenagem (m)';
                        }
                        final distance = double.tryParse(value);
                        if (distance == null) {
                          return 'Por favor, insira um número válido';
                        }
                        return null;
                      },
                    )
                  : const SizedBox.shrink(),
              if (_speedComparisonResult != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _speedComparisonResult!,
                    style: TextStyle(
                      color: _speedComparisonResult ==
                              'Velocidade maior que a mínima permitida'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Calcular',
                    style: TextStyle(color: Colors.white)),
              ),
              Text(
                  'Velocidade do pedestre: ${_pedestrianSpeed?.toStringAsFixed(2)} m/s',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              Text('Tempo base: ${_timeBase.toStringAsFixed(2)} (s)',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              _brakingDistanceController.text.isNotEmpty
                  ? Text(
                      'Ponto de percepção: ${_percpetionPoint.toStringAsFixed(2)} (m)',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor))
                  : const SizedBox.shrink(),
              Text(
                  'Ponto de percepção possível: ${_possiblePerceptionPoint.toStringAsFixed(2)} (m)',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              Text(
                  'PNE do veículo: ${_pontoNaoEscpadaVeiculo.toStringAsFixed(2)} (m)',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              Text(
                  'PNE da velocidade regulamentar: ${_pneSign.toStringAsFixed(2)} (m)',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              Text(
                  'Velocidade mínima do veículo: ${_trafficSpeedKmh.toStringAsFixed(2)} km/h',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              Text('Causa determinante: $_determiningCause',
                  style: TextStyle(
                      fontSize: 16,
                      color: _determiningCause ==
                              'Excesso de velocidade do veículo.'
                          ? Colors.red
                          : Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
