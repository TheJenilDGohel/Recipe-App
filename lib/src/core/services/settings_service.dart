import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_service.g.dart';

class SettingsService {
  SettingsService(this._prefs);
  final SharedPreferences _prefs;

  static const _remindersPromptKey = 'meal_reminders_prompt_shown';

  bool isRemindersPromptShown() {
    return _prefs.getBool(_remindersPromptKey) ?? false;
  }

  Future<void> setRemindersPromptShown(bool shown) async {
    await _prefs.setBool(_remindersPromptKey, shown);
  }
}

@riverpod
Future<SettingsService> settingsService(SettingsServiceRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SettingsService(prefs);
}
