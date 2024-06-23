class CustomSwiper {
  static const Map<AnimationType, List<AnimationOffset>> animations = {
    AnimationType.none: [
      AnimationOffset(0.6, 1.0, -1.0, -0.1),
      AnimationOffset(0.25, -1, 0.02, 1.1),
      AnimationOffset(0.25, -1.3, 0.35, 1.3),
      AnimationOffset(0.22, -1.5, 0.5, 1.5),
      AnimationOffset(0.25, 0.2, 0.6, 0.8),
    ],
    AnimationType.animation: [
      AnimationOffset(0.9, 0.8, 0.0, -0.3),
      AnimationOffset(0.25, 0.1, -0.1, 0),
      AnimationOffset(0.25, 0.1, 0.3, 0.45),
      AnimationOffset(0.2, 0.1, 0.5, 0.65),
      AnimationOffset(0.25, 0.2, 0.55, 0.8),
    ],
  };
}

enum AnimationType {
  none,
  animation,
}

enum MoveType {
  none,
  up,
  down,
}

class AnimationOffset {
  final double top;
  final double right;
  final double bottom;
  final double left;
  final double? scale;
  final double? opacity;

  const AnimationOffset(
    this.top,
    this.right,
    this.bottom,
    this.left, [
    this.scale,
    this.opacity,
  ]);
}