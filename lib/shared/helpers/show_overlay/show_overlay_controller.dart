import 'package:flutter/foundation.dart' show immutable;

typedef CloseOverlay = void Function();
typedef ShowOverlay = void Function();

@immutable
class ShowOverlayController {
  final CloseOverlay close;
  const ShowOverlayController({
    required this.close,
  });
}