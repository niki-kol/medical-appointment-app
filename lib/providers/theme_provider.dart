import '../helpers/imports.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  // Load saved theme preference
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode') ?? 'system';

    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // Save theme preference
  Future<void> _saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
  }

  // Toggle between light and dark (ignoring system)
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      _saveThemeMode('dark');
    } else {
      _themeMode = ThemeMode.light;
      _saveThemeMode('light');
    }
    notifyListeners();
  }

  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    switch (mode) {
      case ThemeMode.light:
        _saveThemeMode('light');
        break;
      case ThemeMode.dark:
        _saveThemeMode('dark');
        break;
      case ThemeMode.system:
        _saveThemeMode('system');
        break;
    }
    notifyListeners();
  }

  // Check if current theme is dark
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
