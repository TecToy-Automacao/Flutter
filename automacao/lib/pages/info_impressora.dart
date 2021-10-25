import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';

class InfoImpressora extends StatefulWidget {
  final String title;
  const InfoImpressora({Key? key, required this.title}) : super(key: key);

  @override
  _InfoImpressoraState createState() => _InfoImpressoraState();
}

class _InfoImpressoraState extends State<InfoImpressora> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title, true),
      backgroundColor: Constants.background,
    );
  }
}
