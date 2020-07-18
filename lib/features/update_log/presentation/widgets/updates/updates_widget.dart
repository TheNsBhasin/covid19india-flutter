import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/features/update_log/presentation/widgets/updates/updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateLogBloc, UpdateLogState>(
      builder: (context, state) {
        if (state is UpdateLogLoadInProgress) {
          return LoadingWidget(height: 72);
        } else if (state is UpdateLogLoadSuccess) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Updates(updateLogs: state.updateLogs),
          );
        } else if (state is UpdateLogLoadFailure) {
          return MessageDisplay(
            message: state.message,
          );
        }

        return Container();
      },
    );
  }
}
