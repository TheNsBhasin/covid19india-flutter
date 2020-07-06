import 'package:covid19india/features/update_log/domain/entities/update_log.dart';

class UpdateLogModel extends UpdateLog {
  UpdateLogModel({String update, DateTime timestamp})
      : super(update: update, timestamp: timestamp);

  factory UpdateLogModel.fromJson(Map<String, dynamic> json) {
    return UpdateLogModel(
        update: json['update'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            json['timestamp'].toInt() * 1000));
  }

  Map<String, dynamic> toJson() {
    return {
      'update': update,
      'timestamp': timestamp.millisecondsSinceEpoch / 1000
    };
  }
}
