import 'package:flutter/material.dart';
import 'dart:async';
import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';
import 'package:prefs_config/shared/preflistedit.dart';

class PrefList extends PrefItem {
  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefList({this.pref, this.context, this.callback}) {
    this.actionFunc =
        this.pref.format == Pref.FORMAT_LIST_DIALOG ? editDialog : null;
  }

  @override
  Widget prefValue() {
    if (this.pref.listItems != null &&
        this.pref.listItems.containsKey(this.pref.value)) {
      switch (this.pref.format) {
        case Pref.FORMAT_LIST_DIALOG:
          return Container(
            width: (MediaQuery.of(context).size.width / 2) - 20.0,
            child: Text(
              this.pref.listItems[this.pref.value],
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18.0,
                color: this.pref.enabled ? null : Colors.grey,
              ),
            ),
          );
          break;
        case Pref.FORMAT_LIST_DROPDOWN:
        default:
          List<ListMap> listData = List();
          for (int key in this.pref.listItems.keys)
            listData.add(ListMap(key: key, value: this.pref.listItems[key]));

          return Container(
            width: (MediaQuery.of(context).size.width / 2) - 20.0,
            child: DropdownButton<int>(
              isExpanded: true,
              value: this.pref.value,
              onChanged: (int newValue) {
                this.pref.value = newValue;
                this.callback(pref);
              },
              items: listData.map<DropdownMenuItem<int>>((ListMap value) {
                return DropdownMenuItem<int>(
                  value: value.key,
                  child: Text(
                    value.value,
                    maxLines: 2,
                    softWrap: true,
                  ),
                );
              }).toList(),
            ),
          );
      }
    } else {
      return Container(width: 0.0, height: 0.0);
    }
  }

  Future<void> editDialog() async {
    if (this.pref.listItems != null && this.pref.listItems.isNotEmpty) {
      int result = await showDialog(
        context: this.context,
        builder: (BuildContext context) => PrefListEdit(
          pref: this.pref,
        ),
      );

      if (result != null) {
        this.pref.value = result;
        this.callback(pref);
      }
    }
  }
}

class ListMap {
  int key;
  String value;
  ListMap({this.key, this.value});
}
