class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String apiPrefix = '/api/v1';
  static Duration timeout = const Duration(seconds: 30);

  // ── Auth ────────────────────────────────────
  static const String login = '$apiPrefix/auth/login';
  static const String register = '$apiPrefix/auth/register';
  static const String logout = '$apiPrefix/auth/logout';
  static const String refreshToken = '$apiPrefix/auth/refresh';
  static const String forgotPassword = '$apiPrefix/auth/forgot-password';
  static const String resetPassword = '$apiPrefix/auth/reset-password';
  static const String profile = '$apiPrefix/auth/profile';

  // ── Transactions ────────────────────────────
  static const String transactions = '$apiPrefix/transactions';
  static String transactionById(String id) => '$apiPrefix/transactions/$id';

  // ── Categories ──────────────────────────────
  static const String categories = '$apiPrefix/categories';
  static String categoryById(String id) => '$apiPrefix/categories/$id';

  // ── Budgets ─────────────────────────────────
  static const String budgets = '$apiPrefix/budgets';
  static String budgetById(String id) => '$apiPrefix/budgets/$id';

  // ── Goals ───────────────────────────────────
  static const String goals = '$apiPrefix/goals';
  static String goalById(String id) => '$apiPrefix/goals/$id';

  // ── Reports ─────────────────────────────────
  static const String reports = '$apiPrefix/reports';
  static const String reportsSummary = '$apiPrefix/reports/summary';

  // ── Dashboard ───────────────────────────────
  static const String dashboard = '$apiPrefix/dashboard';

  // ── Notifications ───────────────────────────
  static const String notifications = '$apiPrefix/notifications';

  // ── Insights ────────────────────────────────
  static const String insights = '$apiPrefix/insights';
}
