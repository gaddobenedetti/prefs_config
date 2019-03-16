# prefs_config
This dart package works alongside the [shared preferences plugin](https://pub.dartlang.org/packages/shared_preferences) and can be used to automatically generate a settings or preferences screen for a Flutter app.

<!--## Getting Started-->
<!--In your flutter project add the dependency:-->
<!--```yml-->
<!--dependencies:-->
  <!--...-->
  <!--prefs_config: ^0.8.0-->
<!--```-->
<!--You can install the package depending on your IDE or from the command line:-->
<!--```yml-->
<!--$ flutter packages get-->
<!--```-->
<!--To import it to your Dart code:-->
<!--```yml-->
<!--import 'package:prefs_config/prefs_config.dart';-->
<!--```-->
<!--For help getting started with Flutter, view the online-->
<!--[documentation](https://flutter.io/).-->

## Usage

This package contains three principle objects for use.

***Pref*** for defining preferences for display. ***Prefs*** which can be used to hold a collection of these preferences and manage them. ***PreferenceContainer*** which is a _StatefulWidget_ that will contruct a screen to so a user may view and edit them.

### Pref Class
This object allows the description of a preference, both in terms of data and also behaviour in the preference screen, these are as follows:

* **prefKey**. String. This is the key that identifies the preference. The same key can be used to get or set, either through the Prefs object or the shared preferences plugin, any preference, other than the special preference types.
* **type**. Int. The type of preference. Note that these are principally display, rather than data types, the first six of which handle _bool_, _String_, _int_, and _DateTime_ data types and the last two _special_ types are not true preferences, but UI elements. These are:
   * **Bool**. Bool preference type. The _format_ property may be used so it can be displayed as either a _switch_ or _checkbox_ input. Default is as a _switch_ input.
   * **Text**. String preference type. The _format_ property may be used so it can input as _plain text_, _URI_, _phone number_ or an _email_. Default is as a _plain text_.
   * **Int**. Int preference type. The _format_ property may be used so it can input as _text input_ or using a _slider_ (max and min properties are required for the latter). Default is as a _text input_.
   * **Date**. DateTime preference type. The _format_ property may be used so it can displayed in _dd/mm/yyyy_, _mm/dd/yyyy_, _yyyy/mm/dd_ format. Default is _dd/mm/yyyy_.
   * **Time**. DateTime preference type.
   * **List**. Int preference type.
   * **Header**. Special Preference Type. A list header sub-label.
   * **Function**. Special Preference Type. A list item that triggers a call to a function.
* **defVal**. Dynamic. The default value of the preference, when first created.
* **visible**. Bool. Denotes if a preference will appear on the generated preference screen or not. True by default.
* **enabled**. Bool. Denotes if a preference will be enabled on the generated preference screen or not. True by default.
* **dependancy**. String. A prefernece may have its enabled property overridden by this property. If the value is set to the key of a Bool type preference, to the current value of that preference. Note, that this does not change the value of the preference, simply whether it is enabled on the generated preference screen.
* **function**. Function. The function to call when a Function type preference is clicked in the list.
* **listItems**. Map<int,String>. Only used with List type preferences. The Map object what the option value and option label values are. The ultimate value of the List type preference will be the integer.
* **label**. String. The title shown on the preference tile on the generated preference screen, it also serves as the text to any Header type preference.
* **description**. String. A short description that is shown below the preference tile title on the generated preference screen.
* **format**. Int. Some preference types may be formatted to take in particular input. Please refer above to the _type_ property for more information.
* **max**. Int. The maximum size allowed for Int type preferences, day in the future for Date type preferences and length allowed for Text type preferences.
* **min**. Int. The minimum size allowed for Int type preferences, day in the past for Date type preferences and length allowed for Text type preferences.

### Prefs Class

To initiate this class a list of pref items, in order in which they will be displayed, must be submitted to the constructor.

```yml
Prefs p = Prefs (
  preferences: <Pref> [
    Pref(
      prefKey: "txt_plain",
      type: Pref.TYPE_TEXT,
      defVal: "foobar",
      min: 1, // Minimum length of text preference - 1 means cannot be empty.
      label: "Text Pref",
      description: "This is a Text Setting"
    ),
    Pref(
      prefKey: "bol_switch",
      type: Pref.TYPE_BOOL,
      defVal: true,
      label: "Bool Switch Pref",
      format: Pref.FORMAT_BOOL_SWITCH,
      description: "This is a Bool Switch Setting"
    ),
  ]
);
```
The class contains getters and setters for the principle preference data types - String, int, bool and DateTime. The are interchangeable with the corresponding _shared preferences_ methods (and in fact use them), but also manage the corresponding Pref values and thus the generated preferences screen display.

Additionally, the class comes with a number of helper methods to manage the Pref items and finally a method to launch the generated preferences screen.

```yml
p.buildPreferencesScreen(context, 'My Preferences Screen');
```

### PreferenceContainer Class
This class is a _StatefulWidget_ that invokes the preferences screen. It may be called via the _buildPreferencesScreen_ method of the Prefs class, as shown above, or directly with the following constructor:
```yml
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PreferenceContainer(
      preferences: this.preferences,
      title: title
    )
  )
);
```
