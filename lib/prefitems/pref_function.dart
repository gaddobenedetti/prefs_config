import '../prefs_config.dart';
import '../shared/pref_shared.dart';

class PrefFunction extends PrefItem {
  PrefFunction({required Pref pref}) : super(pref: pref) {
    if (pref.function != null && pref.enabled) {
      actionFunc = this.pref.function;
    }
  }
}
