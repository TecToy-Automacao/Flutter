import 'package:flutter/material.dart';

AppBar appBarWidget(String title, bool icon) {
  return AppBar(
    title: Text(title),
    elevation: 10,
    actions: icon
        ? <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ]
        : null,
  );
}
