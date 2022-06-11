// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../prefs_config.dart';

class PrefSliderEdit extends StatefulWidget {
  final Pref pref;

  const PrefSliderEdit({required this.pref});

  @override
  State<PrefSliderEdit> createState() => _PrefSliderEditState();
}

class _PrefSliderEditState extends State<PrefSliderEdit> {
  late double _value;
  late double _min;
  late double _max;
  late bool _canUpdate;

  @override
  void initState() {
    _value = widget.pref.value == null
        ? 0.0
        : double.parse(widget.pref.value.toString());
    _min = widget.pref.value == null
        ? 0.0
        : double.parse(widget.pref.min.toString());
    _max = widget.pref.value == null
        ? 0.0
        : double.parse(widget.pref.max.toString());
    _canUpdate = false;
    super.initState();
  }

  bool _validatePref(double newValue) {
    int oldValue = double.parse(widget.pref.value.toString()).floor();
    return newValue.floor() != oldValue;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dialog = [
      Column(
        children: <Widget>[
          Slider(
            min: _min,
            max: _max,
            value: _value,
            onChanged: (newValue) {
              setState(() {
                _canUpdate = _validatePref(newValue);
                _value = newValue;
              });
            },
          ),
          Center(
            child: Text(
              _value.floor().toString(),
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      )
    ];

    return AlertDialog(
      title: Text(widget.pref.label),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return dialog[index];
            }),
      ),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.check),
            color: _canUpdate ? Colors.green : Colors.grey,
            onPressed: () {
              if (_canUpdate) {
                setState(() {
                  Navigator.pop(context, _value.floor());
                });
              }
            }),
        IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            onPressed: () {
              setState(() {
                Navigator.pop(context, null);
              });
            }),
      ],
    );
  }
}
