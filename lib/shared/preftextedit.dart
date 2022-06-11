// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../prefs_config.dart';

class PrefTextEdit extends StatefulWidget {
  final Pref pref;

  const PrefTextEdit({required this.pref});

  @override
  State<PrefTextEdit> createState() => _PrefTextEditState();
}

class _PrefTextEditState extends State<PrefTextEdit> {
  final prefEditController = TextEditingController();
  late bool _canUpdate;

  @override
  void initState() {
    prefEditController.text = '';
    if (widget.pref.value != null) {
      prefEditController.text = widget.pref.value.toString();
    }
    _canUpdate = false;
    super.initState();
  }

  bool _validatePref(Pref pref, String value) {
    bool isValid = true;
    if (pref.value.toString() == value.toString()) isValid = false;

    if (pref.type == Pref.TYPE_INT) {
      if (pref.min != null && int.parse(value) < pref.min!) isValid = false;
      if (pref.max != null && int.parse(value) > pref.max!) isValid = false;
    } else {
      switch (pref.format) {
        case Pref.FORMAT_TEXT_EMAIL:
          String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;'
              r':\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}'
              r'\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)'
              r'+[a-zA-Z]{2,}))$';
          RegExp rX = RegExp(p);
          isValid = rX.hasMatch(value.toString());
          break;
        case Pref.FORMAT_TEXT_URI:
          String p = r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]'
              r'{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';
          RegExp rX = RegExp(p);
          isValid = rX.hasMatch(value.toString());
          break;
        case Pref.FORMAT_TEXT_PHONE:
        // TODO Validate phone number input
        case Pref.FORMAT_TEXT_PLAIN:
        default:
          int len = value.toString().length;
          int min = pref.min == null ? 0 : pref.min!;
          int max = pref.max == null ? 0 : pref.max!;
          if ((len < min) || (len > max && max > 0)) isValid = false;
      }
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    TextInputType kbt;
    if (widget.pref.type == Pref.TYPE_INT) {
      kbt = TextInputType.number;
    } else {
      switch (widget.pref.format) {
        case Pref.FORMAT_TEXT_EMAIL:
          kbt = TextInputType.emailAddress;
          break;
        case Pref.FORMAT_TEXT_PHONE:
          kbt = TextInputType.phone;
          break;
        case Pref.FORMAT_TEXT_URI:
          kbt = TextInputType.url;
          break;
        case Pref.FORMAT_TEXT_PLAIN:
        default:
          kbt = TextInputType.text;
      }
    }
    return AlertDialog(
      title: Text(widget.pref.label),
      content: TextField(
        controller: prefEditController,
        onChanged: (text) {
          setState(() {
            _canUpdate = _validatePref(widget.pref, prefEditController.text);
          });
        },
        keyboardType: kbt,
      ),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.check),
            color: _canUpdate ? Colors.green : Colors.grey,
            onPressed: () {
              if (_canUpdate) {
                setState(() {
                  Navigator.pop(context, prefEditController.text);
                });
              }
            }),
        IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            onPressed: () => setState(() {
                  Navigator.pop(context, null);
                })),
      ],
    );
  }
}
