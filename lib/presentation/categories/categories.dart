import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  final String coffeeId;
  const CategoriesScreen({super.key,required this.coffeeId});


  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}