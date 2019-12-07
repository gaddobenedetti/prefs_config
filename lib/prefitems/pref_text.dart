import 'package:flutter/material.dart';
import 'dart:async';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';
import 'package:prefs_config/shared/preftextedit.dart';

class PrefText extends PrefItem {
  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefText({this.pref, this.context, this.callback}) {
    this.actionFunc = editDialog;
  }

  @override
  Widget prefValue() {
    String text = pref.value == null ? '' : pref.value.toString();
    if (text.length > 15) text = text.substring(0, 14) + '...';
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 18.0,
        color: this.pref.enabled ? null : Colors.grey,
      ),
    );
  }

  Future<void> editDialog() async {
    String result = await showDialog(
      context: this.context,
      builder: (BuildContext context) => PrefTextEdit(
        pref: this.pref,
      ),
    );

    if (result != null) {
      pref.value = result;
      this.callback(pref);
    }
  }
}
