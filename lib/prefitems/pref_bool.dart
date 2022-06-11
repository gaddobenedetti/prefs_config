import 'package:flutter/material.dart';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';

class PrefBool extends PrefItem {
  PrefBool(
      {required Pref pref,
      required BuildContext context,
      required Function callback})
      : super(pref: pref, context: context, callback: callback);

  @override
  Widget prefValue() {
    switch (pref.format) {
      case Pref.FORMAT_BOOL_CHECKBOX:
        return Checkbox(
            value: pref.value,
            onChanged: !pref.enabled
                ? null
                : (bool) {
                    pref.value = bool;
                    if (callback != null) {
                      callback!(pref);
                    }
                  });
      case Pref.FORMAT_BOOL_SWITCH:
      default:
        return Switch(
            value: pref.value,
            onChanged: !pref.enabled
                ? null
                : (bool) {
                    pref.value = bool;
                    if (callback != null) {
                      callback!(pref);
                    }
                  });
    }
  }
}
