import 'package:flutter/material.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/edp.dart';

class ImageEditor extends StatelessWidget {
  final Epd epd;
  const ImageEditor({super.key, required this.epd});

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    final List<img.Image> processedImgs = List.empty(growable: true);
    final orgImg = imgLoader.image;

    if (orgImg != null) {
      final resizedImage =
          img.copyResize(orgImg, width: epd.width, height: epd.height);
      for (final method in epd.processingMethods) {
        processedImgs.add(method(resizedImage));
      }
    }

    final imgList = ImageList(
      imgList: processedImgs,
      epd: epd,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await context
                  .read<ImageLoader>()
                  .pickImage(width: epd.width, height: epd.height);
              if (context.mounted) {
                await context.read<ImageLoader>().startImageEditing(context);
              }
            },
            child: const Text("Import Image"),
          ),
        ],
      ),
      body: Center(child: imgList),
    );
  }
}
