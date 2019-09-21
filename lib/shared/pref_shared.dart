import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';

class PrefItem {
  Pref pref;
  BuildContext context;
  Function actionFunc;
  Function callback;

  PrefItem({this.pref, this.context, this.callback}) {
    this.actionFunc = null;
  }

  Widget getItem() {
    if (this.pref == null) {
      return Container(width: 0.0, height: 0.0);
    } else {
      Widget wrapper = prefWrapper();
      return this.actionFunc == null || !this.pref.enabled
          ? wrapper
          : GestureDetector(onTap: () => this.actionFunc(), child: wrapper);
    }
  }

  Widget prefWrapper() {
    String label = this.pref.label == null ? "" : this.pref.label;
    String description =
        this.pref.description == null ? "" : this.pref.description;

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
                            label,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: this.pref.enabled ? null : Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14.0,
                            color: this.pref.enabled ? null : Colors.grey,
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
    return Container(width: 0.0, height: 0.0);
  }
}
