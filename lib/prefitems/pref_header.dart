import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';

class PrefHeader extends PrefItem {
  Pref pref;
  Function actionFunc;

  PrefHeader({this.pref}) {
    this.actionFunc = null;
  }

  @override
  Widget prefWrapper() {
    if (pref.label == null || pref.label.length == 0) {
      return Container(width: 0.0, height: 0.0);
    } else {
      return Card(
        color: pref.defVal == null ? Colors.white30 : pref.defVal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            pref.label.toString(),
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
