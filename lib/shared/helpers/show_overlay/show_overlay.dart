import 'package:flutter/material.dart';

import 'show_overlay_controller.dart';

class ShowOverlay {
  ShowOverlay._sharedInstance();
  static final ShowOverlay _shared = ShowOverlay._sharedInstance();
  factory ShowOverlay.instance() => _shared;
  ShowOverlayController? controller;

  void show({
    required BuildContext context,
    required Widget body,
    List<Widget>? otherWidget,
  }) {
    controller =
        showOverlay(context: context, body: body, otherWidget: otherWidget);
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  ShowOverlayController showOverlay(
      {required BuildContext context,
      required Widget body,
      List<Widget>? otherWidget}) {
    final state = Overlay.of(context);
    final size = MediaQuery.of(context).size;

    final OverlayEntry overlay = OverlayEntry(
      maintainState: true,
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.92,
                maxHeight: size.height * 0.83,
                // minHeight: size.height * 0.6,
                minWidth: size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller?.close();
                        },
                      ),
                      if (otherWidget != null)
                        for (var item in otherWidget) item
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
      },
    );

    state.insert(overlay);

    return ShowOverlayController(
      close: () {
        overlay.remove();
      },
    );
  }
}
