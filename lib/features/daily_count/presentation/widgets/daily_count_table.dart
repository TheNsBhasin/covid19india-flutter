import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyCountTable extends StatefulWidget {
  final List<StateWiseDailyCount> dailyCounts;

  DailyCountTable({this.dailyCounts});

  @override
  _DailyCountTableState createState() =>
      _DailyCountTableState(dailyCounts: dailyCounts);
}

class _DailyCountTableState extends State<DailyCountTable> {
  final List<StateWiseDailyCount> dailyCounts;
  int sortColumnIndex;
  bool isAscending;

  _DailyCountTableState({this.dailyCounts});

  @override
  void initState() {
    super.initState();

    sortColumnIndex = 1;
    isAscending = false;
    sortColumn(sortColumnIndex, isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: sortColumnIndex,
        sortAscending: isAscending,
        columns: _getColumns(),
        rows: _getRows(),
      ),
    );
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text((stateData.name == 'TT'
                            ? 'Total'
                            : Constants.STATE_CODE_MAP[stateData.name])
                        .toString()),
                  ))),
              DataCell(Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        (stateData.delta.confirmed > 0
                            ? "↑" +
                                NumberFormat.decimalPattern('en_IN')
                                    .format(stateData.delta.confirmed)
                            : ""),
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(NumberFormat.decimalPattern('en_IN')
                          .format(stateData.total.confirmed)),
                    ],
                  ),
                ),
              )),
              DataCell(Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(""),
                      Text(NumberFormat.decimalPattern('en_IN').format(
                          stateData.total.confirmed -
                              stateData.total.recovered -
                              stateData.total.deceased)),
                    ],
                  ),
                ),
              )),
              DataCell(Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        (stateData.delta.recovered > 0
                            ? "↑" +
                                NumberFormat.decimalPattern('en_IN')
                                    .format(stateData.delta.recovered)
                            : ""),
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(NumberFormat.decimalPattern('en_IN')
                          .format(stateData.total.recovered)),
                    ],
                  ),
                ),
              )),
              DataCell(Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        (stateData.delta.deceased > 0
                            ? "↑" +
                                NumberFormat.decimalPattern('en_IN')
                                    .format(stateData.delta.deceased)
                            : ""),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(NumberFormat.decimalPattern('en_IN')
                          .format(stateData.total.deceased)),
                    ],
                  ),
                ),
              ))
            ]))
        .toList()
        .cast<DataRow>();
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
