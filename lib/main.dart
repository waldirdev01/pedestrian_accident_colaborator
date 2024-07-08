import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/helpers/ocorrence_helper.dart';
import 'app/pages/forward/forwad_home_page.dart';
import 'app/pages/forward/forward_calculations.dart';
import 'app/pages/forward/forward_checklist_page.dart';
import 'app/pages/forward/foward_zoom.dart';
import 'app/pages/home_page.dart';
import 'app/pages/instructions_for_use.dart';
import 'app/pages/occurrence/occurrence_create_page.dart';
import 'app/pages/occurrence/occurrence_detaisl_page.dart';
import 'app/pages/occurrence/occurrences_list.dart';
import 'app/pages/photograph_check_list_page.dart';
import 'app/pages/splash_page.dart';
import 'app/pages/tire_marks/slop_drag_factor.dart';
import 'app/pages/tire_marks/stopping_distance.dart';
import 'app/pages/tire_marks/tire_marks_calculations.dart';
import 'app/pages/tire_marks/tire_marks_home.dart';
import 'app/pages/warning.dart';
import 'app/pages/wrap/wrap_calculations.dart';
import 'app/pages/wrap/wrap_checklist_page.dart';
import 'app/pages/wrap/wrap_home_page.dart';
import 'app/pages/wrap/wrap_zoom.dart';
import 'app/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('pt', 'BR'),
          Locale('es', ''),
          Locale('fr', ''),
        ],
        path: 'assets/translates',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OccurrenceHelper()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: EasyLocalization.of(context)?.locale,
        title: 'Pedestrian Accident Collaborator',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 9, 30, 170),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromARGB(255, 9, 30, 170),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 9, 30, 170),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
          ),
        ),
        routes: {
          Routes.kSPLASH: (context) => const SplashPage(),
          Routes.kHOME: (context) => const HomePage(),
          Routes.kFORWARDHOMEPAGE: (context) => const ForwardHomePage(),
          Routes.kFWZOOM: (context) => const FowardZoom(),
          Routes.kFORWARDCHECKLIST: (context) => const ForWardChecklistPage(),
          Routes.kPHOTOGRAPHCHECKLISTPAGE: (context) =>
              const PhotographCheckListPage(),
          Routes.kFORWARDCALCULATION: (context) => const ForwardCalculations(),
          Routes.kWRAPHOMEPAGE: (context) => const WrapHomePage(),
          Routes.kWRAPCHECKLIST: (context) => const WrapChecklistPage(),
          Routes.kWRAPZOOM: (context) => const WrapZoom(),
          Routes.kWRAPCALCULATION: (context) => const WrapCalculations(),
          Routes.kWARNINGPAGE: (context) => const WarningPage(),
          Routes.kINSTRUCTIONS: (context) => const InstructionsForUse(),
          Routes.kOCORRENCECREATEPAGE: (context) =>
              const OccurrenceCreatePage(),
          Routes.kOCORRENCEDETAILPAGE: (context) =>
              const OccurrenceDetailsPage(),
          Routes.kOCORRENCELISTPAGE: (context) => const OccurrenciesList(),
          Routes.kTIREMARKS: (context) => const TireMarksHome(),
          Routes.kTIREMARKSCALCULATIONS: (context) =>
              const TireMarksCalculations(),
          Routes.kSLOPDRAGFACTOR: (context) => const SlopDragFactor(),
          Routes.kSTOPPINGDISTANCE: (context) => const StoppingDistance(),
        },
      ),
    );
  }
}
