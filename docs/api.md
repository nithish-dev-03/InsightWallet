# API Documentation

**Base URL:** `/api/v1`

All endpoints return a consistent JSON envelope:

```json
// Success
{ "success": true, "message": "...", "data": {} }

// Error
{ "success": false, "message": "...", "errors": [] }

// Paginated
{
  "success": true,
  "data": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

**Authentication:** JWT access token in `Authorization: Bearer <token>` header. Refresh token sent in request body (not httpOnly cookie in v1).

---

## Health Check

### `GET /api/v1/health`

No authentication required.

**Response:**
```json
{
  "success": true,
  "message": "OK",
  "data": { "uptime": 1234.56 }
}
```

---

## Authentication

All auth endpoints except `logout` have rate limiting (5 requests per 15 minutes).

### `POST /api/v1/auth/register`

No authentication required.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Registration successful.",
  "data": {
    "user": {
      "_id": "65f1a2b3c4d5e6f7a8b9c0d1",
      "name": "John Doe",
      "email": "john@example.com",
      "avatar": { "url": "", "publicId": "" },
      "currency": "USD",
      "theme": "system",
      "emailVerified": false,
      "biometricEnabled": false,
      "createdAt": "2024-03-13T12:00:00.000Z"
    },
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### `POST /api/v1/auth/login`

No authentication required.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful.",
  "data": {
    "user": { "...": "..." },
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### `POST /api/v1/auth/refresh`

No authentication required.

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response:**
```json
{
  "success": true,
  "message": "Token refreshed.",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### `POST /api/v1/auth/logout`

No authentication required.

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response:**
```json
{
  "success": true,
  "message": "Logout successful.",
  "data": null
}
```

### `POST /api/v1/auth/forgot-password`

No authentication required.

**Request Body:**
```json
{
  "email": "john@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "If the email exists, a password reset link has been sent.",
  "data": null
}
```

### `POST /api/v1/auth/reset-password/:token`

No authentication required.

**Request Body:**
```json
{
  "password": "newSecurePassword456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password reset successful.",
  "data": null
}
```

---

## Transactions

All transaction endpoints require authentication.

### `GET /api/v1/transactions`

List transactions with filtering and pagination.

**Query Parameters:**
| Param       | Type   | Description                          |
|-------------|--------|--------------------------------------|
| `page`      | number | Page number (default: 1)             |
| `limit`     | number | Items per page (default: 20)         |
| `type`      | string | Filter: `income` or `expense`        |
| `category`  | string | Category ObjectId                    |
| `startDate` | string | ISO date (inclusive)                 |
| `endDate`   | string | ISO date (inclusive)                 |
| `search`    | string | Description search (regex, case-insensitive) |
| `sort`      | string | Sort field, prefix `-` for desc (default: `-date`) |

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "_id": "65f1a2b3c4d5e6f7a8b9c0d2",
      "user": "65f1a2b3c4d5e6f7a8b9c0d1",
      "type": "expense",
      "amount": 49.99,
      "category": { "_id": "...", "name": "Groceries", "icon": "shopping-cart", "color": "#34d399" },
      "description": "Weekly groceries",
      "date": "2024-03-13T10:30:00.000Z",
      "tags": ["food", "essentials"],
      "receipt": { "url": "", "publicId": "" },
      "isRecurring": false,
      "note": "",
      "createdAt": "2024-03-13T12:00:00.000Z",
      "updatedAt": "2024-03-13T12:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 42,
    "totalPages": 3,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

### `GET /api/v1/transactions/summary`

Get transaction summary for a date range.

**Query Parameters:**
| Param       | Type   | Required | Description        |
|-------------|--------|----------|--------------------|
| `startDate` | string | Yes      | ISO date           |
| `endDate`   | string | Yes      | ISO date           |

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "income": {
      "total": 5200.00,
      "count": 3,
      "categories": [
        { "_id": "cat_id", "name": "Salary", "total": 5000.00, "count": 1 },
        { "_id": "cat_id", "name": "Freelance", "total": 200.00, "count": 2 }
      ]
    },
    "expense": {
      "total": 3200.00,
      "count": 15,
      "categories": [
        { "_id": "cat_id", "name": "Rent", "total": 1500.00, "count": 1 },
        { "_id": "cat_id", "name": "Groceries", "total": 800.00, "count": 8 }
      ]
    },
    "net": 2000.00
  }
}
```

### `GET /api/v1/transactions/:id`

Get a single transaction.

**Response:** Single transaction object.

### `POST /api/v1/transactions`

Create a new transaction.

**Request Body:**
```json
{
  "type": "expense",
  "amount": 49.99,
  "category": "65f1a2b3c4d5e6f7a8b9c0d3",
  "description": "Weekly groceries",
  "date": "2024-03-13T10:30:00.000Z",
  "tags": ["food"],
  "isRecurring": false,
  "note": ""
}
```

**Response (201):** Created transaction object.

### `PUT /api/v1/transactions/:id`

Update a transaction.

**Request Body:** Same as create (partial updates supported).

**Response:** Updated transaction object.

### `DELETE /api/v1/transactions/:id`

Delete a transaction.

**Response:**
```json
{
  "success": true,
  "message": "Transaction deleted.",
  "data": null
}
```

---

## Categories

All category endpoints require authentication.

### `GET /api/v1/categories`

List all categories for the authenticated user (includes system default categories).

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "_id": "65f1a2b3c4d5e6f7a8b9c0d3",
      "user": "65f1a2b3c4d5e6f7a8b9c0d1",
      "name": "Groceries",
      "type": "expense",
      "icon": "shopping-cart",
      "color": "#34d399",
      "isDefault": false,
      "sortOrder": 1,
      "createdAt": "2024-03-13T12:00:00.000Z"
    }
  ]
}
```

### `GET /api/v1/categories/:id`

Get a single category.

### `POST /api/v1/categories`

Create a category.

**Request Body:**
```json
{
  "name": "Transportation",
  "type": "expense",
  "icon": "car",
  "color": "#3b82f6"
}
```

**Response (201):** Created category object.

### `PUT /api/v1/categories/:id`

Update a category.

### `DELETE /api/v1/categories/:id`

Delete a category.

---

## Budgets

All budget endpoints require authentication.

### `GET /api/v1/budgets`

List budgets with pagination.

**Query Parameters:** `page`, `limit`, `period` (weekly/monthly/yearly), `category`.

**Response:** Paginated list of budgets.
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "_id": "65f1a2b3c4d5e6f7a8b9c0d4",
      "user": "65f1a2b3c4d5e6f7a8b9c0d1",
      "category": { "_id": "...", "name": "Groceries" },
      "amount": 500.00,
      "spent": 320.50,
      "period": "monthly",
      "startDate": "2024-03-01T00:00:00.000Z",
      "endDate": "2024-03-31T23:59:59.999Z",
      "notifications": true,
      "createdAt": "2024-03-01T12:00:00.000Z"
    }
  ],
  "pagination": { "...": "..." }
}
```

### `GET /api/v1/budgets/alerts`

Get budget alerts for budgets that are near or over their limit.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "_id": "65f1a2b3c4d5e6f7a8b9c0d4",
      "category": { "name": "Groceries" },
      "amount": 500.00,
      "spent": 480.00,
      "percentage": 96,
      "period": "monthly",
      "status": "warning"
    }
  ]
}
```

### `GET /api/v1/budgets/:id`

Get a single budget.

### `POST /api/v1/budgets`

Create a budget.

**Request Body:**
```json
{
  "category": "65f1a2b3c4d5e6f7a8b9c0d3",
  "amount": 500.00,
  "period": "monthly",
  "startDate": "2024-03-01T00:00:00.000Z",
  "endDate": "2024-03-31T23:59:59.999Z",
  "notifications": true
}
```

**Response (201):** Created budget object.

### `PUT /api/v1/budgets/:id`

Update a budget.

### `DELETE /api/v1/budgets/:id`

Delete a budget.

---

## Goals

All goal endpoints require authentication.

### `GET /api/v1/goals`

List goals with pagination.

**Query Parameters:** `page`, `limit`, `status` (active/completed/cancelled).

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "_id": "65f1a2b3c4d5e6f7a8b9c0d5",
      "user": "65f1a2b3c4d5e6f7a8b9c0d1",
      "name": "Emergency Fund",
      "targetAmount": 10000.00,
      "currentAmount": 4500.00,
      "deadline": "2024-12-31T23:59:59.999Z",
      "icon": "target",
      "color": "#6366f1",
      "status": "active",
      "milestones": [
        {
          "name": "First 25%",
          "amount": 2500.00,
          "achieved": true,
          "achievedAt": "2024-02-15T10:00:00.000Z",
          "_id": "milestone_id"
        },
        {
          "name": "Halfway",
          "amount": 5000.00,
          "achieved": false,
          "achievedAt": null,
          "_id": "milestone_id"
        }
      ],
      "createdAt": "2024-01-01T12:00:00.000Z"
    }
  ],
  "pagination": { "...": "..." }
}
```

### `GET /api/v1/goals/:id`

Get a single goal.

### `POST /api/v1/goals`

Create a goal.

**Request Body:**
```json
{
  "name": "Emergency Fund",
  "targetAmount": 10000.00,
  "currentAmount": 0,
  "deadline": "2024-12-31T23:59:59.999Z",
  "icon": "target",
  "color": "#6366f1"
}
```

**Response (201):** Created goal object.

### `PUT /api/v1/goals/:id`

Update a goal.

### `DELETE /api/v1/goals/:id`

Delete a goal.

### `POST /api/v1/goals/:id/milestones`

Add a milestone to a goal.

**Request Body:**
```json
{
  "name": "First 25%",
  "amount": 2500.00
}
```

**Response (201):** Updated goal with new milestone.

---

## Insights

All insight endpoints require authentication. No pagination — returns computed data.

### `GET /api/v1/insights/monthly-summary`

Get a monthly summary of income, expenses, and trends.

**Query Parameters:**
| Param   | Type   | Description                              |
|---------|--------|------------------------------------------|
| `month`  | number | Month (1-12, default: current)          |
| `year`   | number | Year (default: current)                  |

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "month": 3,
    "year": 2024,
    "income": { "total": 5200.00, "categories": [...] },
    "expense": { "total": 3200.00, "categories": [...] },
    "net": 2000.00,
    "topCategories": [...],
    "comparison": { "lastMonth": { "income": 4800.00, "expense": 3500.00 } }
  }
}
```

### `GET /api/v1/insights/spending-prediction`

AI-based prediction of next month's spending.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "predictedTotal": 3400.00,
    "confidence": 0.85,
    "categoryBreakdown": [
      { "category": "Groceries", "predicted": 600.00, "trend": "increasing" }
    ],
    "factors": ["Seasonal increase in utilities"]
  }
}
```

### `GET /api/v1/insights/budget-suggestions`

Get AI-generated budget suggestions based on spending history.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "suggestions": [
      {
        "category": "Dining Out",
        "currentSpend": 450.00,
        "suggestedBudget": 300.00,
        "reason": "35% above average for your profile"
      }
    ],
    "totalSavingsPotential": 150.00
  }
}
```

### `GET /api/v1/insights/expense-trends`

Get expense trends over time.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "trends": [
      { "month": "2024-01", "total": 2800.00, "categories": [...] },
      { "month": "2024-02", "total": 3100.00, "categories": [...] },
      { "month": "2024-03", "total": 3200.00, "categories": [...] }
    ],
    "overallTrend": "increasing",
    "averageMonthly": 3033.33
  }
}
```

---

## Notifications

All notification endpoints require authentication.

### `GET /api/v1/notifications`

List notifications with pagination.

**Query Parameters:** `page`, `limit`, `read` (true/false), `type` (budget_alert, goal_reminder, monthly_summary, insight, system).

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "notifications": [
      {
        "_id": "65f1a2b3c4d5e6f7a8b9c0d6",
        "user": "65f1a2b3c4d5e6f7a8b9c0d1",
        "type": "budget_alert",
        "title": "Budget Alert: Groceries",
        "body": "You have spent 90% of your Groceries budget.",
        "data": { "budgetId": "...", "percentage": 90 },
        "read": false,
        "createdAt": "2024-03-13T12:00:00.000Z"
      }
    ],
    "unreadCount": 5
  },
  "pagination": { "...": "..." }
}
```

### `PATCH /api/v1/notifications/:id/read`

Mark a single notification as read.

**Response:** Updated notification object.

### `PATCH /api/v1/notifications/read-all`

Mark all notifications as read.

**Response:**
```json
{
  "success": true,
  "message": "All notifications marked as read.",
  "data": null
}
```

### `DELETE /api/v1/notifications/:id`

Delete a notification.

---

## Profile

All profile endpoints require authentication.

### `GET /api/v1/profile`

Get the authenticated user's profile.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "_id": "65f1a2b3c4d5e6f7a8b9c0d1",
    "name": "John Doe",
    "email": "john@example.com",
    "avatar": { "url": "https://res.cloudinary.com/...", "publicId": "..." },
    "currency": "USD",
    "theme": "system",
    "emailVerified": true,
    "biometricEnabled": true,
    "createdAt": "2024-01-01T12:00:00.000Z"
  }
}
```

### `PATCH /api/v1/profile`

Update profile fields.

**Request Body:**
```json
{
  "name": "John Updated",
  "currency": "EUR",
  "theme": "dark",
  "biometricEnabled": true
}
```

**Response:** Updated profile object.

### `POST /api/v1/profile/avatar`

Upload a profile avatar. Must be `multipart/form-data`.

**Form Data:**
| Field    | Type | Description               |
|----------|------|---------------------------|
| `avatar` | file | Image (jpg, png, gif, webp, max 5 MB) |

**Response:** Updated user with new avatar URL.

### `GET /api/v1/profile/statistics`

Get user account statistics.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "totalTransactions": 245,
    "totalIncome": 52000.00,
    "totalExpense": 38000.00,
    "activeBudgets": 4,
    "activeGoals": 3,
    "goalsCompleted": 2,
    "currentBalance": 14000.00,
    "memberSince": "2024-01-01T12:00:00.000Z"
  }
}
```

---

## Settings

All settings endpoints require authentication.

### `GET /api/v1/settings`

Get user settings.

**Response:**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "_id": "65f1a2b3c4d5e6f7a8b9c0d7",
    "user": "65f1a2b3c4d5e6f7a8b9c0d1",
    "theme": "system",
    "language": "en",
    "currency": "USD",
    "notifications": {
      "budgetAlerts": true,
      "goalReminders": true,
      "monthlySummary": true,
      "insights": true
    },
    "privacy": {
      "showBalance": true,
      "showTransactions": true
    },
    "exportFormat": "csv",
    "createdAt": "2024-01-01T12:00:00.000Z"
  }
}
```

### `PATCH /api/v1/settings`

Update settings. Partial updates supported.

**Request Body:**
```json
{
  "theme": "dark",
  "language": "fr",
  "currency": "EUR",
  "notifications": { "budgetAlerts": false },
  "privacy": { "showBalance": false },
  "exportFormat": "pdf"
}
```

**Response:** Updated settings object.

---

## Error Codes

| Status Code | Meaning                       |
|-------------|-------------------------------|
| 200         | Success                       |
| 201         | Created                       |
| 400         | Validation error / bad request |
| 401         | Unauthorized (missing/invalid token) |
| 403         | Forbidden                     |
| 404         | Resource not found            |
| 409         | Conflict (duplicate)          |
| 429         | Rate limit exceeded           |
| 500         | Internal server error         |

---

## Swagger UI

Interactive API documentation is available at `/api/v1/docs` when the server is running.
