import 'dart:ui';

import 'package:sidebar_animation/src/coord/base.dart';
import 'package:sidebar_animation/src/engine/render_shape/base.dart';

import '../base.dart';

abstract class Shape {
  List<RenderShape> getRenderShape(
    List<ElementRecord> records,
    CoordComponent coord,
    Offset origin,
  );
}
