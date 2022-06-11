// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../prefs_config.dart';

class PrefListEdit extends StatefulWidget {
  final Pref pref;

  const PrefListEdit({required this.pref});

  @override
  State<PrefListEdit> createState() => _PrefListEditState();
}

class _PrefListEditState extends State<PrefListEdit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pref.label),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.pref.listItems.length,
            itemBuilder: (BuildContext context, int i) {
              FontWeight selected = FontWeight.normal;
              if (widget.pref.value == widget.pref.listItems.keys.toList()[i]) {
                selected = FontWeight.bold;
              }
              String value = widget.pref.listItems.containsKey(i)
                  ? widget.pref.listItems[i]!
                  : "";
              return Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 18.0,
                          fontWeight: selected,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          int newValue = widget.pref.listItems.keys.toList()[i];
                          Navigator.pop(context, newValue);
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
