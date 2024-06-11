import 'package:flutter/material.dart';

class CustomOverlayRoute<T> extends PopupRoute<T> {
  final BuildContext context;
  List<Widget>? otherWidget;
  final Widget body;

  CustomOverlayRoute({required this.body, required this.context});
  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'CustomOverlayRoute';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.black.withAlpha(150),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.92,
            maxHeight: 640,
            minHeight: 640,
            minWidth: size.width * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if (otherWidget != null)
                    for (var item in otherWidget!) item
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
