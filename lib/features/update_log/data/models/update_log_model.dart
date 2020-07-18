import 'package:covid19india/features/update_log/domain/entities/update_log.dart';

class UpdateLogModel extends UpdateLog {
  UpdateLogModel({String update, DateTime timestamp})
      : super(update: update, timestamp: timestamp);

  UpdateLogModel copyWith({String update, DateTime timestamp}) {
    return UpdateLogModel(
      update: update ?? this.update,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory UpdateLogModel.fromEntity(UpdateLog entity) {
    return UpdateLogModel(
      update: entity.update,
      timestamp: entity.timestamp,
    );
  }

  UpdateLog toEntity() {
    return UpdateLog(
      update: this.update,
      timestamp: this.timestamp,
    );
  }

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
