import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';


class PrefBool extends PrefItem {

  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefBool({this.pref, this.context, this.callback}) {
    this.actionFunc = null;
  }

  @override
  Widget prefValue () {
    switch(this.pref.format) {
      case Pref.FORMAT_BOOL_CHECKBOX:
        return Checkbox(
            value: pref.value,
            onChanged: !this.pref.enabled ? null : (bool) {
              this.pref.value = bool;
              this.callback(this.pref);
            }
        );
      case Pref.FORMAT_BOOL_SWITCH:
      default:
      return Switch(
          value: pref.value,
          onChanged: !this.pref.enabled ? null : (bool) {
            this.pref.value = bool;
            this.callback(this.pref);
          }
      );
    }
  }

}