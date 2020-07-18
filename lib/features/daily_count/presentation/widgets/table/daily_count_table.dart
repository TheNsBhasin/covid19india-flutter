import 'package:covid19india/core/common/widgets/sort_arrow.dart';
import 'package:covid19india/core/common/widgets/sticky_headers_table.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/entity/statistic_type.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_top.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TableOption { STATES, DISTRICTS }

class SortData extends Equatable {
  final bool ascending;
  final Statistic statistic;
  final StatisticType type;
  final bool perMillion;

  SortData({this.ascending, this.statistic, this.type, this.perMillion});

  SortData copyWith(
      {bool ascending,
      Statistic statistic,
      StatisticType type,
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
  final Map<MapCodes, StateDailyCount> stateDailyCounts;
  final Map<String, DistrictDailyCount> districtDailyCounts;

  DailyCountTable({this.stateDailyCounts, this.districtDailyCounts});

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
          statistic: Statistic.confirmed,
          type: StatisticType.delta,
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
                        text: (titleRow[rowIndex] == MapCodes.TT.key
                            ? "Total"
                            : titleRow[rowIndex].toMapCode().name)));
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
                            type: sortData.type == StatisticType.delta
                                ? StatisticType.total
                                : StatisticType.delta);
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
                          delta: sortData.type == StatisticType.delta)));
            },
            contentCellBuilder: (int columnIndex, int rowIndex) {
              if (tableOption == TableOption.STATES) {
                MapCodes stateCode = titleRow[rowIndex].toMapCode();
                Statistic statistics = TABLE_STATISTICS[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.stateDailyCounts[stateCode], statistics));
              } else {
                String districtName = titleRow[rowIndex];
                Statistic statistics = TABLE_STATISTICS[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.districtDailyCounts[districtName], statistics));
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

  Widget _buildStats(dynamic data, Statistic statistics) {
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

  _getDeltaText(dynamic data, Statistic statistics) {
    int value = getStatistics(data, StatisticType.delta, statistics,
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
    int value = getStatistics(data, StatisticType.total, statistics,
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

  Color _arrowColor({Statistic statistic, bool delta}) {
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
      return _sortStateColumn(sortData).map((e) => e.key).toList();
    } else {
      return _sortDistrictColumn(sortData).sublist(0, DISTRICT_TABLE_COUNT);
    }
  }

  int _compareStats(dynamic a, dynamic b,
      {ascending: true,
      type: StatisticType.total,
      statistic: Statistic.confirmed,
      perMillion: false}) {
    if (ascending) {
      return getStatistics(a, type, statistic, perMillion: perMillion)
          .compareTo(getStatistics(b, type, statistic, perMillion: perMillion));
    } else {
      return getStatistics(b, type, statistic, perMillion: perMillion)
          .compareTo(getStatistics(a, type, statistic, perMillion: perMillion));
    }
  }

  List<MapCodes> _sortStateColumn(SortData sortData) {
    if (sortData.statistic == null) {
      if (sortData.ascending) {
        return widget.stateDailyCounts.keys
            .toList()
            .where((stateCode) => stateCode != MapCodes.TT)
            .toList()
              ..sort((a, b) => widget.stateDailyCounts[a].stateCode.name
                  .compareTo(widget.stateDailyCounts[b].stateCode.name))
              ..add(MapCodes.TT);
      } else {
        return widget.stateDailyCounts.keys
            .toList()
            .where((stateCode) => stateCode != MapCodes.TT)
            .toList()
              ..sort((a, b) => widget.stateDailyCounts[b].stateCode.name
                  .compareTo(widget.stateDailyCounts[a].stateCode.name))
              ..add(MapCodes.TT);
      }
    }

    return widget.stateDailyCounts.keys
        .toList()
        .where((stateCode) => stateCode != MapCodes.TT)
        .toList()
          ..sort((a, b) => _compareStats(
              widget.stateDailyCounts[a], widget.stateDailyCounts[b],
              ascending: sortData.ascending,
              type: sortData.type,
              statistic: sortData.statistic,
              perMillion: sortData.perMillion))
          ..add(MapCodes.TT);
  }

  List<String> _sortDistrictColumn(SortData sortData) {
    if (sortData.statistic == null) {
      if (sortData.ascending) {
        return widget.districtDailyCounts.keys.toList()
          ..sort((a, b) => widget.districtDailyCounts[a].name
              .compareTo(widget.districtDailyCounts[b].name));
      } else {
        return widget.districtDailyCounts.keys.toList()
          ..sort((a, b) => widget.districtDailyCounts[b].name
              .compareTo(widget.districtDailyCounts[a].name));
      }
    }

    return widget.districtDailyCounts.keys
        .toList()
        .where((stateCode) => stateCode != 'TT')
        .toList()
          ..sort((a, b) => _compareStats(
              widget.districtDailyCounts[a], widget.districtDailyCounts[b],
              ascending: sortData.ascending,
              type: sortData.type,
              statistic: sortData.statistic,
              perMillion: sortData.perMillion))
          ..add('TT');
  }
}
