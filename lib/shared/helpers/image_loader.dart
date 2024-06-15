import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

Widget imageLoader(String image) {
  final ref = FirebaseStorage.instance.ref().child('images/$image');
  return FutureBuilder(
    future: ref.getDownloadURL(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
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
      } else {
        return Container();
      }
    },
  );
}
