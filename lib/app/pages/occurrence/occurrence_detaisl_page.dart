import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pedestrian_accident_colaborator/app/widgets/forward_widget_result.dart';
import 'package:pedestrian_accident_colaborator/app/widgets/wrap_widget_result.dart';

import '../../helpers/forward_helper.dart';
import '../../helpers/wrap_helper.dart';
import '../../models/forward_projection.dart';
import '../../models/occurrence.dart';
import '../../models/wrap_projection.dart';
import '../../utils/generate_pdf.dart';
import '../determining_cause.dart';

class OccurrenceDetailsPage extends StatefulWidget {
  const OccurrenceDetailsPage({super.key});

  @override
  State<OccurrenceDetailsPage> createState() => _OccurrenceDetailsPageState();
}

class _OccurrenceDetailsPageState extends State<OccurrenceDetailsPage> {
  WrapProjection? wrapperProjection;
  ForwardProjection? forwardProjection;

  Future<void> getWrapProjection(Occurrence occurrence) async {
    if (occurrence.wrapProjectionId != null) {
      wrapperProjection =
          await WrapHelper.getWrpaProjection(occurrence.wrapProjectionId!);
    }
  }

  Future<void> getForwardProjection(Occurrence occurrence) async {
    if (occurrence.forwardProjectionId != null) {
      forwardProjection = await ForwardHelper.getForwardProjection(
          occurrence.forwardProjectionId!);
    }
  }

  Future<void> _getOccurrenceType(Occurrence occurrence) async {
    if (occurrence.wrapProjectionId != null) {
      await getWrapProjection(occurrence);
    } else {
      await getForwardProjection(occurrence);
    }
  }

  @override
  Widget build(BuildContext context) {
    final occurrence = ModalRoute.of(context)!.settings.arguments as Occurrence;
    return Scaffold(
      appBar: AppBar(
        title: Text('occurrence_details'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          FutureBuilder(
              future: _getOccurrenceType(occurrence),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar o tipo de atropelamento'),
                    );
                  } else {
                    if (wrapperProjection != null) {
                      return Column(
                        children: [
                          WrapWidgetResult(
                              wrapProjection: wrapperProjection!,
                              occurrence: occurrence),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DeterminingCause(
                                        occurrence: occurrence,
                                        wrapProjection: wrapperProjection!)));
                              },
                              child: const Text(
                                  'Verificar Causa do Atropelamento?'))
                        ],
                      );
                    } else if (forwardProjection != null) {
                      return Column(
                        children: [
                          ForwardWidgetResult(
                              forwardProjection: forwardProjection!,
                              occurrence: occurrence),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DeterminingCause(
                                        occurrence: occurrence,
                                        forwardProjection:
                                            forwardProjection!)));
                              },
                              child: const Text(
                                  'Verificar Causa do Atropelamento?'))
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Nenhum dado de projeção disponível'),
                      );
                    }
                  }
                }
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => wrapperProjection != null
            ? printOrSharePDFWrap(wrapperProjection!, occurrence, context)
            : printOrSharePDFForward(forwardProjection!, occurrence, context),
        child: const Icon(Icons.print, color: Colors.white),
      ),
    );
  }
}

Widget buildText(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(text, style: TextStyle(color: Theme.of(context).primaryColor)),
  );
}
