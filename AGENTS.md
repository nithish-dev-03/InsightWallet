# InsightWallet — Agent Guide

## Repo layout
```
apps/mobile/          # Flutter app (material-3, Riverpod, GoRouter)
apps/backend/         # Express API (68 files, 10 services, 9 controllers)
docs/                 # architecture.md, api.md, environment.md, deployment.md
scripts/
```

## Dev commands

### Mobile (Flutter)
```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json_serializable
flutter run
flutter test
flutter build apk --debug    # or --release
```

**Android build gotcha:** If you get AAR metadata errors about compileSdk, the app's `android/app/build.gradle.kts` uses `compileSdk = 36`. Keep it in sync with whatever the SDK manager has installed (`sdkmanager --install "platforms;android-36"`). If a dependency's AAR metadata still references android-33, bump the dependency version (e.g., `connectivity_plus` needs `^6.0.3+`).

### Backend (Express)
```sh
npm install
npm run dev      # nodemon
npm start        # production
npm test
```

## Architecture — Clean Architecture

**Never mix layers.** Each layer depends only on the layer directly below it.

### Flutter layer map
```
presentation/ → (none) → domain/ → data/
providers/              entities/  repositories/
screens/                repos/     models/
                        usecases/  datasources/
```
- `data/repositories/` implements `domain/repositories/` (interface).
- Riverpod providers live in `features/*/presentation/providers/`.
- Only `presentation/` uses Flutter/UI imports; `domain/` is pure Dart.
- `core/providers/providers.dart` exports `apiServiceProvider` and `storageServiceProvider`.

### Backend layer map
```
routes/ → controllers/ → services/ → repositories/ → models/
middlewares/ (auth, error-handler, validate, upload, rate-limit)
```

## Features (10 total)
| Feature | Files | Key Screens |
|---------|-------|-------------|
| Auth | 16 | splash, onboarding(3 slides), login, register, forgot/reset password |
| Dashboard | 6 | balance card, income/expense, pie+line charts, recent txns, AI insight |
| Transactions | 11 | list(infinite scroll), add/edit form, detail view, receipt upload |
| Categories | 6 | grid grouped by income/expense |
| Budgets | 9 | list with progress bars, add/edit form, alerts |
| Reports | 6 | pie/bar/line charts, period selector(weekly/monthly/yearly), cash flow |
| Goals | 8 | list with circular progress, detail with milestones, add form |
| Insights | 6 | monthly summary, spending prediction, budget suggestions, trends |
| Profile | 7 | avatar+stats, security/biometric toggle, edit, export |
| Settings | 6 | appearance, currency, notifications, privacy, data, about |
| Notifications | 6 | filterable list, swipe-to-dismiss, mark read |

## State management — Riverpod
- Business logic in `Notifier`/`AsyncNotifier` providers.
- No `setState` except trivial UI toggles.
- Use `ref.watch` / `ref.listen` for reactivity.

## Routing — GoRouter
- Auth guard via `redirect` on `GoRouter` (checks `StorageService.hasToken`).
- Nested `ShellRoute` for bottom tab navigation (Dashboard, Transactions, Reports, Profile).
- Deep linking enabled by default.
- Route destinations are modular. The authentication screens (Splash, Onboarding, Login, Register, Forgot Password, Reset Password) are fully extracted from the monolithic `app_router.dart` and reside in their respective files under `lib/features/auth/presentation/screens/`.

## Design system — Stitch (Lumina Finance)
The app matches the Stitch project at https://stitch.withgoogle.com/projects/16980896761399485625

| Token | Dark Value | Light Value |
|-------|-----------|-------------|
| Background | `#15121b` | `#fcf8ff` |
| Surface | `#221e28` | `#f0ecf9` |
| Primary | `#d2bbff` | `#3525cd` |
| Primary Container | `#7c3aed` | `#4f46e5` |
| On Surface | `#e8dfee` | `#1b1b24` |

**Typography:** Headlines → Hanken Grotesk, Body → Plus Jakarta Sans, Labels/Data → Geist (JetBrains Mono in app).

**Spacing:** 8px grid (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48).

**Radius:** sm=4, md=8, lg=12, xl=24, full=circular.

**Authentication Flow Modularization:**
- **Splash Screen (`splash_screen.dart`)**: Implements premium radial background glow, particle animations, and floating orbs conforming to Stitch specs.
- **Onboarding Screen (`onboarding_screen.dart`)**: Bento-inspired slides with scroll transitions, interactive transaction list animations, and indicators.
- **Form Card Screens (Login, Register, Forgot Password, Reset Password)**: Utilize glassmorphic card containers (`GlassPanel`), animated button behaviors (`InteractiveButton`), and unified footers (`FooterLink`, `FooterDivider`) defined in `lib/features/auth/presentation/widgets/auth_widgets.dart`.
- **Modern APIs**: Refactored all color opacity operations to use `.withValues(alpha: ...)` to keep clean from Flutter warnings.

Always use constants from `AppColors`, `AppTypography`, `Insets`, `AppRadius`. No magic numbers.

## API conventions
- REST at `/api/v1/`. Consistent JSON envelope:
  - Success: `{ "success": true, "message": "...", "data": {} }`
  - Error:   `{ "success": false, "message": "...", "errors": [] }`
- Pagination: `{ ...data: { items: [], pagination: { page, limit, total, pages } } }`
- JWT access token in `Authorization: Bearer <token>`.
- Refresh token in response body (not cookie).

## Naming
| Thing         | Style           | Example              |
|---------------|-----------------|----------------------|
| Dart files    | `snake_case`    | `transaction_list.dart` |
| JS files      | `camelCase`     | `authController.js`  |
| Classes       | `PascalCase`    | `TransactionList`    |
| Routes        | `kebab-case`    | `/transaction-details` |
| Collections   | `camelCase`     | `transactionCategories` |

## Git
- Conventional commits: `feat(auth):`, `fix(api):`, `refactor:`, `chore:`, `test:`, `docs:`.
- Branch: `feature/*`, `bugfix/*`, `hotfix/*` off `develop`; PR into `main`.

## Security
- `.env` for secrets — never commit.
- Helmet, CORS, rate-limiting, input validation, NoSQL-injection prevention.
- `bcrypt` for passwords. Never store plaintext.
- Validate + sanitize everything server-side. Never trust client input.
- Refresh token rotation (old token deleted on refresh).

## Codegen artifacts
- `*.freezed.dart`, `*.g.dart` — committed. Run `build_runner` after editing annotated models.
- Regenerate with: `dart run build_runner build --delete-conflicting-outputs`

## Testing
- Unit + widget tests for critical business logic.
- Backend: `supertest` for API / integration tests.
- Run `flutter test` and `npm test` before pushing.

## Reuse rule
Before creating a new model, repository, provider, service, or widget, check if one already exists in the same layer/feature. Duplicate abstractions are tech debt.

## Documentation
- `docs/architecture.md` — Clean Architecture + data flow
- `docs/api.md` — All 9 resource groups documented with request/response schemas
- `docs/environment.md` — MongoDB Atlas, Cloudinary, JWT setup
- `docs/deployment.md` — Flutter builds, PM2, Nginx, security checklist
