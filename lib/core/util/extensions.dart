import 'dart:math';

import 'package:covid19india/core/scale/pow.dart';
import 'package:grizzly_range/grizzly_range.dart' as ranger;
import 'package:grizzly_scales/grizzly_scales.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(this.year, this.month, this.day);
    return aDate == today;
  }

  bool isSameDay(DateTime date) {
    final aDate = DateTime(this.year, this.month, this.day);
    final bDate = DateTime(date.year, date.month, date.day);
    return aDate == bDate;
  }
}

extension ScaleExtension on Scale {
  Function(num) clamper() {
    num a = this.domain.first;
    num b = this.domain.last;

    num t;
    if (a > b) {
      t = a;
      a = b;
      b = t;
    }
    return (num x) {
      return max(a, min(b, x));
    };
  }
}

extension LinearScaleExtension on LinearScale {
  LinearScale nice({count: 10}) {
    List<double> d = this.domain.toList().cast<double>();
    int i0 = 0;
    int i1 = d.length - 1;
    num start = d[i0];
    num stop = d[i1];
    num step;

    if (stop < start) {
      step = start;
      start = stop;
      stop = step;
      step = i0;
      i0 = i1;
      i1 = step;
    }

    step = ranger.tickIncrement(start, stop, count);

    step = ranger.tickIncrement(start, stop, count);

    if (step > 0) {
      start = (start / step).floor() * step;
      stop = (stop / step).ceil() * step;
      step = ranger.tickIncrement(start, stop, count);
    } else if (step < 0) {
      start = (start * step).ceil() / step;
      stop = (stop * step).floor() / step;
      step = ranger.tickIncrement(start, stop, count);
    }

    if (step > 0) {
      d[i0] = ((start / step).floor() * step).toDouble();
      d[i1] = ((stop / step).ceil() * step).toDouble();
    } else if (step < 0) {
      d[i0] = ((start * step).ceil() / step).toDouble();
      d[i1] = ((stop * step).floor() / step).toDouble();
    }

    return new LinearScale(d, this.range);
  }
}

extension SqrtScaleExtension on SqrtScale {
  SqrtScale nice({count: 10}) {
    List d = this.domain.toList();
    int i0 = 0;
    int i1 = d.length - 1;
    num start = d[i0];
    num stop = d[i1];
    num step;

    if (stop < start) {
      step = start;
      start = stop;
      stop = step;
      step = i0;
      i0 = i1;
      i1 = step;
    }

    step = ranger.tickIncrement(start, stop, count);

    step = ranger.tickIncrement(start, stop, count);

    if (step > 0) {
      start = (start / step).floor() * step;
      stop = (stop / step).ceil() * step;
      step = ranger.tickIncrement(start, stop, count);
    } else if (step < 0) {
      start = (start * step).ceil() / step;
      stop = (stop * step).floor() / step;
      step = ranger.tickIncrement(start, stop, count);
    }

    if (step > 0) {
      d[i0] = ((start / step).floor() * step).toDouble();
      d[i1] = ((stop / step).ceil() * step).toDouble();
    } else if (step < 0) {
      d[i0] = ((start * step).ceil() / step).toDouble();
      d[i1] = ((stop * step).floor() / step).toDouble();
    }

    return new SqrtScale(d, this.range);
  }
}

extension LogScaleExtension on LogScale {
  LogScale nice() {
    List d = this.domain.toList();
    int i0 = 0;
    int i1 = d.length - 1;
    num start = d[i0];
    num stop = d[i1];
    num step;

    if (stop < start) {
      step = start;
      start = stop;
      stop = step;
      step = i0;
      i0 = i1;
      i1 = step;
    }

    final _log = LogScale.makeLog(base);

    final _pow = LogScale.makePow(base);

    d[i0] = _pow(_log(start).floorToDouble());
    d[i1] = _pow(_log(stop).ceilToDouble());

    return new LogScale(d, this.range);
  }
}
