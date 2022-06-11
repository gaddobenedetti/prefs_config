import 'package:flutter/material.dart';
import 'package:prefs_config/prefs_config.dart';

class PrefsExample extends StatefulWidget {
  @override
  State<PrefsExample> createState() => _PrefsExampleState();
}

class _PrefsExampleState extends State<PrefsExample> {
  late Prefs p;
  late String prefScreenTitle;

  @override
  void initState() {
    // Title used by the generated preference screen.
    this.prefScreenTitle = "Example Settings";

    // List of options used in the example list preference
    Map<int, String> myList = Map();
    for (int i = 0; i < 20; i++) myList[i] = 'Option ' + (i + 1).toString();

    /// The Pref Object uses the following properties:
    ///
    /// prefKey: Unique identifier key used to identify the preference.
    /// type: Integer-based category denoting preference type.
    /// defVal: Dynamic property denoting the default value of the preference.
    /// label: The title of the preference used in the prefs screen.
    /// description: Description text for the preference used in the prefs screen.
    /// visible: Whether a preference is editable via the prefs screen.
    /// enabled: Whether a preference is enabled (does not affect headers).
    /// format: An optional value that affects the behaviour/appearance of the
    /// preference when edited.
    ///
    /// Additional notes to properties are below.
    List<Pref> prefs = [
      Pref(
          prefKey: "txt_plain",
          type: Pref.TYPE_TEXT,
          defVal: "foobar",
          min:
              1, // Minimum length of text preference - 1 means cannot be empty.
          max: 10, // Maximum length of text preference.
          label: "Text Pref",
          description: "This is a Text Setting"),
      Pref(
          prefKey: "txt_hidden",
          type: Pref.TYPE_TEXT,
          defVal: "foobar",
          visible: false),
      Pref(
          prefKey: "bol_switch",
          type: Pref.TYPE_BOOL,
          defVal: false,
          label: "Bool Switch Pref",
          format: Pref.FORMAT_BOOL_SWITCH,
          description: "This is a Bool Switch Setting"),
      Pref(
          prefKey: "bol_switch_dis",
          type: Pref.TYPE_BOOL,
          defVal: false,
          label: "Bool Switch Pref (disabled)",
          enabled: false,
          format: Pref.FORMAT_BOOL_SWITCH,
          description: "This is a Bool Switch Setting"),
      Pref(
          prefKey: "lst_options1",
          type: Pref.TYPE_LIST,
          defVal: 6,
          label: "List Pref",
          format: Pref.FORMAT_LIST_DIALOG,
          listItems: myList,
          description: "This is a Dialog List Setting"),
      Pref(
          prefKey: "lst_options2",
          type: Pref.TYPE_LIST,
          defVal: 6,
          label: "List Pref",
          listItems: myList,
          description: "This is a Dropdown List Setting"),
      Pref(
          prefKey: "bol_check",
          type: Pref.TYPE_BOOL,
          defVal: false,
          label: "Bool CheckboxPref",
          format: Pref.FORMAT_BOOL_CHECKBOX,
          description: "This is a Bool Checkbox Setting"),
      Pref(
          prefKey: "txt_number",
          type: Pref.TYPE_INT,
          defVal: 45,
          label: "Number Pref",
          description: "This is a Number Textbox Setting"),
      Pref(
          prefKey: "sdr_number",
          type: Pref.TYPE_INT,
          defVal: 45,
          min: 0, // Minimum value of integer on slider
          max: 100, // Maximum value of integer on slider
          format: Pref.FORMAT_INT_SLIDER,
          label: "Number Pref (Slider)",
          description: "This is a Number Slider Setting"),
      Pref(
          prefKey: "dt_day",
          type: Pref.TYPE_DATE,
          defVal: 20180124,
          dependancy: 'bol_switch',
          label: "Date Pref",
          format: Pref.FORMAT_DATE_YMD,
          description: "This is a Date Setting"),
      Pref(
          prefKey: "dt_time",
          type: Pref.TYPE_TIME,
          defVal: "20180124T132700",
          label: "Time Pref",
          description: "This is a Time Setting"),
      Pref(
        prefKey: "hdr",
        type: Pref.TYPE_HEADER,
        label: "Setting Header",
        defVal: Colors.white30, // Background color of header
      ),
      Pref(
          prefKey: "func_test",
          type: Pref.TYPE_FUNCTION,
          function:
              testFunction, // Name of function that preference item will call when clicked
          label: "Function Pref",
          description: "This is a Function Setting"),
      Pref(
          prefKey: "txt_email",
          type: Pref.TYPE_TEXT,
          defVal: "test@test.com",
          format: Pref.FORMAT_TEXT_EMAIL,
          label: "Email Pref",
          description: "This is an Email String Setting"),
      Pref(
          prefKey: "txt_phone",
          type: Pref.TYPE_TEXT,
          defVal: "+41798521111",
          format: Pref.FORMAT_TEXT_PHONE,
          label: "Phone Pref",
          description: "This is an Phone String Setting"),
      Pref(
          prefKey: "txt_uri",
          type: Pref.TYPE_TEXT,
          defVal: "http://www.google.com",
          format: Pref.FORMAT_TEXT_URI,
          label: "URL Pref",
          description: "This is an URL Setting"),
    ];

    this.p = Prefs(preferences: prefs);

    super.initState();
  }

  // This is the function called by func_test above
  void testFunction() {
    showAboutDialog(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: RaisedButton(
        onPressed: () =>
            this.p.buildPreferencesScreen(context, this.prefScreenTitle),
        child: Text("Launch"),
      )),
    );
  }
}
