import 'package:grizzly_scales/grizzly_scales.dart';
import 'dart:math' as math;

class SqrtInterpolator implements Interpolator<num> {
  final num a;

  final num b;

  const SqrtInterpolator(this.a, this.b);

  num transformSqrt(num x) {
    return x < 0 ? -math.sqrt(-x) : math.sqrt(x);
  }

  num transformSquare(num x) {
    return x < 0 ? -x * x : x * x;
  }

  @override
  num interpolate(num t) =>
      transformSqrt(a) + ((transformSqrt(b) - transformSqrt(a)) * t);

  @override
  num deinterpolate(num t) => transformSquare(b) != transformSquare(a)
      ? (t - transformSquare(a)) / (transformSquare(b) - transformSquare(a))
      : 0;
}

class SqrtScale<DT extends num> extends Continuous<DT>
    implements Scale<DT, num> {
  SqrtScale(List<DT> domain, List<num> range)
      : super(domain, range, (a, b) => SqrtInterpolator(a, b));
}
