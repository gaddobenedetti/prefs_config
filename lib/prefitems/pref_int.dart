import 'package:flutter/material.dart';
import 'dart:async';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';
import 'package:prefs_config/shared/preftextedit.dart';
import 'package:prefs_config/shared/prefslideredit.dart';

class PrefInt extends PrefItem {

  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefInt({this.pref, this.context, this.callback}) {
    this.actionFunc = editDialog;
  }

  @override
  Widget prefValue () {
    String text = pref.value.toString();
    if(text.length > 100)
      text = text.substring(0, 97) + '...';
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 18.0,
        color: this.pref.enabled ? null : Colors.grey,
      ),
    );
  }

  Future<void> editDialog () async {
    int result;

    if (pref.format == Pref.FORMAT_INT_SLIDER &&
        pref.min != null && pref.max != null && pref.min <= pref.max) {
      result = await showDialog(
        context: this.context,
        builder: (BuildContext context) => PrefSliderEdit(pref: this.pref,),
      );
    } else {
      String numStr = await showDialog(
        context: this.context,
        builder: (BuildContext context) => PrefTextEdit(pref: this.pref,),
      );
      result = int.parse(numStr);
    }

    if (result != null) {
      this.pref.value = result;
      this.callback(this.pref);
    }

  }

}