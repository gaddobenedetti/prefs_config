library prefs_config;

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:prefs_config/prefitems/pref_text.dart';
import 'package:prefs_config/prefitems/pref_int.dart';
import 'package:prefs_config/prefitems/pref_bool.dart';
import 'package:prefs_config/prefitems/pref_date.dart';
import 'package:prefs_config/prefitems/pref_time.dart';
import 'package:prefs_config/prefitems/pref_list.dart';
import 'package:prefs_config/prefitems/pref_header.dart';
import 'package:prefs_config/prefitems/pref_function.dart';


class Pref {

  String prefKey;
  var defVal;
  bool visible;
  bool enabled;
  String dependancy;
  int type;
  Function function;
  Map<int, String> listItems;
  String label;
  String description;
  int format;
  int max;
  int min;
  var value;

  static const int TYPE_HEADER            = 100;
  static const int TYPE_BOOL              = 101;
  static const int TYPE_FUNCTION          = 102;
  static const int TYPE_LIST              = 103;
  static const int TYPE_DATE              = 104;
  static const int TYPE_TIME              = 105;
  static const int TYPE_TEXT              = 106;
  static const int TYPE_INT               = 107;

  static const int FORMAT_TEXT_PLAIN      = 200; // Default Text Format
  static const int FORMAT_TEXT_EMAIL      = 201;
  static const int FORMAT_TEXT_PHONE      = 202;
  static const int FORMAT_TEXT_URI        = 203;

  static const int FORMAT_BOOL_SWITCH     = 210; // Default Bool Format
  static const int FORMAT_BOOL_CHECKBOX   = 211;

  static const int FORMAT_INT_SLIDER      = 220; // Default Int Format
  static const int FORMAT_INT_TEXT        = 221;

  static const int FORMAT_DATE_DMY        = 230; // Default Date Format
  static const int FORMAT_DATE_MDY        = 231;
  static const int FORMAT_DATE_YMD        = 232;

  Pref({
    this.prefKey,
    this.defVal,
    this.enabled = true,
    this.visible = true,
    this.dependancy,
    this.type,
    this.function,
    this.listItems,
    this.label,
    this.description,
    this.format,
    this.max,
    this.min
  });
}

////////////////////////////////////////////////////////////////////////////////

class Prefs {

  List<Pref> preferences;

  Prefs ({ this.preferences }) {
    Map<String, Pref> prefs = Map();
    for (Pref p in this.preferences)
      if (!prefs.containsKey(p.prefKey)) {
        prefs[p.prefKey] = p;
      } else {
        print('WARNING: Duplicate prefKey - preference discarded.');
      }
    this.preferences = prefs.values.toList();
  }

  Future<bool> getBool (String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p == null) {
      return false;
    } else {
      return prefs.getBool(prefKey) ?? p.defVal.toString().toLowerCase() == 'true';
    }
  }

  Future<void> setBool (String prefKey, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p != null)
      await prefs.setBool(prefKey, value);
  }

  Future<String> getString (String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p == null) {
      return null;
    } else {
      return prefs.getString(prefKey) ?? p.defVal.toString();
    }
  }

  Future<void> setString (String prefKey, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p != null)
      await prefs.setString(prefKey, value);
  }

  Future<int> getInt (String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p == null) {
      return null;
    } else {
      return prefs.getInt(prefKey) ?? int.parse(p.defVal.toString());
    }
  }

  Future<void> setInt (String prefKey, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p != null)
      await prefs.setInt(prefKey, value);
  }

  Future<void> setDateTime (String prefKey, DateTime value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p != null)
      await prefs.setString(prefKey, value.toIso8601String());
  }

  Future<DateTime> getDateTime (String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref p = getPref (prefKey);
    if (p == null) {
      return null;
    } else if (prefs.getString(prefKey) == null) {
      return DateTime.parse(p.defVal.toString());
    } else {
      return DateTime.parse(prefs.getString(prefKey));
    }
  }

  Future<void> remove(String prefKey) async {
    if (_getPrefId(prefKey) > -1) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(prefKey);
    }
  }

  List<Pref> getPrefs () {
    return this.preferences;
  }

  Pref getPref (String prefKey) {
    int id = _getPrefId(prefKey);
    return id >= 0 ? this.preferences[id] : null;
  }

  void setPref (Pref pref) {
    int id = _getPrefId(pref.prefKey);
    if (id > -1) {
      this.preferences[id] = pref;
    } else {
      this.preferences.add(pref);
    }
  }

  void removePref (Pref pref) {
    int id = _getPrefId(pref.prefKey);
    if (id > -1)
      this.preferences.removeAt(id);
  }

  void buildPreferencesScreen(BuildContext context, String title) {
    if (this.preferences != null &&this.preferences.length > 0)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreferenceContainer(
                  preferences: this.preferences,
                  title: title
              )
          )
      );
  }

  int _getPrefId (String prefKey) {
    for (int i = 0; i < this.preferences.length; i++) {
      if (this.preferences[i].prefKey == prefKey) {
        return i;
      }
    }
    return -1;
  }

  Future<Pref> overrideEnabledAttr (Pref pref) async {
    if (pref != null && pref.dependancy != null) {
      Pref parent = getPref(pref.dependancy);
      if (parent != null && parent.type == Pref.TYPE_BOOL) {
        if (parent.value == null) {
          pref.enabled = await getBool(parent.prefKey);
        } else {
          pref.enabled = parent.value;
        }
        setPref(pref);
      }
    }
    return pref;
  }

}

////////////////////////////////////////////////////////////////////////////////

class PreferenceContainer extends StatefulWidget {

  List<Pref> preferences;
  String title;

  PreferenceContainer ({ this.preferences, this.title });

  @override
  _PreferenceContainerState createState() => _PreferenceContainerState();
}

class _PreferenceContainerState extends State<PreferenceContainer> {
  Prefs prefs;

  @override
  void initState() {
    for (int i = 0; i < widget.preferences.length; i++)
      widget.preferences[i].value = null;
    this.prefs = new Prefs(preferences: widget.preferences);
    super.initState();
  }

  void savePrefLocally(Pref pref) {
    if (mounted)
      setState(() {
        this.prefs.setPref(pref);
      });
  }

  Future<void> _saveAllPrefs () async {
    for (Pref pref in this.prefs.getPrefs()) {
      if (pref.visible) {
        switch (pref.type) {
          case Pref.TYPE_TEXT:
            this.prefs.setString(pref.prefKey, pref.value);
            break;
          case Pref.TYPE_INT:
          case Pref.TYPE_LIST:
            this.prefs.setInt(pref.prefKey, pref.value);
            break;
          case Pref.TYPE_BOOL:
            this.prefs.setBool(pref.prefKey, pref.value);
            break;
          case Pref.TYPE_DATE:
          case Pref.TYPE_TIME:
            this.prefs.setDateTime(pref.prefKey, pref.value);
            break;
        }
      }
    }
    Navigator.pop(this.context);
  }

  Future<List<Widget>> _getPrefItems () async {
    List<Widget> items = [];

    for (Pref pref in this.prefs.getPrefs()) {
      if (pref.visible) {

        switch(pref.type) {
          case Pref.TYPE_TEXT:
            if (pref.value == null)
              pref.value = await this.prefs.getString(pref.prefKey);
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(
                PrefText(pref: pref, context: this.context, callback: savePrefLocally).getItem()
            );
            break;
          case Pref.TYPE_INT:
            if (pref.value == null)
              pref.value = await this.prefs.getInt(pref.prefKey);
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(
                PrefInt(pref: pref, context: this.context, callback: savePrefLocally).getItem()
            );
            break;
          case Pref.TYPE_LIST:
            if (pref.value == null)
              pref.value = await this.prefs.getInt(pref.prefKey);
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(
                PrefList(pref: pref, context: this.context, callback: savePrefLocally).getItem()
            );
            break;
          case Pref.TYPE_BOOL:
            if (pref.value == null)
              pref.value = await this.prefs.getBool(pref.prefKey);
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(
                PrefBool(pref: pref, context: this.context, callback: savePrefLocally).getItem()
            );
            break;
          case Pref.TYPE_DATE:
            if (pref.value == null)
              pref.value = await this.prefs.getDateTime(pref.prefKey);
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(
                PrefDate(pref: pref, context: this.context, callback: savePrefLocally).getItem()
            );
            break;
          case Pref.TYPE_TIME:
            if (pref.value == null)
              pref.value = await this.prefs.getDateTime(pref.prefKey);
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(
                PrefTime(pref: pref, context: this.context, callback: savePrefLocally).getItem()
            );
            break;
          case Pref.TYPE_FUNCTION:
            pref = await this.prefs.overrideEnabledAttr(pref);
            items.add(PrefFunction(pref: pref,).getItem());
            break;
          case Pref.TYPE_HEADER:
            items.add(PrefHeader(pref: pref,).getItem());
            break;
        }
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title == null ? "" : widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _saveAllPrefs(),
          )
        ],
      ),
      body: FutureBuilder(
        future: _getPrefItems(),
        builder: (context, items) {
          if (items.hasData && mounted) {
            return ListView.builder(
                itemCount: items.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return items.data[index];
                }
            );
          } else {
            Container(height: 0.0, width: 0.0,);
          }
        },
      ),
    );
  }

}
