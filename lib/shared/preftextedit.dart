import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';

class PrefTextEdit extends StatefulWidget {
  final Pref pref;

  const PrefTextEdit({this.pref});

  @override
  _PrefTextEditState createState() => _PrefTextEditState();
}

class _PrefTextEditState extends State<PrefTextEdit> {
  final prefEditController = TextEditingController();
  bool _canUpdate;

  @override
  void initState() {
    this.prefEditController.text = '';
    if (widget.pref.value != null)
      this.prefEditController.text = widget.pref.value.toString();
    this._canUpdate = false;
    super.initState();
  }

  bool _validatePref(Pref pref, String value) {
    bool isValid = true;
    if (pref.value.toString() == value.toString()) isValid = false;

    if (pref.type == Pref.TYPE_INT) {
      int num = int.parse(value) == null ? 0 : int.parse(value);
      if (pref.min != null && num < pref.min) isValid = false;
      if (pref.max != null && num > pref.max) isValid = false;
    } else {
      switch (pref.format) {
        case Pref.FORMAT_TEXT_EMAIL:
          String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;'
              r':\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}'
              r'\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)'
              r'+[a-zA-Z]{2,}))$';
          RegExp rX = new RegExp(p);
          isValid = rX.hasMatch(value.toString());
          break;
        case Pref.FORMAT_TEXT_URI:
          String p = r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]'
              r'{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';
          RegExp rX = new RegExp(p);
          isValid = rX.hasMatch(value.toString());
          break;
        case Pref.FORMAT_TEXT_PHONE:
        // TODO Validate phone number input
        case Pref.FORMAT_TEXT_PLAIN:
        default:
          int len = value == null ? 0 : value.toString().length;
          int min = pref.min == null ? 0 : pref.min;
          int max = pref.max == null ? 0 : pref.max;
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
        controller: this.prefEditController,
        onChanged: (text) {
          setState(() {
            this._canUpdate =
                _validatePref(widget.pref, this.prefEditController.text);
          });
        },
        keyboardType: kbt,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.check),
            color: this._canUpdate ? Colors.green : Colors.grey,
            onPressed: () {
              if (this._canUpdate)
                setState(() {
                  Navigator.pop(context, this.prefEditController.text);
                });
            }),
        IconButton(
            icon: Icon(Icons.cancel),
            color: Colors.red,
            onPressed: () => setState(() {
                  Navigator.pop(context, null);
                })),
      ],
    );
  }
}
