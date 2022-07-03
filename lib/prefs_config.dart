library prefs_config;

// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'prefitems/pref_text.dart';
import 'prefitems/pref_int.dart';
import 'prefitems/pref_bool.dart';
import 'prefitems/pref_date.dart';
import 'prefitems/pref_time.dart';
import 'prefitems/pref_list.dart';
import 'prefitems/pref_header.dart';
import 'prefitems/pref_function.dart';

class Pref {
  String prefKey;
  dynamic defVal;
  bool visible;
  bool enabled;
  String? dependancy;
  int type;
  Function()? function;
  late Map<int, String> listItems;
  late String label;
  late String description;
  int? format;
  int? max;
  int? min;
  dynamic value;

  static const int TYPE_HEADER = 100;
  static const int TYPE_BOOL = 101;
  static const int TYPE_FUNCTION = 102;
  static const int TYPE_LIST = 103;
  static const int TYPE_DATE = 104;
  static const int TYPE_TIME = 105;
  static const int TYPE_TEXT = 106;
  static const int TYPE_INT = 107;

  static const int FORMAT_TEXT_PLAIN = 200; // Default Text Format
  static const int FORMAT_TEXT_EMAIL = 201;
  static const int FORMAT_TEXT_PHONE = 202;
  static const int FORMAT_TEXT_URI = 203;

  static const int FORMAT_BOOL_SWITCH = 210; // Default Bool Format
  static const int FORMAT_BOOL_CHECKBOX = 211;

  static const int FORMAT_INT_SLIDER = 220; // Default Int Format
  static const int FORMAT_INT_TEXT = 221;

  static const int FORMAT_DATE_DMY = 230; // Default Date Format
  static const int FORMAT_DATE_MDY = 231;
  static const int FORMAT_DATE_YMD = 232;

  static const int FORMAT_LIST_DROPDOWN = 240; // Default List Format
  static const int FORMAT_LIST_DIALOG = 241;

  Pref(
      {required this.prefKey,
      this.defVal,
      this.enabled = true,
      this.visible = true,
      this.dependancy,
      required this.type,
      this.function,
      Map<int, String>? listItems,
      String? label,
      String? description,
      this.format,
      this.max,
      this.min}) {
    this.listItems = listItems ?? {};
    this.label = label ?? prefKey;
    this.description = description ?? "";
  }
}

////////////////////////////////////////////////////////////////////////////////

class Prefs {
  List<Pref> preferences;

  Prefs({this.preferences = const []}) {
    Map<String, Pref> prefs = {};
    for (Pref p in preferences) {
      if (!prefs.containsKey(p.prefKey)) {
        prefs[p.prefKey] = p;
      } else {
        // ignore: avoid_print
        print('WARNING: Duplicate prefKey - preference discarded.');
      }
    }
    preferences = prefs.values.toList();
  }

  Future<bool> getBool(String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p == null) {
      return false;
    } else {
      return prefs.getBool(prefKey) ??
          p.defVal.toString().toLowerCase() == 'true';
    }
  }

  Future<void> setBool(String prefKey, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p != null) await prefs.setBool(prefKey, value);
  }

  Future<String?> getString(String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p == null) {
      return null;
    } else {
      return prefs.getString(prefKey) ?? p.defVal;
    }
  }

  Future<void> setString(String prefKey, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p != null) {
      await prefs.setString(prefKey, value);
    }
  }

  Future<int?> getInt(String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p == null) {
      return null;
    } else {
      return prefs.getInt(prefKey);
    }
  }

  Future<void> setInt(String prefKey, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p != null) {
      await prefs.setInt(prefKey, value);
    }
  }

  Future<void> setDateTime(String prefKey, DateTime value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p != null) {
      await prefs.setString(prefKey, value.toIso8601String());
    }
  }

  Future<DateTime?> getDateTime(String prefKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pref? p = getPref(prefKey);
    if (p == null) {
      return null;
    } else if (prefs.getString(prefKey) == null) {
      return DateTime.parse(p.defVal.toString());
    } else {
      return DateTime.parse(prefs.getString(prefKey)!);
    }
  }

  Future<void> remove(String prefKey) async {
    if (_getPrefId(prefKey) > -1) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(prefKey);
    }
  }

  List<Pref> getPrefs() {
    return preferences;
  }

  Pref? getPref(String prefKey) {
    int id = _getPrefId(prefKey);
    return id >= 0 ? preferences[id] : null;
  }

  void setPref(Pref pref) {
    int id = _getPrefId(pref.prefKey);
    if (id > -1) {
      preferences[id] = pref;
    } else {
      preferences.add(pref);
    }
  }

  void removePref(Pref pref) {
    int id = _getPrefId(pref.prefKey);
    if (id > -1) preferences.removeAt(id);
  }

  Future<Pref> overrideEnabledAttr(Pref pref) async {
    if ((pref.dependancy != null)) {
      Pref? parent = getPref(pref.dependancy!);
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

  void buildPreferencesScreen(BuildContext context, String title) {
    if (preferences.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PreferenceContainer(preferences: preferences, title: title)));
    }
  }

  int _getPrefId(String prefKey) {
    for (int i = 0; i < preferences.length; i++) {
      if (preferences[i].prefKey == prefKey) {
        return i;
      }
    }
    return -1;
  }
}

////////////////////////////////////////////////////////////////////////////////

class PreferenceContainer extends StatefulWidget {
  final List<Pref> preferences;
  final String title;

  // ignore: use_key_in_widget_constructors
  const PreferenceContainer({required this.preferences, required this.title});

  @override
  State<PreferenceContainer> createState() => _PreferenceContainerState();
}

class _PreferenceContainerState extends State<PreferenceContainer> {
  late Prefs prefs;

  @override
  void initState() {
    for (int i = 0; i < widget.preferences.length; i++) {
      widget.preferences[i].value = null;
    }
    prefs = Prefs(preferences: widget.preferences);
    super.initState();
  }

  void savePrefLocally(Pref pref) {
    if (mounted) {
      setState(() {
        prefs.setPref(pref);
      });
    }
  }

  Future<void> _saveAllPrefs() async {
    for (Pref pref in prefs.getPrefs()) {
      if (pref.value != null) {
        if (pref.visible) {
          switch (pref.type) {
            case Pref.TYPE_TEXT:
              prefs.setString(pref.prefKey, pref.value);
              break;
            case Pref.TYPE_INT:
            case Pref.TYPE_LIST:
              prefs.setInt(pref.prefKey, pref.value);
              break;
            case Pref.TYPE_BOOL:
              prefs.setBool(pref.prefKey, pref.value);
              break;
            case Pref.TYPE_DATE:
            case Pref.TYPE_TIME:
              prefs.setDateTime(pref.prefKey, pref.value);
              break;
          }
        }
      }
    }
    Navigator.pop(context);
  }

  Future<List<Widget>> _getPrefItems() async {
    List<Widget> items = [];

    for (Pref pref in prefs.getPrefs()) {
      if (pref.visible) {
        switch (pref.type) {
          case Pref.TYPE_TEXT:
            pref.value ??= await prefs.getString(pref.prefKey);
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(PrefText(
                    pref: pref, context: context, callback: savePrefLocally)
                .getItem());
            break;
          case Pref.TYPE_INT:
            pref.value ??= await prefs.getInt(pref.prefKey);
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(
                PrefInt(pref: pref, context: context, callback: savePrefLocally)
                    .getItem());
            break;
          case Pref.TYPE_LIST:
            pref.value ??= await prefs.getInt(pref.prefKey);
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(PrefList(
                    pref: pref, context: context, callback: savePrefLocally)
                .getItem());
            break;
          case Pref.TYPE_BOOL:
            pref.value ??= await prefs.getBool(pref.prefKey);
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(PrefBool(
                    pref: pref, context: context, callback: savePrefLocally)
                .getItem());
            break;
          case Pref.TYPE_DATE:
            pref.value ??= await prefs.getDateTime(pref.prefKey);
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(PrefDate(
                    pref: pref, context: context, callback: savePrefLocally)
                .getItem());
            break;
          case Pref.TYPE_TIME:
            pref.value ??= await prefs.getDateTime(pref.prefKey);
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(PrefTime(
                    pref: pref, context: context, callback: savePrefLocally)
                .getItem());
            break;
          case Pref.TYPE_FUNCTION:
            pref = await prefs.overrideEnabledAttr(pref);
            items.add(PrefFunction(
              pref: pref,
            ).getItem());
            break;
          case Pref.TYPE_HEADER:
            items.add(PrefHeader(
              pref: pref,
            ).getItem());
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
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveAllPrefs(),
          )
        ],
      ),
      body: FutureBuilder<List<Widget>>(
        future: _getPrefItems(),
        builder: (context, items) {
          if (items.hasData && items.data != null && mounted) {
            return ListView.builder(
                itemCount: items.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return items.data![index];
                });
          } else {
            return const SizedBox(
              height: 0.0,
              width: 0.0,
            );
          }
        },
      ),
    );
  }
}
