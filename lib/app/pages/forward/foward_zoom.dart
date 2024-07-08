import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FowardZoom extends StatelessWidget {
  const FowardZoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          'Zoom',
          style: TextStyle(color: Colors.white),
        )),
        body: ListView(
          // Usando ListView para permitir scroll
          children: <Widget>[
            SizedBox(
              // Container para a primeira imagem
              height: 300, // Altura fixa para o container
              child: PhotoView(
                imageProvider: const AssetImage('assets/images/fw_lateral.png'),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white, // Cor de fundo
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              // Container para a segunda imagem
              height: 300, // Altura fixa para o container
              child: PhotoView(
                imageProvider:
                    const AssetImage('assets/images/fw_up_start.png'),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white, // Cor de fundo
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              // Container para a terceira imagem
              height: 300, // Altura fixa para o container
              child: PhotoView(
                imageProvider: const AssetImage('assets/images/fw_up_end.png'),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white, // Cor de fundo
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ],
        ));
  }
}
