class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  List<String> _favoriteLanguages = [];

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  List<String> get favoriteLanguages => _favoriteLanguages;

  void toggleFavorite(String language) {
    if (_favoriteLanguages.contains(language)) {
      _favoriteLanguages.remove(language);
    } else {
      _favoriteLanguages.add(language);
    }
  }
}
