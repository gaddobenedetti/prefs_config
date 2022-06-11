import 'package:flutter/material.dart';
import 'dart:async';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';
import '../shared/preftextedit.dart';

class PrefText extends PrefItem {
  PrefText(
      {required Pref pref,
      required BuildContext context,
      required Function callback})
      : super(pref: pref, context: context, callback: callback) {
    actionFunc = editDialog;
  }

  @override
  Widget prefValue() {
    String text = pref.value == null ? '' : pref.value.toString();
    if (text.length > 15) text = '${text.substring(0, 14)}...';
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
    if (context != null && callback != null) {
      String? result = await showDialog(
        context: context!,
        builder: (BuildContext context) => PrefTextEdit(
          pref: pref,
        ),
      );

      if (result != null) {
        pref.value = result;
        callback!(pref);
      }
    }
  }
}
