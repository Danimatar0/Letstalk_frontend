import 'package:flutter/material.dart';

import '../../../core/constants/AppConstants.dart';
import '../../../core/constants/ColorConstants.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.fullPhotoTitle,
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        // child: PhotoView(
        //   imageProvider: NetworkImage(url),
        // ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(url),
        ),
      ),
    );
  }
}
