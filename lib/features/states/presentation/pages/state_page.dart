import 'package:covid19india/core/common/widgets/covid_19_india_app_bar.dart';
import 'package:flutter/material.dart';

class StatePageArguments {
  final String stateCode;

  StatePageArguments(this.stateCode);
}

class StatePage extends StatefulWidget {
  static const routeName = '/state';

  final String stateCode;

  StatePage({this.stateCode});

  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: covid19IndiaAppBar(),
      body: Container(),
    );
  }
}
