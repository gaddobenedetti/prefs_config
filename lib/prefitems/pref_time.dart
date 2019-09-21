import 'package:flutter/material.dart';
import 'dart:async';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';

class PrefTime extends PrefItem {
  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefTime({this.pref, this.context, this.callback}) {
    this.actionFunc = editDialog;
  }

  @override
  Widget prefValue() {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(this.pref.value.toString());
    } catch (e) {}
    return Text(
      _formatTime(date),
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 18.0,
        color: this.pref.enabled ? null : Colors.grey,
      ),
    );
  }

  Future<void> editDialog() async {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(pref.value.toString());
    } catch (e) {}

    final TimeOfDay time = await showTimePicker(
      context: this.context,
      initialTime: TimeOfDay.fromDateTime(date),
    );

    if (time != null) {
      date = DateTime(date.year, date.month, date.day, time.hour, time.minute,
          date.second, date.millisecond, date.microsecond);
      this.pref.value = date;
      this.callback(this.pref);
    }
  }

  String _formatTime(DateTime time) {
    String h = (time.hour < 10 ? '0' : '') + time.hour.toString();
    String m = (time.minute < 10 ? '0' : '') + time.minute.toString();
    return h + ':' + m;
  }
}
