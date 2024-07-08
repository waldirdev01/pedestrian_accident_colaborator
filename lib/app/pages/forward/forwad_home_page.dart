import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/occurrence.dart';
import '../../utils/routes.dart';

class ForwardHomePage extends StatelessWidget {
  const ForwardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final occurrence = ModalRoute.of(context)!.settings.arguments as Occurrence;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'forward_projection'.tr(),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: InkWell(
                child: Image.asset('assets/images/fw_lateral.png'),
                onTap: () {
                  Navigator.pushNamed(context, Routes.kFWZOOM);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                mainAxisSpacing: 10, // Espaçamento vertical entre os tiles
                crossAxisSpacing: 8, // Espaçamento horizontal entre os tiles
                crossAxisCount: 1, // Número de colunas no grid
                childAspectRatio:
                    15 / 6, // Altere a proporção aqui para ajustar o tamanho
                children: [
                  Card(
                    shadowColor: Theme.of(context).primaryColor,
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Icon(
                          Icons.checklist,
                          size: 100,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, Routes.kFORWARDCHECKLIST),
                    ),
                  ),
                  Card(
                    shadowColor: Theme.of(context).primaryColor,
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Icon(
                          Icons.camera_alt,
                          size: 100,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, Routes.kPHOTOGRAPHCHECKLISTPAGE),
                    ),
                  ),
                  Card(
                    shadowColor: Theme.of(context).primaryColor,
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Icon(
                          Icons.calculate_rounded,
                          size: 100,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, Routes.kFORWARDCALCULATION,
                          arguments: occurrence),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}