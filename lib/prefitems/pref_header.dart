import 'package:flutter/material.dart';
import '../prefs_config.dart';
import '../shared/pref_shared.dart';

class PrefHeader extends PrefItem {
  PrefHeader({required Pref pref}) : super(pref: pref);

  @override
  Widget prefWrapper() {
    if (pref.label.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    } else {
      return Card(
        color: pref.defVal ?? Colors.white30,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            pref.label.toString(),
            style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
