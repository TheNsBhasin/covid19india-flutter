import 'package:covid19india/core/common/widgets/sort_arrow.dart';
import 'package:covid19india/core/common/widgets/sticky_headers_table.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_top.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TableOption { STATES, DISTRICTS }

class SortData extends Equatable {
  final bool ascending;
  final STATISTIC statistic;
  final STATISTIC_TYPE type;
  final bool perMillion;

  SortData({this.ascending, this.statistic, this.type, this.perMillion});

  SortData copyWith(
      {bool ascending,
      STATISTIC statistic,
      STATISTIC_TYPE type,
      bool perMillion}) {
    return SortData(
        ascending: ascending ?? this.ascending,
        statistic: statistic ?? this.statistic,
        type: type ?? this.type,
        perMillion: perMillion ?? this.perMillion);
  }

  @override
  List<Object> get props => [ascending, statistic, type, perMillion];

  @override
  bool get stringify => true;
}

class DailyCountTable extends StatefulWidget {
  final Map<String, StateWiseDailyCount> stateWiseDailyCount;
  final Map<String, DistrictWiseDailyCount> districtWiseDailyCount;

  DailyCountTable({this.stateWiseDailyCount, this.districtWiseDailyCount});

  @override
  _DailyCountTableState createState() => _DailyCountTableState();
}

class _DailyCountTableState extends State<DailyCountTable> {
  TableOption tableOption;
  SortData sortData;

  List<String> titleRow;
  List<String> titleColumn;

  _DailyCountTableState()
      : tableOption = TableOption.STATES,
        sortData = new SortData(
          ascending: false,
          statistic: STATISTIC.CONFIRMED,
          type: STATISTIC_TYPE.DELTA,
          perMillion: false,
        ),
        titleRow = <String>[],
        titleColumn = <String>[];

  @override
  void initState() {
    super.initState();

    titleRow = _getTitleRow();
    titleColumn = _getTitleColumn();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyCountTableTop(
          district: tableOption == TableOption.DISTRICTS,
          perMillion: sortData.perMillion,
          setDistrict: () {
            setState(() {
              tableOption = (tableOption == TableOption.DISTRICTS)
                  ? TableOption.STATES
                  : TableOption.DISTRICTS;
              titleRow = _getTitleRow();
            });
          },
          setPerMillion: () {
            setState(() {
              sortData = sortData.copyWith(perMillion: !sortData.perMillion);
            });
          },
        ),
        Expanded(
          child: StickyHeadersTable(
            rowsLength: titleRow.length,
            columnsLength: titleColumn.length,
            legendCell: _buildLegendCell(
                onTap: () {
                  setState(() {
                    if (sortData.statistic == null) {
                      sortData =
                          sortData.copyWith(ascending: !sortData.ascending);
                    } else {
                      sortData = SortData(
                          ascending: sortData.ascending,
                          statistic: null,
                          type: sortData.type,
                          perMillion: sortData.perMillion);
                    }

                    titleRow = sortColumn(sortData);
                  });
                },
                child: _buildHeading(
                  label: tableOption == TableOption.STATES
                      ? "State/UT"
                      : "Districts",
                  numeric: false,
                  sorted: sortData.statistic == null,
                  ascending: sortData.ascending,
                )),
            rowsTitleBuilder: (int rowIndex) {
              if (tableOption == TableOption.STATES) {
                return _buildRowTitle(
                    child: _buildTitle(
                        text: (titleRow[rowIndex] == "TT"
                            ? "Total"
                            : STATE_CODE_MAP[titleRow[rowIndex]])));
              } else {
                return _buildRowTitle(
                    child: _buildTitle(text: (titleRow[rowIndex])));
              }
            },
            columnsTitleBuilder: (int columnIndex) {
              return _buildColumnTitle(
                  onTap: () {
                    setState(() {
                      if (sortData.statistic == TABLE_STATISTICS[columnIndex]) {
                        sortData =
                            sortData.copyWith(ascending: !sortData.ascending);
                      } else {
                        sortData = sortData.copyWith(
                            statistic: TABLE_STATISTICS[columnIndex]);
                      }

                      titleRow = sortColumn(sortData);
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      if (sortData.statistic == TABLE_STATISTICS[columnIndex]) {
                        sortData = sortData.copyWith(
                            type: sortData.type == STATISTIC_TYPE.DELTA
                                ? STATISTIC_TYPE.TOTAL
                                : STATISTIC_TYPE.DELTA);
                      } else {
                        sortData = sortData.copyWith(
                            statistic: TABLE_STATISTICS[columnIndex]);
                      }

                      titleRow = sortColumn(sortData);
                    });
                  },
                  child: _buildHeading(
                      label: titleColumn[columnIndex].capitalize(),
                      numeric: true,
                      sorted:
                          sortData.statistic == TABLE_STATISTICS[columnIndex],
                      ascending: sortData.ascending,
                      arrowColor: _arrowColor(
                          statistic: sortData.statistic,
                          delta: sortData.type == STATISTIC_TYPE.DELTA)));
            },
            contentCellBuilder: (int columnIndex, int rowIndex) {
              if (tableOption == TableOption.STATES) {
                String stateCode = titleRow[rowIndex];
                STATISTIC statistics = TABLE_STATISTICS[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.stateWiseDailyCount[stateCode], statistics));
              } else {
                String districtName = titleRow[rowIndex];
                STATISTIC statistics = TABLE_STATISTICS[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.districtWiseDailyCount[districtName],
                        statistics));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeading({
    String label,
    bool numeric,
    bool sorted,
    bool ascending,
    Color arrowColor,
  }) {
    return Row(
      mainAxisAlignment:
          numeric ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black87
                : Colors.white70,
          ),
        )),
        if (sorted) _buildSortArrow(ascending: ascending, color: arrowColor),
      ],
    );
  }

  Widget _buildSortArrow({bool ascending, Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SortArrow(down: !ascending, color: color),
    );
  }

  Widget _buildTitle({String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? Colors.black87
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(dynamic data, STATISTIC statistics) {
    return Row(
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
                  child: _getDeltaText(data, statistics),
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Container(
                  child: _getTotalText(data, statistics),
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ]);
  }

  Widget _buildLegendCell(
      {@required Widget child, @required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        width: CellDimensions.base.stickyLegendWidth,
        height: CellDimensions.base.stickyLegendHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
        decoration: BoxDecoration(
          border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        ),
      ),
    );
  }

  Widget _buildRowTitle({@required Widget child}) {
    return Container(
      width: CellDimensions.base.stickyLegendWidth,
      height: CellDimensions.base.contentCellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: child,
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      ),
    );
  }

  Widget _buildColumnTitle(
      {@required Widget child,
      @required onTap,
      @required VoidCallback onLongPress}) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        width: CellDimensions.base.contentCellWidth,
        height: CellDimensions.base.stickyLegendHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
        decoration: BoxDecoration(
          border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        ),
      ),
    );
  }

  Widget _buildContentCell({@required Widget child}) {
    return Container(
      width: CellDimensions.base.contentCellWidth,
      height: CellDimensions.base.contentCellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: child,
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      ),
    );
  }

  _getDeltaText(dynamic data, STATISTIC statistics) {
    int value = getStatistics(data, STATISTIC_TYPE.DELTA, statistics,
        perMillion: sortData.perMillion);

    return Text(
      (value < 0 ? "↓" : "↑") +
          NumberFormat.decimalPattern('en_IN').format(value),
      style: TextStyle(
          fontSize: 12,
          color: value > 0 ? STATS_COLOR[statistics] : Colors.transparent),
    );
  }

  _getTotalText(dynamic data, statistics) {
    int value = getStatistics(data, STATISTIC_TYPE.TOTAL, statistics,
        perMillion: sortData.perMillion);

    return Text(
      NumberFormat.decimalPattern('en_IN').format(value),
      style: TextStyle(
        fontSize: 12,
        color: (Theme.of(context).brightness == Brightness.light)
            ? Colors.black87
            : Colors.white70,
      ),
    );
  }

  Color _arrowColor({STATISTIC statistic, bool delta}) {
    if (delta) {
      return STATS_COLOR[statistic];
    }

    return (Theme.of(context).brightness == Brightness.light)
        ? Colors.black87
        : Colors.white70;
  }

  List<String> _getTitleColumn() {
    return TABLE_STATISTICS.map((e) => e.name).toList();
  }

  List<String> _getTitleRow() {
    return sortColumn(sortData);
  }

  List<String> sortColumn(SortData sortData) {
    if (tableOption == TableOption.STATES) {
      return _sortStateColumn(sortData);
    } else {
      return _sortDistrictColumn(sortData).sublist(0, DISTRICT_TABLE_COUNT);
    }
  }

  int _compareStats(dynamic a, dynamic b,
      {ascending: true,
      type: STATISTIC_TYPE.TOTAL,
      statistic: STATISTIC.CONFIRMED,
      perMillion: false}) {
    if (ascending) {
      return getStatistics(a, type, statistic, perMillion: perMillion)
          .compareTo(getStatistics(b, type, statistic, perMillion: perMillion));
    } else {
      return getStatistics(b, type, statistic, perMillion: perMillion)
          .compareTo(getStatistics(a, type, statistic, perMillion: perMillion));
    }
  }

  List<String> _sortStateColumn(SortData sortData) {
    if (sortData.statistic == null) {
      if (sortData.ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[a].name
                  .compareTo(widget.stateWiseDailyCount[b].name))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[b].name
                  .compareTo(widget.stateWiseDailyCount[a].name))
              ..add('TT');
      }
    }

    return widget.stateWiseDailyCount.keys
        .toList()
        .where((stateCode) => stateCode != 'TT')
        .toList()
          ..sort((a, b) => _compareStats(
              widget.stateWiseDailyCount[a], widget.stateWiseDailyCount[b],
              ascending: sortData.ascending,
              type: sortData.type,
              statistic: sortData.statistic,
              perMillion: sortData.perMillion))
          ..add('TT');
  }

  List<String> _sortDistrictColumn(SortData sortData) {
    if (sortData.statistic == null) {
      if (sortData.ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].name
              .compareTo(widget.districtWiseDailyCount[b].name));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].name
              .compareTo(widget.districtWiseDailyCount[a].name));
      }
    }

    return widget.districtWiseDailyCount.keys
        .toList()
        .where((stateCode) => stateCode != 'TT')
        .toList()
          ..sort((a, b) => _compareStats(widget.districtWiseDailyCount[a],
              widget.districtWiseDailyCount[b],
              ascending: sortData.ascending,
              type: sortData.type,
              statistic: sortData.statistic,
              perMillion: sortData.perMillion))
          ..add('TT');
  }
}
