import 'package:flutter/material.dart';
import '../prefs_config.dart';

class PrefItem {
  Pref pref;
  BuildContext? context;
  Function()? actionFunc;
  Function? callback;

  PrefItem({required this.pref, this.context, this.callback});

  Widget getItem() {
    Widget wrapper = prefWrapper();
    return actionFunc == null || !pref.enabled
        ? wrapper
        : GestureDetector(onTap: actionFunc, child: wrapper);
  }

  Widget prefWrapper() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            pref.label,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: pref.enabled ? null : Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          pref.description,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14.0,
                            color: pref.enabled ? null : Colors.grey,
                          ),
                        ),
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: prefValue(),
              )
            ]),
      ),
    );
  }

  Widget prefValue() {
    return const SizedBox(width: 0.0, height: 0.0);
  }
}
