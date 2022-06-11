import 'package:flutter/material.dart';
import 'dart:async';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';

class PrefTime extends PrefItem {
  PrefTime(
      {required Pref pref,
      required BuildContext context,
      required Function callback})
      : super(pref: pref, context: context, callback: callback) {
    actionFunc = editDialog;
  }

  @override
  Widget prefValue() {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(pref.value.toString());
    } catch (e) {}
    return Text(
      _formatTime(date),
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 18.0,
        color: pref.enabled ? null : Colors.grey,
      ),
    );
  }

  Future<void> editDialog() async {
    if (context != null && callback != null) {
      DateTime date = DateTime.now();
      try {
        date = DateTime.parse(pref.value.toString());
      } catch (e) {}

      final TimeOfDay? time = await showTimePicker(
        context: context!,
        initialTime: TimeOfDay.fromDateTime(date),
      );

      if (time != null) {
        date = DateTime(date.year, date.month, date.day, time.hour, time.minute,
            date.second, date.millisecond, date.microsecond);
        pref.value = date;
        callback!(pref);
      }
    }
  }

  String _formatTime(DateTime time) {
    String h = (time.hour < 10 ? '0' : '') + time.hour.toString();
    String m = (time.minute < 10 ? '0' : '') + time.minute.toString();
    return '$h:$m';
  }
}
