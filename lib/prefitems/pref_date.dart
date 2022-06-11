import 'package:flutter/material.dart';
import 'dart:async';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';

class PrefDate extends PrefItem {
  PrefDate(
      {required Pref pref,
      required BuildContext context,
      required Function callback})
      : super(pref: pref, context: context, callback: callback);

  @override
  Widget prefValue() {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(pref.value.toString());
    } catch (e) {}
    return Text(
      _formatDate(date, pref.format ?? Pref.FORMAT_DATE_DMY),
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

      final DateTime? day = await showDatePicker(
          context: context!,
          initialDate: date,
          firstDate: DateTime(DateTime.now().year - 30),
          lastDate: DateTime(DateTime.now().year + 30));

      if (day != null) {
        pref.value = day;
        callback!(pref);
      }
    }
  }

  String _formatDate(DateTime date, int format) {
    const String div = '/';
    String y = date.year.toString();
    String m = (date.month < 10 ? '0' : '') + date.month.toString();
    String d = (date.day < 10 ? '0' : '') + date.day.toString();

    switch (format) {
      case Pref.FORMAT_DATE_MDY:
        return m + div + d + div + y;
      case Pref.FORMAT_DATE_YMD:
        return y + div + m + div + d;
      case Pref.FORMAT_DATE_DMY:
      default:
        return d + div + m + div + y;
    }
  }
}
