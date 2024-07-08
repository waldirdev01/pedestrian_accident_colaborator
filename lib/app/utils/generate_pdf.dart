import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/forward_projection.dart';
import '../models/occurrence.dart';
import '../models/wrap_projection.dart';

Future<pw.Document> _generatePDFDocumentWrap(
    WrapProjection wrapProjection, Occurrence occurrence) async {
  final pdf = pw.Document();

  // Carrega a imagem dos assets para a visualização do cenário.
  final fwLateralBytes =
      await rootBundle.load('assets/images/wrap_lateral.png');
  final wrapLateral = pw.MemoryImage(fwLateralBytes.buffer.asUint8List());

  // Função para criar célula com bordas apenas nas colunas
  pw.Widget borderedCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          right: pw.BorderSide(color: PdfColors.black, width: 1),
        ),
      ),
    );
  }

  pdf.addPage(
    pw.Page(build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(
            level: 0,
            text: 'Resultados dos Cálculos'.tr(),
            textStyle: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Center(
            child: pw.Image(wrapLateral, width: 300, height: 180),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.blue, width: 1),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Parâmetro',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Valor',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Unidade',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Altura CG do pedestre'),
                  borderedCell(wrapProjection.pedestrianHeightCG.toString()),
                  borderedCell('m'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Coeficiente de atrito mínimo do pedestre'),
                  borderedCell(wrapProjection.pedestrianFrictionCoefficientMin
                      .toString()),
                  borderedCell(''),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Coeficiente de atrito máximo do pedestre'),
                  borderedCell(wrapProjection.pedestrianFrictionCoefficientMax
                      .toString()),
                  borderedCell(''),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Distância total de projeção'),
                  borderedCell(
                      wrapProjection.pedestrianProjectionDistance.toString()),
                  borderedCell('m'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Altura da frente do veículo'),
                  borderedCell(wrapProjection.vehicleHeightFront.toString()),
                  borderedCell('m'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade mínima de projeção do pedestre'),
                  borderedCell(wrapProjection.pedestrianProjectionSpeedMin
                      .toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade máxima de projeção do pedestre'),
                  borderedCell(wrapProjection.pedestrianProjectionSpeedMax
                      .toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade mínima do Veículo (Modelo Searle)'),
                  borderedCell(
                      wrapProjection.vehicleSpeedSearleMin.toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade máxima do Veículo (Modelo Searle)'),
                  borderedCell(
                      wrapProjection.vehicleSpeedSearleMax.toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade mínima do Veículo (Modelo Limpert)'),
                  borderedCell(
                      wrapProjection.vehicleSpeedLimpertMin.toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade máxima do Veículo (Modelo Limpert)'),
                  borderedCell(
                      wrapProjection.vehicleSpeedLimpertMax.toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
            ],
          ),
        ],
      );
    }),
  );

  return pdf;
}

void printOrSharePDFWrap(
  WrapProjection wrapProjection,
  Occurrence occurence,
  BuildContext context,
) async {
  FocusScope.of(context).unfocus();
  final pdf = await _generatePDFDocumentWrap(wrapProjection, occurence);

  // ignore: use_build_context_synchronously
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Preview PDF',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: PdfPreview(
          build: (format) async => await pdf.save(),
        ),
      ),
    ),
  );
}

Future<pw.Document> _generatePDFDocumentForward(
    ForwardProjection forwardProjection, Occurrence occurence) async {
  final pdf = pw.Document();

  // Carrega a imagem dos assets para a visualização do cenário.
  final fwLateralBytes =
      await rootBundle.load('assets/images/wrap_lateral.png');
  final wrapLateral = pw.MemoryImage(fwLateralBytes.buffer.asUint8List());

  // Função para criar célula com bordas apenas nas colunas
  pw.Widget borderedCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          right: pw.BorderSide(color: PdfColors.black, width: 1),
        ),
      ),
    );
  }

  pdf.addPage(
    pw.Page(build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(
            level: 0,
            text: 'Resultados dos Cálculos'.tr(),
            textStyle: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Center(
            child: pw.Image(wrapLateral, width: 300, height: 180),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.blue, width: 1),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Parâmetro',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Valor',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Unidade',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Altura CG do pedestre'),
                  borderedCell(forwardProjection.pedestrianCGHeight.toString()),
                  borderedCell('m'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Coeficiente de atrito mínimo do pedestre'),
                  borderedCell(forwardProjection
                      .pedestrianFrictionCoefficientMin
                      .toString()),
                  borderedCell(''),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Coeficiente de atrito máximo do pedestre'),
                  borderedCell(forwardProjection
                      .pedestrianFrictionCoefficientMax
                      .toString()),
                  borderedCell(''),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Distância total de projeção'),
                  borderedCell(forwardProjection.pedestrianProjectionDistance
                      .toString()),
                  borderedCell('m'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Distância de deslizamento'),
                  borderedCell(
                      forwardProjection.slidingDistance.toStringAsFixed(2)),
                  borderedCell('m'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Massa do veículo'),
                  borderedCell(forwardProjection.vehicleMass.toString()),
                  borderedCell('kg'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Massa do pedestre'),
                  borderedCell(forwardProjection.pedestrianMass.toString()),
                  borderedCell('kg'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade mínima de projeção do pedestre'),
                  borderedCell(forwardProjection.pedestrianProjectionSpeedMin
                      .toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade máxima de projeção do pedestre'),
                  borderedCell(forwardProjection.pedestrianProjectionSpeedMax
                      .toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell(
                      'Velocidade Mínima do Veículo (Modelo Northwestern)'),
                  borderedCell(forwardProjection.vehicleSpeedNortwesternMin
                      .toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell(
                      'Velocidade Máxima do Veículo (Modelo Northwestern)'),
                  borderedCell(forwardProjection.vehicleSpeedNortwesternMax
                      .toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
              pw.TableRow(
                children: [
                  borderedCell('Velocidade (Modelo Toor)'),
                  borderedCell(forwardProjection.toorSpeed.toStringAsFixed(0)),
                  borderedCell('km/h'),
                ],
              ),
            ],
          ),
        ],
      );
    }),
  );

  return pdf;
}

void printOrSharePDFForward(ForwardProjection forwardProjection,
    Occurrence occurence, BuildContext context) async {
  final pdf = await _generatePDFDocumentForward(forwardProjection, occurence);

  // ignore: use_build_context_synchronously
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Preview PDF',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: PdfPreview(
          build: (format) async => await pdf.save(),
        ),
      ),
    ),
  );
}
