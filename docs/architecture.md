# Architecture

InsightWallet follows **Clean Architecture** principles on both the Flutter frontend and Express.js backend, ensuring separation of concerns, testability, and maintainability. Each layer depends only on the layer directly below it.

---

## Clean Architecture Overview

### Flutter Layer Map

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Screens (Widgets) — UI rendering, user input     │  │
│  │  Providers (Riverpod) — State + business logic    │  │
│  └───────────────────────┬───────────────────────────┘  │
│                          │ depends on                    │
│  ┌───────────────────────▼───────────────────────────┐  │
│  │                   APPLICATION LAYER                │  │
│  │  Use Cases — Orchestrates business operations     │  │
│  └───────────────────────┬───────────────────────────┘  │
│                          │ depends on                    │
│  ┌───────────────────────▼───────────────────────────┐  │
│  │                    DOMAIN LAYER                    │  │
│  │  Entities — Core business objects                  │  │
│  │  Repository Interfaces — Contracts for data access │  │
│  └───────────────────────┬───────────────────────────┘  │
│                          │ implemented by                │
│  ┌───────────────────────▼───────────────────────────┐  │
│  │                     DATA LAYER                     │  │
│  │  Repository Implementations — Concrete data access │  │
│  │  Data Sources (API, Local)                        │  │
│  │  Models — Data transfer objects, JSON serialization│  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Folder Structure — Flutter

```
lib/
├── main.dart                           # App entry point
├── core/                               # Shared cross-feature code
│   ├── config/                         # AppConfig, ApiConfig
│   │   ├── api_config.dart
│   │   └── app_config.dart
│   ├── constants/
│   ├── providers/                      # Global Riverpod providers
│   │   └── providers.dart              # storageServiceProvider, apiServiceProvider
│   ├── router/                         # GoRouter configuration + auth guard
│   │   └── app_router.dart
│   ├── services/                       # Shared services
│   │   ├── api_service.dart            # Dio HTTP client with interceptors
│   │   ├── auth_service.dart           # Login/register/refresh/logout
│   │   ├── hive_service.dart           # Hive initialization
│   │   └── storage_service.dart        # flutter_secure_storage wrapper
│   ├── shared/widgets/                 # Reusable UI components
│   │   ├── amount_text.dart
│   │   ├── app_bar_widget.dart
│   │   ├── app_scaffold.dart
│   │   ├── bottom_nav_bar.dart
│   │   ├── empty_state.dart
│   │   ├── error_state.dart
│   │   ├── glass_card.dart
│   │   ├── loading_shimmer.dart
│   │   └── section_header.dart
│   ├── theme/                          # Design system
│   │   ├── app_colors.dart
│   │   ├── app_radius.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart
│   │   └── app_typography.dart
│   └── utils/
│       ├── format_utils.dart
│       └── validators.dart
└── features/                           # Feature modules (Clean Architecture)
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/            # Remote data source
    │   │   ├── models/                 # AuthRequest, AuthResponse
    │   │   └── repositories/           # AuthRepositoryImpl
    │   ├── domain/
    │   │   ├── entities/               # UserEntity
    │   │   ├── repositories/           # AuthRepository (interface)
    │   │   └── usecases/               # LoginUseCase, RegisterUseCase, LogoutUseCase
    │   └── presentation/
    │       ├── providers/              # AuthNotifier (Riverpod)
    │       └── screens/                # Login, Register, ForgotPassword, ResetPassword
    ├── budgets/
    │   ├── data/                       # BudgetModel, BudgetRepositoryImpl
    │   ├── domain/                     # BudgetEntity, BudgetRepository
    │   └── presentation/               # BudgetProvider, BudgetAlertProvider, Screens
    ├── categories/
    ├── dashboard/
    ├── goals/
    ├── insights/
    ├── notifications/
    ├── profile/
    ├── reports/
    ├── settings/
    └── transactions/
```

### Folder Structure — Backend

```
apps/backend/src/
├── server.js                           # Entry point, DB connect + listen
├── app.js                              # Express app (middleware, routes)
├── config/
│   ├── database.js                     # MongoDB connection with retry logic
│   └── env.js                          # Environment variable accessor
├── controllers/                        # Request handlers (thin)
│   ├── authController.js
│   ├── transactionController.js
│   ├── categoryController.js
│   ├── budgetController.js
│   ├── goalController.js
│   ├── insightController.js
│   ├── notificationController.js
│   ├── profileController.js
│   └── settingController.js
├── middlewares/
│   ├── auth.js                         # JWT verification, sets req.userId
│   ├── errorHandler.js                 # Global error handler
│   ├── rateLimiter.js                  # General + auth rate limiting
│   ├── upload.js                       # Multer config (memory storage)
│   └── validate.js                     # express-validator runner
├── models/                             # Mongoose schemas
│   ├── index.js                        # Barrel exports
│   ├── User.js
│   ├── Transaction.js
│   ├── Category.js
│   ├── Budget.js
│   ├── Goal.js
│   ├── Notification.js
│   ├── Insight.js
│   ├── Setting.js
│   └── RefreshToken.js
├── repositories/                       # Data access (Mongoose queries)
│   ├── BaseRepository.js               # Generic CRUD base class
│   ├── userRepository.js
│   ├── transactionRepository.js
│   ├── categoryRepository.js
│   ├── budgetRepository.js
│   ├── goalRepository.js
│   ├── insightRepository.js
│   ├── notificationRepository.js
│   ├── settingRepository.js
│   └── refreshTokenRepository.js
├── routes/                             # Express routers
│   ├── index.js                        # Barrel exports
│   ├── authRoutes.js
│   ├── transactionRoutes.js
│   ├── categoryRoutes.js
│   ├── budgetRoutes.js
│   ├── goalRoutes.js
│   ├── insightRoutes.js
│   ├── notificationRoutes.js
│   ├── profileRoutes.js
│   └── settingRoutes.js
├── services/                           # Business logic layer
│   ├── authService.js
│   ├── transactionService.js
│   ├── categoryService.js
│   ├── budgetService.js
│   ├── goalService.js
│   ├── insightService.js
│   ├── notificationService.js
│   ├── profileService.js
│   ├── settingService.js
│   └── cloudinaryService.js
├── utils/
│   ├── apiResponse.js                  # Response formatters (success, error, paginated)
│   ├── generateToken.js                # JWT sign/verify
│   ├── sendEmail.js                    # Nodemailer helper
│   └── swagger.js                      # Swagger/OpenAPI config
└── validators/                         # express-validator chains
    ├── authValidator.js
    ├── transactionValidator.js
    ├── categoryValidator.js
    ├── budgetValidator.js
    ├── goalValidator.js
    ├── profileValidator.js
    └── settingValidator.js
```

### Backend Layer Map

```
┌─────────────────────────────────────────────────────────┐
│                      ROUTES                              │
│  Route definitions + middleware wiring                  │
├─────────────────────────────────────────────────────────┤
│                    CONTROLLERS                           │
│  HTTP request parsing, response formatting              │
├─────────────────────────────────────────────────────────┤
│                     SERVICES                             │
│  Business logic, orchestration, validation              │
├─────────────────────────────────────────────────────────┤
│                   REPOSITORIES                           │
│  Data access layer (Mongoose queries)                   │
├─────────────────────────────────────────────────────────┤
│                    DATABASE                              │
│  MongoDB / Mongoose ODM                                 │
└─────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Request Lifecycle

```
Client                    Express.js
  │                          │
  │────── HTTP Request ──────▶│
  │                          │
  │                     ┌────▼────┐
  │                     │ Router  │
  │                     └────┬────┘
  │                          │
  │                     ┌────▼────────┐
  │                     │ Middlewares  │
  │                     │ (auth, rate- │
  │                     │  limit,     │
  │                     │  validate)  │
  │                     └────┬────────┘
  │                          │
  │                     ┌────▼──────────┐
  │                     │  Controller   │
  │                     │  (thin, calls │
  │                     │   service)    │
  │                     └────┬──────────┘
  │                          │
  │                     ┌────▼──────────┐
  │                     │   Service     │
  │                     │  (business    │
  │                     │   logic)      │
  │                     └────┬──────────┘
  │                          │
  │                     ┌────▼──────────────┐
  │                     │   Repository      │
  │                     │  (Mongoose query) │
  │                     └────┬──────────────┘
  │                          │
  │                     ┌────▼────┐
  │                     │ MongoDB │
  │                     └────┬────┘
  │                          │
  │◀──── HTTP Response ──────┤
```

### Flutter Data Flow

```
User Action
    │
    ▼
Screen (Widget)
    │
    ▼
Provider (Riverpod Notifier)
    │
    ├──▶ Use Case (if applicable)
    │        │
    │        ▼
    │   Repository Interface (domain layer)
    │        │
    │        ▼
    │   Repository Implementation (data layer)
    │        │
    │        ├──▶ ApiService (Dio) ──▶ Express API
    │        └──▶ Hive (local cache)
    │
    ▼
State update → UI rebuilds
```

---

## State Management — Riverpod

InsightWallet uses **Riverpod** (`flutter_riverpod`) for all state management. Business logic lives in `Notifier`/`AsyncNotifier` classes within each feature's `presentation/providers/` directory.

| Provider Type | Usage                                      |
|---------------|--------------------------------------------|
| `Provider`     | Singleton services (ApiService, Storage)   |
| `StateNotifier` / `Notifier` | Form state, UI state toggles    |
| `AsyncNotifier` | Async data fetching, CRUD operations     |
| `FutureProvider` | One-shot async reads                     |

### Provider Example Flow

```dart
// providers/providers.dart (global)
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
final apiServiceProvider = Provider<ApiService>((ref) => ApiService(ref.watch(storageServiceProvider)));

// features/auth/presentation/providers/auth_provider.dart
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
```

- UI calls `ref.watch(authProvider)` to react to state changes
- UI calls `ref.read(authProvider.notifier).login(email, password)` to trigger actions
- No `setState` except trivial local UI toggles

---

## Routing — GoRouter

Routing is handled by **GoRouter** with an auth guard and tab navigation shell.

```
/splash                     # Splash screen (initial redirect)
/onboarding                 # First-time user onboarding
/auth/login                 # Login
/auth/register              # Register
/auth/forgot-password       # Forgot password
/auth/reset-password/:token # Password reset
/dashboard                  # Main app (ShellRoute — bottom nav)
/transactions               # Transaction list
/reports                    # Reports
/profile                    # Profile
```

### Auth Guard

The `_authGuard` redirect function checks for a stored token on every navigation:

```dart
static Future<String?> _authGuard(GoRouterState state) async {
  final isLoggedIn = await _storage.getToken();

  if (isLoggedIn == null && !isAuthRoute && !isOnboarding) {
    return '/auth/login';
  }
  if (isLoggedIn != null && isAuthRoute) {
    return '/dashboard';
  }
  return null;  // allow navigation
}
```

### Tab Navigation

A `ShellRoute` wraps the four main tabs with `_MainShell`, which renders a `NavigationBar`. The tab index is derived from the current URI path.

### Deep Linking

GoRouter's built-in deep linking is enabled by default. The router parses the initial URI and navigates accordingly.

---

## Design Patterns

| Pattern                | Location                                                       |
|------------------------|----------------------------------------------------------------|
| **Clean Architecture**    | Full project — layers separated by directory                |
| **Repository Pattern**    | Both Flutter (domain interface + data impl) and Express (repositories/) |
| **Singleton**             | Service classes (authService, transactionService, etc.) in Express; Riverpod providers in Flutter |
| **Dependency Injection**  | Riverpod `Provider`/`ref.watch` in Flutter; manual DI in Express |
| **Strategy Pattern**      | Express middlewares (auth, rate-limiter, validate, upload) as composable pipeline |
| **Interceptor Pattern**   | Dio interceptors for auth token injection, auto-refresh, logging, error handling |
| **Observer Pattern**      | Riverpod providers → UI rebuild subscriptions |
| **DTO Pattern**           | Flutter models (freezed/json_serializable) for API serialization |
| **Base Repository**       | `BaseRepository.js` with generic CRUD methods, extended by entity-specific repositories |
| **Error Handling**        | Centralized `errorHandler` middleware in Express; interceptor-based in Flutter |

---

## Response Envelope

All API responses follow a consistent JSON envelope:

```json
// Success
{ "success": true, "message": "Login successful.", "data": {} }

// Error
{ "success": false, "message": "Invalid credentials.", "errors": [] }

// Paginated
{
  "success": true,
  "data": [],
  "pagination": { "page": 1, "limit": 20, "total": 100, "totalPages": 5 }
}
```

---

## Security Architecture

- **Authentication**: JWT access token (15 min) + refresh token (7 days) rotation
- **Password Hashing**: bcrypt with salt rounds = 12
- **HTTP Security**: Helmet middleware (CSP, XSS, etc.)
- **CORS**: Whitelisted frontend origin only
- **Rate Limiting**: 100 req/15min general, 5 req/15min for auth endpoints
- **Input Validation**: express-validator on all mutation endpoints
- **File Upload**: Multer memory storage, type + size validation (5 MB max, images only)
- **NoSQL Injection**: Mongoose prevents injection by default
- **Secrets**: Environment variables only, never committed
