import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double height;

  const LoadingWidget({
    this.height,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height ?? MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
