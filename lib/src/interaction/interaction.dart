import 'package:meta/meta.dart';
import 'package:sidebar_animation/src/chart/component.dart';

import 'gesture_arena.dart';

abstract class Interaction {
  Interaction(this.type);

  final GestureType type;
}

class ChartInteraction extends Interaction {
  ChartInteraction({
    @required GestureType type,
    @required this.callback,
  }) : super(type);

  final void Function(GestureEvent, ChartComponent) callback;
}
