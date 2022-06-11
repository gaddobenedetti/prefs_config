import 'package:flutter/material.dart';
import 'dart:async';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';
import '../shared/preflistedit.dart';

class PrefList extends PrefItem {
  PrefList(
      {required Pref pref,
      required BuildContext context,
      required Function callback})
      : super(pref: pref, context: context, callback: callback) {
    actionFunc =
        this.pref.format == Pref.FORMAT_LIST_DIALOG ? editDialog : null;
  }

  @override
  Widget prefValue() {
    if (context != null && pref.listItems.containsKey(pref.value)) {
      switch (pref.format) {
        case Pref.FORMAT_LIST_DIALOG:
          String value = pref.listItems.containsKey([pref.value])
              ? pref.listItems[pref.value]!
              : "";
          return SizedBox(
            width: (MediaQuery.of(context!).size.width / 2) - 20.0,
            child: Text(
              value,
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18.0,
                color: pref.enabled ? null : Colors.grey,
              ),
            ),
          );
        case Pref.FORMAT_LIST_DROPDOWN:
        default:
          List<ListMap> listData = [];
          for (int key in pref.listItems.keys) {
            String value =
                pref.listItems.containsKey(key) ? pref.listItems[key]! : "";
            listData.add(ListMap(key: key, value: value));
          }
          return SizedBox(
            width: (MediaQuery.of(context!).size.width / 2) - 20.0,
            child: DropdownButton<int>(
              isExpanded: true,
              value: pref.value,
              onChanged: (int? newValue) {
                if (callback != null && newValue != null) {
                  pref.value = newValue;
                  callback!(pref);
                }
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
      return const SizedBox(width: 0.0, height: 0.0);
    }
  }

  Future<void> editDialog() async {
    if (context != null && pref.listItems.isNotEmpty) {
      int? result = await showDialog(
        context: context!,
        builder: (BuildContext context) => PrefListEdit(
          pref: pref,
        ),
      );

      if (result != null) {
        if (callback != null) {
          pref.value = result;
          callback!(pref);
        }
      }
    }
  }
}

class ListMap {
  int key;
  String value;
  ListMap({required this.key, required this.value});
}
