import 'package:flutter/material.dart';
import 'dart:async';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';
import '../shared/preftextedit.dart';
import '../shared/prefslideredit.dart';

class PrefInt extends PrefItem {
  PrefInt(
      {required Pref pref,
      required BuildContext context,
      required Function callback})
      : super(pref: pref, context: context, callback: callback) {
    actionFunc = editDialog;
  }

  @override
  Widget prefValue() {
    String text = pref.value.toString();
    if (text.length > 100) text = '${text.substring(0, 97)}...';
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 18.0,
        color: pref.enabled ? null : Colors.grey,
      ),
    );
  }

  Future<void> editDialog() async {
    int? result;

    if (pref.format == Pref.FORMAT_INT_SLIDER &&
        context != null &&
        pref.min != null &&
        pref.max != null &&
        pref.min! <= pref.max!) {
      result = await showDialog(
        context: context!,
        builder: (BuildContext context) => PrefSliderEdit(
          pref: pref,
        ),
      );
    } else if (context != null) {
      String? numStr = await showDialog(
        context: context!,
        builder: (BuildContext context) => PrefTextEdit(
          pref: pref,
        ),
      );
      if (numStr != null) {
        result = int.parse(numStr);
      }
    }

    if (result != null) {
      if (callback != null) {
        pref.value = result;
        callback!(pref);
      }
    }
  }
}
