# InsightWallet

> **Track smarter. Spend wiser.**

InsightWallet is a modern cross-platform personal finance application built with Flutter, Express.js, and MongoDB Atlas. It provides intelligent budgeting, transaction tracking, goal setting, and AI-powered financial insights to help users take control of their finances.

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │
│  │ Dashboard│  │Transactions│  │ Budgets │  │ Goals  │ │
│  ├──────────┤  ├──────────┤  ├──────────┤  ├────────┤ │
│  │ Insights│  │  Reports │  │ Profile │  │Settings│ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └───┬────┘ │
│       │              │              │              │     │
│  ┌────▼──────────────▼──────────────▼──────────────▼──┐ │
│  │                APPLICATION LAYER                    │ │
│  │         Riverpod Providers / Use Cases              │ │
│  └──────────────────────┬──────────────────────────────┘ │
│                         │                                │
│  ┌──────────────────────▼──────────────────────────────┐ │
│  │                  DOMAIN LAYER                       │ │
│  │         Entities / Repository Interfaces            │ │
│  └──────────────────────┬──────────────────────────────┘ │
│                         │                                │
│  ┌──────────────────────▼──────────────────────────────┐ │
│  │                   DATA LAYER                        │ │
│  │    Models / Repository Implementations / Sources    │ │
│  └──────────────────────┬──────────────────────────────┘ │
└─────────────────────────┼────────────────────────────────┘
                          │
               ┌──────────▼──────────┐
               │    Express.js API   │
               │   (REST / JSON)     │
               └──────────┬──────────┘
                          │
               ┌──────────▼──────────┐
               │    MongoDB Atlas    │
               └─────────────────────┘
```

---

## Tech Stack

| Layer       | Technology                              |
|-------------|-----------------------------------------|
| **Frontend**  | Flutter, Dart, Riverpod, GoRouter      |
|              | Dio, fl_chart, flutter_secure_storage   |
|              | Hive, freezed, json_serializable       |
|              | local_auth, shimmer, google_fonts       |
| **Backend**   | Node.js, Express.js                     |
|              | MongoDB, Mongoose ODM                   |
|              | JWT (access + refresh tokens)           |
|              | bcryptjs, helmet, cors, compression    |
|              | express-rate-limit, express-validator  |
|              | Cloudinary, Nodemailer, Multer          |
|              | Swagger (swagger-jsdoc + swagger-ui)    |
| **Database**  | MongoDB Atlas                           |
| **Testing**   | Jest, Supertest (backend)               |
|              | flutter_test (widget/unit tests)        |

---

## Features

- **Dashboard** — Real-time financial overview with balance, income/expense charts
- **Transactions** — CRUD with filtering, search, date range, receipt upload
- **Categories** — Customizable income/expense categories with icons and colors
- **Budgets** — Monthly/ weekly/ yearly budgets with spending alerts
- **Goals** — Savings goals with milestone tracking
- **Reports** — Detailed financial reports and summaries
- **AI Insights** — Monthly summaries, spending predictions, budget suggestions, expense trends
- **Notifications** — Budget alerts, goal reminders, monthly summaries
- **Profile** — Avatar upload, personal details, account statistics
- **Settings** — Theme, language, currency, notification preferences, privacy controls
- **Authentication** — JWT access/refresh tokens, password reset, biometric auth, and Stitch-compliant user interfaces (Splash, Onboarding, Login, Register, Forgot Password, Reset Password) fully modularized into Clean Architecture feature screens and shared widgets.

---

## Prerequisites

- **Flutter SDK** >=3.2.0
- **Node.js** >=18.0.0
- **MongoDB Atlas** account (or local MongoDB instance)
- **Cloudinary** account (for image uploads)
- **Gmail account** (with app password for email sending)

---

## Quick Start

### Backend

```bash
cd apps/backend
cp .env.example .env    # Edit with your configuration values
npm install
npm run dev             # Starts on http://localhost:5000
```

API docs available at `http://localhost:5000/api/v1/docs`

### Frontend (Mobile)

```bash
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run             # Launches on connected device/emulator
```

To specify the API server address:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_IP:5000
```

### Build APK

```bash
flutter build apk --release
```

---

## Project Structure

```
insightwallet/
├── apps/
│   ├── mobile/                        # Flutter application
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── core/
│   │   │   │   ├── config/            # AppConfig, ApiConfig
│   │   │   │   ├── constants/         # App constants
│   │   │   │   ├── providers/         # Global Riverpod providers
│   │   │   │   ├── router/            # GoRouter configuration
│   │   │   │   ├── services/          # ApiService, AuthService, Hive, Storage
│   │   │   │   ├── shared/widgets/    # Reusable UI components
│   │   │   │   ├── theme/             # Colors, typography, radius, spacing
│   │   │   │   └── utils/             # Validators, formatters
│   │   │   └── features/
│   │   │       ├── auth/
│   │   │       ├── budgets/
│   │   │       ├── categories/
│   │   │       ├── dashboard/
│   │   │       ├── goals/
│   │   │       ├── insights/
│   │   │       ├── notifications/
│   │   │       ├── profile/
│   │   │       ├── reports/
│   │   │       ├── settings/
│   │   │       └── transactions/
│   │   └── pubspec.yaml
│   └── backend/                       # Express.js API
│       ├── src/
│       │   ├── server.js              # Entry point
│       │   ├── app.js                 # Express app setup
│       │   ├── config/                # Database, env
│       │   ├── controllers/           # Request handlers
│       │   ├── middlewares/           # Auth, rate-limit, upload, validate, error
│       │   ├── models/                # Mongoose schemas
│       │   ├── repositories/          # Data access layer
│       │   ├── routes/                # Route definitions
│       │   ├── services/              # Business logic
│       │   ├── utils/                 # JWT, email, Swagger, API response
│       │   └── validators/            # express-validator schemas
│       ├── tests/
│       └── .env.example
├── docs/                              # Documentation
├── scripts/                           # Automation scripts
├── AGENTS.md                          # AI agent guidelines
└── opencode.json                      # opencode configuration
```

Each Flutter feature follows Clean Architecture:

```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/         (interface)
│   └── usecases/
└── presentation/
    ├── providers/            (Riverpod)
    └── screens/
```

---

## Screenshots

> _Coming soon_

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit using conventional commits: `feat(auth): add biometric login`
4. Push and open a Pull Request against `develop`

### Guidelines

- Maintain Clean Architecture layering — never mix layers
- Run `dart run build_runner build --delete-conflicting-outputs` after editing models
- Run `flutter test` and `npm test` before submitting
- Follow existing code style and naming conventions
- No secrets in code — use `.env` files

---

## License

MIT License — see [LICENSE](LICENSE) for details.
