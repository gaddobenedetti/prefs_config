import 'package:prefs_config/prefs_config.dart';
import 'package:prefs_config/shared/pref_shared.dart';

class PrefFunction extends PrefItem {
  Pref pref;
  Function actionFunc;

  PrefFunction({this.pref}) {
    if (this.pref.function != null && this.pref.enabled)
      this.actionFunc = this.pref.function;
  }
}
