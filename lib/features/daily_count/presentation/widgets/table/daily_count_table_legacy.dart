import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyCountTableLegacy extends StatefulWidget {
  final List<StateWiseDailyCount> dailyCounts;

  DailyCountTableLegacy({this.dailyCounts});

  @override
  _DailyCountTableLegacyState createState() =>
      _DailyCountTableLegacyState(dailyCounts: dailyCounts);
}

class _DailyCountTableLegacyState extends State<DailyCountTableLegacy> {
  final List<StateWiseDailyCount> dailyCounts;
  int sortColumnIndex;
  bool isAscending;

  _DailyCountTableLegacyState({this.dailyCounts});

  @override
  void initState() {
    super.initState();

    sortColumnIndex = 1;
    isAscending = false;
    sortColumn(sortColumnIndex, isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dataRowHeight: 80,
            sortColumnIndex: sortColumnIndex,
            sortAscending: isAscending,
            columns: _getColumns(),
            rows: _getRows(),
          ),
        ),
      ),
    ]);
  }

  _getColumns() {
    return <DataColumn>[
      DataColumn(
          label: Text('State/UT'),
          numeric: false,
          onSort: (columnIndex, ascending) {
            handleSortChange(columnIndex, !isAscending);
          }),
      DataColumn(
          label: Text('Confirmed'),
          onSort: (columnIndex, ascending) {
            handleSortChange(columnIndex, !isAscending);
          }),
      DataColumn(
          label: Text('Active'),
          onSort: (columnIndex, ascending) {
            handleSortChange(columnIndex, !isAscending);
          }),
      DataColumn(
          label: Text('Recovered'),
          onSort: (columnIndex, ascending) {
            handleSortChange(columnIndex, !isAscending);
          }),
      DataColumn(
          label: Text('Deceased'),
          onSort: (columnIndex, ascending) {
            handleSortChange(columnIndex, !isAscending);
          }),
    ];
  }

  _getRows() {
    return _getRowsData()
        .map((stateData) => DataRow(cells: [
              DataCell(Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (stateData.name == 'TT'
                                    ? 'Total'
                                    : Constants.STATE_CODE_MAP[stateData.name])
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              DataCell(Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getDeltaText(stateData.delta, 'confirmed'),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getTotalText(stateData.total, 'confirmed'),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ])),
              DataCell(Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getDeltaText(stateData.delta, 'active'),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getTotalText(stateData.total, 'active'),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ])),
              DataCell(Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getDeltaText(stateData.delta, 'recovered'),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getTotalText(stateData.total, 'recovered'),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ])),
              DataCell(Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getDeltaText(stateData.delta, 'deceased'),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            child: _getTotalText(stateData.total, 'deceased'),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ]))
            ]))
        .toList()
        .cast<DataRow>();
  }

  _getDeltaText(Stats delta, statistics) {
    int value = _getStatistics(delta, statistics);

    return Text(
      (value < 0 ? "↓" : "↑") +
          NumberFormat.decimalPattern('en_IN').format(value),
      style: TextStyle(
          color: value > 0
              ? Constants.STATS_COLOR[statistics]
              : Colors.transparent),
    );
  }

  _getTotalText(Stats total, statistics) {
    int value = _getStatistics(total, statistics);

    return Text(NumberFormat.decimalPattern('en_IN').format(value));
  }

  int _getStatistics(Stats data, statistics) {
    if (statistics == 'confirmed') {
      return data.confirmed;
    } else if (statistics == 'active') {
      return data.active;
    } else if (statistics == 'recovered') {
      return data.recovered;
    } else if (statistics == 'deceased') {
      return data.deceased;
    } else if (statistics == 'tested') {
      return data.tested;
    }

    return data.confirmed;
  }

  _getRowsData() {
    return dailyCounts
        .where((stateData) => stateData.name != 'TT')
        .toList()
        .followedBy(
            dailyCounts.where((stateData) => stateData.name == 'TT').toList())
        .toList();
  }

  handleSortChange(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
      sortColumn(columnIndex, ascending);
    });
  }

  sortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        dailyCounts.sort((a, b) => a.name.compareTo(b.name));
      } else {
        dailyCounts.sort((a, b) => b.name.compareTo(a.name));
      }
    } else if (columnIndex == 1) {
      if (ascending) {
        dailyCounts
            .sort((a, b) => a.total.confirmed.compareTo(b.total.confirmed));
      } else {
        dailyCounts
            .sort((a, b) => b.total.confirmed.compareTo(a.total.confirmed));
      }
    } else if (columnIndex == 2) {
      if (ascending) {
        dailyCounts.sort((a, b) => (a.total.confirmed -
                a.total.recovered -
                a.total.deceased)
            .compareTo(
                (b.total.confirmed - b.total.recovered - b.total.deceased)));
      } else {
        dailyCounts.sort((a, b) => (b.total.confirmed -
                b.total.recovered -
                b.total.deceased)
            .compareTo(
                (a.total.confirmed - a.total.recovered - a.total.deceased)));
      }
    } else if (columnIndex == 3) {
      if (ascending) {
        dailyCounts
            .sort((a, b) => a.total.recovered.compareTo(b.total.recovered));
      } else {
        dailyCounts
            .sort((a, b) => b.total.recovered.compareTo(a.total.recovered));
      }
    } else if (columnIndex == 4) {
      if (ascending) {
        dailyCounts
            .sort((a, b) => a.total.deceased.compareTo(b.total.deceased));
      } else {
        dailyCounts
            .sort((a, b) => b.total.deceased.compareTo(a.total.deceased));
      }
    }
  }
}
