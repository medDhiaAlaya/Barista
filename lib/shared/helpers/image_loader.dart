import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget imageLoader(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) {
      return Container(
        decoration: BoxDecoration(image: DecorationImage(image: imageProvider)),
      );
    },
    placeholder: (context, url) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    },
    errorWidget: (context, url, error) {
      return const Center(
        child: Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    },
  );
}
