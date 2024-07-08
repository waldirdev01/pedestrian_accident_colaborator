// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';

class SlopDragFactor extends StatefulWidget {
  const SlopDragFactor({super.key});

  @override
  _SlopDragFactorState createState() => _SlopDragFactorState();
}

class _SlopDragFactorState extends State<SlopDragFactor> {
  final _formKey = GlobalKey<FormState>();
  double _coeficienteAtrito = 0.0;
  double _inclinacao = 0.0;
  double _fatorArrasto = 0.0;
  bool _isMenorQue10 = true;
  String _tipoInclinacao = 'Subida';

  void _calcularFatorArrasto() {
    if (_formKey.currentState!.validate()) {
      double inclinacaoAjustada = _inclinacao;
      if (_tipoInclinacao != 'Subida') {
        inclinacaoAjustada = -_inclinacao; // Inclinação negativa para subida
      }
      setState(() {
        if (_isMenorQue10) {
          // Usando a Equação 9
          _fatorArrasto = _coeficienteAtrito + inclinacaoAjustada;
        } else {
          // Usando a Equação 8
          _fatorArrasto = (_coeficienteAtrito + inclinacaoAjustada) /
              sqrt(1 + pow(inclinacaoAjustada, 2));
        }
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Fator de Arrasto',
        style: TextStyle(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Coeficiente de Atrito (μ)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _coeficienteAtrito =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o coeficiente de atrito';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Inclinação', hintText: '0.1'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _inclinacao =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a inclinação';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Inclinação',
                ),
                value: _tipoInclinacao,
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoInclinacao = newValue!;
                  });
                },
                items: <String>['Subida', 'Descida']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                title: const Text('Inclinação menor que 10%',
                    style: TextStyle(fontSize: 18)),
                value: _isMenorQue10,
                onChanged: (bool value) {
                  setState(() {
                    _isMenorQue10 = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularFatorArrasto,
                child: const Text('Calcular',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Text(
                'Fator de Arrasto (f): ${_fatorArrasto.toStringAsFixed(3)}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
