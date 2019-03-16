import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';
import 'package:prefs_config/shared/preflistedit.dart';


class PrefList extends PrefItem {

  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefList({this.pref, this.context, this.callback}) {
    this.actionFunc = editDialog;
  }

  @override
  Widget prefValue () {
    if (this.pref.listItems != null
        && this.pref.listItems.containsKey(this.pref.value)) {
      return Text(
        this.pref.listItems[this.pref.value],
        style: TextStyle(
          fontFamily: "Roboto",
          fontSize: 18.0,
          color: this.pref.enabled ? null : Colors.grey,
        ),
      );
    } else {
      return Container(width: 0.0, height: 0.0);
    }
  }

  Future<void> editDialog () async {
    if (this.pref.listItems != null && this.pref.listItems.isNotEmpty) {
      int result = await showDialog(
        context: this.context,
        builder: (BuildContext context) => PrefListEdit(pref: this.pref,),
      );

      if (result != null) {
        pref.value = result;
        this.callback(pref);
      }
    }
  }

}