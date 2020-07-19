import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/entity/time_series_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesPills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSeriesChartBloc, TimeSeriesChartState>(
      buildWhen: (previous, current) => previous.option != current.option,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...TimeSeriesOption.values
                  .map((e) => FlatButton(
                        color: (e == state.option)
                            ? Colors.orange.withAlpha(100)
                            : Colors.orange.withAlpha(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        onPressed: () {
                          context
                              .bloc<TimeSeriesChartBloc>()
                              .add(TimeSeriesOptionChanged(option: e));
                        },
                        child: Text(e.name,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                      ))
                  .toList()
            ],
          ),
        );
      },
    );
  }
}
