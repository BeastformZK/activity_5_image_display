import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // Using a FutureBuilder since thumbnailData is future type
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        //no data, display a spinner
        if (bytes == null) {
          return const CircularProgressIndicator(
            backgroundColor: Colors.blue,
            valueColor: AlwaysStoppedAnimation(Colors.orange),
            strokeWidth: 10,
          );
        }
        // If there's data, display it as an image
        return InkWell(
          onTap: () {},
          child:
              // wrapping image in a Positioned.fill to fill the space
              Positioned.fill(
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
