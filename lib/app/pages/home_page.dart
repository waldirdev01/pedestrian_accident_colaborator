import 'package:flutter/material.dart';

import '../utils/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selecione uma opção',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/atropelamento.png'),
                        fit: BoxFit.fill,
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.kOCORRENCELISTPAGE)),
            ),
            const SizedBox(height: 20),
            Card(
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/marcas_frenagem.png'),
                      fit: BoxFit.fill,
                    ),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                onTap: () => Navigator.pushNamed(context, Routes.kTIREMARKS),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
