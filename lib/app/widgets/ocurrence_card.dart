import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/ocorrence_helper.dart';
import '../models/occurrence.dart';
import '../utils/routes.dart';

class OcurrenceCard extends StatelessWidget {
  const OcurrenceCard({super.key, required this.occurrence});
  final Occurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OccurrenceHelper>(context);
    return Card(
      surfaceTintColor: Theme.of(context).primaryColor,
      shadowColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text('Ocorrência: ${occurrence.title}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            subtitle: Text(
                "Data: ${DateFormat('dd/MM/yyyy').format(occurrence.date)}",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (occurrence.forwardProjectionId != null ||
                      occurrence.wrapProjectionId != null)
                  ? IconButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                          Routes.kOCORRENCEDETAILPAGE,
                          arguments: occurrence),
                      icon: Icon(Icons.visibility,
                          color: Theme.of(context).primaryColor),
                      tooltip: 'Visualizar Ocorrência',
                    )
                  : const SizedBox.shrink(),
              occurrence.forwardProjectionId == null
                  ? IconButton(
                      onPressed: occurrence.wrapProjectionId != null
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(
                                  Routes.kWRAPHOMEPAGE,
                                  arguments: occurrence);
                            },
                      icon: Icon(Icons.car_crash,
                          color: occurrence.wrapProjectionId != null
                              ? null
                              : Theme.of(context).primaryColor),
                      tooltip: 'Criar Wrap Projection',
                      enableFeedback: true,
                    )
                  : const SizedBox.shrink(),
              occurrence.wrapProjectionId == null
                  ? IconButton(
                      onPressed: occurrence.forwardProjectionId != null
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(
                                  Routes.kFORWARDHOMEPAGE,
                                  arguments: occurrence);
                            },
                      icon: Icon(Icons.fire_truck,
                          color: occurrence.forwardProjectionId != null
                              ? null
                              : Theme.of(context).primaryColor),
                      tooltip: 'Criar Forward Projection',
                      enableFeedback: true,
                    )
                  : const SizedBox.shrink(),
              IconButton(
                onPressed: () {
                  provider.deleteOccurrence(occurrence.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ocorrência deletada com sucesso!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Deletar Ocorrência',
                enableFeedback: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
