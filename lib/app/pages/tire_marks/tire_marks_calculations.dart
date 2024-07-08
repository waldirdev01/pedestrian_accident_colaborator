// ignore_for_file: library_private_types_in_public_api, unused_field

import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/coeficient.dart';

class TireMarksCalculations extends StatefulWidget {
  const TireMarksCalculations({super.key});

  @override
  _TireMarksCalculationsState createState() => _TireMarksCalculationsState();
}

class _TireMarksCalculationsState extends State<TireMarksCalculations> {
  final _formKey = GlobalKey<FormState>();
  Coeficiente? _coeficiente;
  bool _isPasseio = true;
  double _distanciaFrenagem = 0.0;
  double _coeficienteMin = 0.0;
  double _coeficienteMax = 0.0;
  double _velocidadeMin = 0.0;
  double _velocidadeMax = 0.0;

  final List<Coeficiente> _coeficientes = [
    Coeficiente('Asfalto novo', 0.85, 0.60, 0.60, 0.42),
    Coeficiente('Asfalto velho', 0.70, 0.55, 0.49, 0.39),
    Coeficiente('Asfalto escorregadio', 0.55, 0.35, 0.39, 0.25),
    Coeficiente('Concreto novo', 0.85, 0.55, 0.60, 0.39),
    Coeficiente('Concreto velho', 0.70, 0.55, 0.49, 0.39),
    Coeficiente('Pedra limpa', 0.60, 0.40, 0.42, 0.28),
    Coeficiente('Pedregulho', 0.65, 0.65, 0.46, 0.46),
    Coeficiente('Terra dura', 0.65, 0.70, 0.46, 0.49),
    Coeficiente('Terra solta', 0.50, 0.55, 0.35, 0.39),
    Coeficiente('Pavimento com areia sobre', 0.45, 0.30, 0.32, 0.21),
    Coeficiente('Pavimento com barro sobre', 0.45, 0.30, 0.32, 0.21),
    Coeficiente('Barro sobre pedra', 0.40, 0.25, 0.28, 0.18),
    Coeficiente('Pavimento com neve sobre', 0.30, 0.20, 0.21, 0.14),
    Coeficiente('Gelo cristal', 0.15, 0.07, 0.11, 0.05),
  ];

  void _calcularVelocidadeDissipada() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _velocidadeMin =
            3.6 * sqrt(2 * _coeficienteMin * 9.81 * _distanciaFrenagem);
        _velocidadeMax =
            3.6 * sqrt(2 * _coeficienteMax * 9.81 * _distanciaFrenagem);
      });
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Velocidade pela Frenagem',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                title: const Text('Tipo de Veículo',
                    style: TextStyle(fontSize: 18)),
                subtitle: Text(_isPasseio ? 'Veículo de Passeio' : 'Caminhão'),
                value: _isPasseio,
                onChanged: (bool value) {
                  setState(() {
                    _isPasseio = value;
                  });
                },
              ),
              DropdownButtonFormField<Coeficiente>(
                decoration: const InputDecoration(
                  labelText: 'Condição da Superfície',
                ),
                items: _coeficientes.map((Coeficiente coef) {
                  return DropdownMenuItem<Coeficiente>(
                    value: coef,
                    child: _isPasseio
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '${coef.condicao}: mín: ${coef.minimoPasseio} máx: ${coef.maximoPasseio}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '${coef.condicao}: mín: ${coef.minimoCaminhao} máx: ${coef.maximoCaminhao}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _coeficiente = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma condição';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Distância de Frenagem (m)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _distanciaFrenagem =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a distância de frenagem';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Coeficiente de Atrito Mínimo'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _coeficienteMin =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o coeficiente de atrito mínimo';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Coeficiente de Atrito Máximo'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _coeficienteMax =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o coeficiente de atrito máximo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularVelocidadeDissipada,
                child: const Text(
                  'Calcular',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Velocidade Dissipada Mínima: ${_velocidadeMin.toStringAsFixed(0)} km/h',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Velocidade Dissipada Máxima: ${_velocidadeMax.toStringAsFixed(0)} km/h',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
