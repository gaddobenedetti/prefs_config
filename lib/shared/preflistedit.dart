import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';

class PrefListEdit extends StatefulWidget {

  final Pref pref;

  const PrefListEdit({this.pref});

  @override
  _PrefListEditState createState() => _PrefListEditState();
}

class _PrefListEditState extends State<PrefListEdit> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.pref.label == null ? "" : widget.pref.label.toString();
    return AlertDialog(
      title: Text(title),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.pref.listItems.length,
            itemBuilder: (BuildContext context, int i) {
              FontWeight selected = FontWeight.normal;
              if (widget.pref.value == widget.pref.listItems.keys.toList()[i])
                selected = FontWeight.bold;
              return Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text(
                        widget.pref.listItems[i],
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
            }
        ),
      ),
    );
  }
}
