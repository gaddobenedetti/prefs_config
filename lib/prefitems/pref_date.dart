import 'package:flutter/material.dart';
import 'dart:async';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';


class PrefDate extends PrefItem {

  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefDate({this.pref, this.context, this.callback}) {
    this.actionFunc = editDialog;
  }

  @override
  Widget prefValue () {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(this.pref.value.toString());
    } catch (e) {}
    return Text(
      _formatDate(date, this.pref.format),
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 18.0,
        color: this.pref.enabled ? null : Colors.grey,
      ),
    );
  }

  Future<void> editDialog () async {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(pref.value.toString());
    } catch (e) {}

    final DateTime day = await showDatePicker(
        context: this.context,
        initialDate: date,
        firstDate: DateTime(DateTime.now().year - 30),
        lastDate: DateTime(DateTime.now().year + 30)
    );

    if (day != null) {
      this.pref.value = day;
      this.callback(this.pref);
    }

  }

  String _formatDate (DateTime date, int format) {
    final String div = '/';
    String y = date.year.toString();
    String m = (date.month < 10 ? '0' : '') + date.month.toString();
    String d = (date.day < 10 ? '0' : '') + date.day.toString();

    switch(format) {
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