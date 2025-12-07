# HealthMate - Personal Health Tracker

A comprehensive Flutter application for tracking personal health metrics with user authentication and data visualization.

## Features

### 🔐 Authentication
- User registration and login
- Secure user sessions
- User-specific data isolation

### 📊 Health Tracking
- Daily health records (steps, calories, water intake, sleep)
- Weekly, monthly, and yearly summaries
- BMI calculation and calorie recommendations
- User profile management

### 📱 Modern UI
- Material Design 3
- Gradient backgrounds
- Responsive cards and layouts
- Teal color theme

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Database**: SQLite
- **State Management**: Provider
- **Authentication**: Custom implementation
- **Charts**: FL Chart

## Setup

1. **Prerequisites**
   ```bash
   flutter --version  # Ensure Flutter is installed
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Database Setup**
   - SQLite database is automatically created on first run
   - No additional setup required

4. **Run Application**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── features/
│   ├── auth/           # Login/Register
│   ├── dashboard/      # Main dashboard
│   ├── health_records/ # Health data management
│   └── profile/        # User profile
├── models/             # Data models
├── providers/          # State management
└── services/           # Database & API services
```

## Key Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.2
  sqflite: ^2.3.0
  path: ^1.8.3
  fl_chart: ^0.68.0
  intl: ^0.19.0
  flutter_dotenv: ^5.1.0
  shared_preferences: ^2.2.2
```

## Usage

1. **Register/Login** - Create account or sign in
2. **Add Health Data** - Track daily metrics
3. **View Dashboard** - See today's summary and trends
4. **Manage Profile** - Update personal information
5. **View Records** - Browse historical health data

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request