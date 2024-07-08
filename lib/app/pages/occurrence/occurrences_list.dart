import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../helpers/ocorrence_helper.dart';
import '../../utils/routes.dart';
import '../../widgets/ocurrence_card.dart';

class OccurrenciesList extends StatefulWidget {
  const OccurrenciesList({
    super.key,
  });

  @override
  State<OccurrenciesList> createState() => _OccurrenciesListState();
}

class _OccurrenciesListState extends State<OccurrenciesList> {
  Future<void> sharePdfFromAssets() async {
    // Carrega o arquivo PDF dos assets
    final ByteData bytes =
        await rootBundle.load('assets/arquives/fundamentacao.pdf');
    final Uint8List list = bytes.buffer.asUint8List();

    await Printing.sharePdf(bytes: list, filename: 'fundamentacao.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'yours_ocorrencies'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () => sharePdfFromAssets(),
                icon: const Icon(Icons.picture_as_pdf))
          ],
        ),
        body: Consumer(
            builder: (builder, OccurrenceHelper ocorrenceProvider, child) {
          ocorrenceProvider.getAllOccurrencies();
          final ocorrencies = ocorrenceProvider.occurrences;
          return ListView.builder(
              itemCount: ocorrencies.length,
              itemBuilder: (context, index) {
                final ocorrence = ocorrencies[index];
                return OcurrenceCard(occurrence: ocorrence);
              });
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.kOCORRENCECREATEPAGE),
          child: const Icon(Icons.add, color: Colors.white),
        ));
  }
}
