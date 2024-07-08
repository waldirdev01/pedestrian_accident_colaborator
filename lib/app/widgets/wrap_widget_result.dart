import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/occurrence.dart';
import '../models/wrap_projection.dart';
import '../pages/occurrence/occurrence_detaisl_page.dart';

class WrapWidgetResult extends StatelessWidget {
  const WrapWidgetResult(
      {super.key, required this.wrapProjection, required this.occurrence});
  final WrapProjection wrapProjection;
  final Occurrence occurrence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Ocorrência: ${occurrence.title}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(occurrence.date),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          buildText(
              'Altura do CG do pedestre: ${wrapProjection.pedestrianHeightCG} m',
              context),
          buildText(
              'Coeficiente de atrito mínimo do pedestre: ${wrapProjection.pedestrianFrictionCoefficientMin}',
              context),
          buildText(
              'Coeficiente de atrito máximo do pedestre: ${wrapProjection.pedestrianFrictionCoefficientMax}',
              context),
          buildText(
              'Velocidade de projeção mínima: ${wrapProjection.pedestrianProjectionSpeedMin} km/h',
              context),
          buildText(
              'Velocidade de projeção máxima: ${wrapProjection.pedestrianProjectionSpeedMax} km/h',
              context),
          buildText(
              'Distância de projeção do pedestre: ${wrapProjection.pedestrianProjectionDistance} m',
              context),
          buildText(
              'Altura da frente do veículo: ${wrapProjection.vehicleHeightFront} m',
              context),
          buildText(
              'Coeficiente de atrito mínimo do veículo: ${wrapProjection.vehicleFrictionCoefficientMin}',
              context),
          buildText(
              'Coeficiente de atrito máximo do veículo: ${wrapProjection.vehicleFrictionCoefficientMax}',
              context),
          buildText(
              'Velocidade mínima do veículo (Searle): ${wrapProjection.vehicleSpeedSearleMin} km/h',
              context),
          buildText(
              'Velocidade máxima do veículo (Searle): ${wrapProjection.vehicleSpeedSearleMax} km/h',
              context),
          buildText(
              'Velocidade mínima do veículo (Limpert): ${wrapProjection.vehicleSpeedLimpertMin} km/h',
              context),
          buildText(
              'Velocidade máxima do veículo (Limpert): ${wrapProjection.vehicleSpeedLimpertMax} km/h',
              context),
        ],
      ),
    );
  }
}
