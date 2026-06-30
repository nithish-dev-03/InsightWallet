class AppConfig {
  AppConfig._();

  static const String appName = 'InsightWallet';
  static const String appVersion = '1.0.0';
  static const String defaultCurrency = 'USD';
  static const String defaultLocale = 'en_US';

  static const List<String> supportedLocales = ['en_US', 'es_ES', 'fr_FR', 'de_DE', 'pt_BR'];

  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'BRL',
    'MXN',
    'CAD',
    'AUD',
    'JPY',
  ];
}
