import 'package:flutter/material.dart';

class MasterDetailLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;

  const MasterDetailLayout({required this.master, required this.detail});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Material(
                  elevation: 4,
                  child: master,
                ),
              ),
              Flexible(
                flex: 3,
                child: Material(
                  elevation: 4,
                  child: detail,
                ),
              ),
            ],
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Character Viewer'),
            ),
            body: master,
          );
        }
      },
    );
  }
}
