import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';

class PrefSliderEdit extends StatefulWidget {
  final Pref pref;

  const PrefSliderEdit({this.pref});

  @override
  _PrefSliderEditState createState() => _PrefSliderEditState();
}

class _PrefSliderEditState extends State<PrefSliderEdit> {
  double _value;
  double _min;
  double _max;
  bool _canUpdate;

  @override
  void initState() {
    this._value = double.parse(widget.pref.value.toString());
    this._min = double.parse(widget.pref.min.toString());
    this._max = double.parse(widget.pref.max.toString());
    this._canUpdate = false;
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
            min: this._min,
            max: this._max,
            value: this._value,
            onChanged: (newValue) {
              setState(() {
                this._canUpdate = _validatePref(newValue);
                this._value = newValue;
              });
            },
          ),
          Center(
            child: Text(
              _value.floor().toString(),
              style: TextStyle(
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
      content: Container(
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
            icon: Icon(Icons.check),
            color: this._canUpdate ? Colors.green : Colors.grey,
            onPressed: () {
              if (this._canUpdate)
                setState(() {
                  Navigator.pop(context, this._value.floor());
                });
            }),
        IconButton(
            icon: Icon(Icons.cancel),
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
