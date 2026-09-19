import 'package:flutter/animation.dart';

class AppCurves {
  AppCurves._();

  static const Curve gentle = Curves.easeOutCubic;
  static const Curve smooth = Curves.easeInOut;
  static const Curve expressive = Curves.fastOutSlowIn;
  static const Curve spring = SpringSimulationCurve();
  static const Curve bounce = Curves.elasticOut;
}

class SpringSimulationCurve extends Curve {
  const SpringSimulationCurve();

  @override
  double transformInternal(double t) {
    return 1 - (1 - t) * (1 - t) * ((1.5 + 1) * (1 - t) - 1.5);
  }
}
