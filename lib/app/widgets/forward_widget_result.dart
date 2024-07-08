import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forward_projection.dart';
import '../models/occurrence.dart';
import '../pages/occurrence/occurrence_detaisl_page.dart';

class ForwardWidgetResult extends StatelessWidget {
  const ForwardWidgetResult(
      {super.key, required this.forwardProjection, required this.occurrence});
  final ForwardProjection forwardProjection;
  final Occurrence occurrence;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(occurrence.title),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(occurrence.date)),
            ),
            buildText(
                'Altura do CG do pedestre: ${forwardProjection.pedestrianCGHeight} m',
                context),
            buildText(
                'Massa do pedestre: ${forwardProjection.pedestrianMass} kg',
                context),
            buildText(
                'Coeficiente de atrito mínimo do pedestre: ${forwardProjection.pedestrianFrictionCoefficientMin}',
                context),
            buildText(
                'Coeficiente de atrito máximo do pedestre: ${forwardProjection.pedestrianFrictionCoefficientMax}',
                context),
            buildText(
                'Fator de arrasto mínimo do veículo: ${forwardProjection.vehicleFrictionCoefficientMin}',
                context),
            buildText(
                'Fator de arrasto máximo do veículo: ${forwardProjection.vehicleFrictionCoefficientMax}',
                context),
            buildText(
                'Velocidade mínima de Projeção: ${forwardProjection.pedestrianProjectionSpeedMin} km/h',
                context),
            buildText(
                'Velocidade máxima de Projeção: ${forwardProjection.pedestrianProjectionSpeedMax} km/h',
                context),
            buildText(
                'Distância de projeção do pedestre: ${forwardProjection.pedestrianProjectionDistance} m',
                context),
            buildText(
                'Distância de deslizamento: ${forwardProjection.slidingDistance} m',
                context),
            buildText('Massa do veículo: ${forwardProjection.vehicleMass} kg',
                context),
            buildText(
                'Velocidade mínima do veículo (Northwestern): ${forwardProjection.vehicleSpeedNortwesternMin.toStringAsFixed(2)} km/h',
                context),
            buildText(
                'Velocidade máxima do veículo (Northwestern): ${forwardProjection.vehicleSpeedNortwesternMax.toStringAsFixed(2)} km/h',
                context),
            buildText(
                'Velocidade do Toor: ${forwardProjection.toorSpeed.toStringAsFixed(2)} km/h',
                context),
          ],
        ),
      ),
    );
  }
}
