# Banking App

A comprehensive Flutter banking application with spending analytics, transaction management, and budget tracking.

## Features

### 🔐 Authentication
- Local user authentication
- Secure login/registration system
- Session persistence

### 💰 Account Management
- Multiple account support (Checking, Savings, Credit, Investment)
- Real-time balance tracking
- Account switching

### 📊 Transaction Management
- Add, edit, and delete transactions
- Income and expense tracking
- Category-based organization
- Search and filter functionality
- Swipe-to-delete with confirmation
- Transaction notes and details

### 📈 Analytics & Charts
- **Pie Chart**: Spending breakdown by category with percentages
- **Bar Chart**: Daily spending trends
- Income vs Expenses comparison
- Period filtering (Week, Month, Year)
- Category-wise spending analysis

### 🎯 Categories
- Pre-defined expense categories (Food, Transport, Shopping, Entertainment, Bills, Health, Education)
- Pre-defined income categories (Salary, Business, Investment, Gift)
- Color-coded and icon-based categorization

### 🛡️ Edge Cases Handled
- Input validation on all forms
- Empty state handling
- Negative balance prevention
- Decimal precision for currency
- Date validation
- Error handling with user-friendly messages
- Offline support (all data stored locally)

## Installation

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for mobile deployment)

### Setup

1. **Clone or navigate to the project directory**:
   ```bash
   cd "d:\Term 5\BaNkingApp"
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # For development
   flutter run

   # For specific device
   flutter run -d <device_id>

   # List available devices
   flutter devices
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── account.dart
│   ├── transaction.dart
│   ├── category.dart
│   └── budget.dart
├── providers/                # State management
│   └── app_state.dart
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── transactions_screen.dart
│   ├── add_transaction_screen.dart
│   ├── analytics_screen.dart
│   ├── accounts_screen.dart
│   └── settings_screen.dart
└── services/                 # Business logic
    └── database_helper.dart
```

## Usage

### First Time Setup
1. Launch the app
2. Register with a username and password (minimum 4 characters)
3. A default account will be created automatically

### Adding Transactions
1. Tap the "+" button on the home or transactions screen
2. Select transaction type (Income/Expense)
3. Enter title, amount, and select category
4. Optionally add notes
5. Select date (defaults to today)
6. Tap the checkmark to save

### Viewing Analytics
1. Navigate to the Analytics tab
2. Select time period (Week/Month/Year)
3. View pie chart for category breakdown
4. View bar chart for daily spending trends
5. See income vs expenses summary

### Managing Accounts
1. Navigate to the Accounts tab
2. Tap on an account to make it active
3. Use "+" button to add new accounts
4. All transactions are linked to the active account

## Technologies Used

- **Flutter**: UI framework
- **Provider**: State management
- **SQLite**: Local database (sqflite)
- **fl_chart**: Interactive charts
- **intl**: Date and number formatting
- **shared_preferences**: Simple data persistence

## Database Schema

### Accounts
- id, name, balance, currency, type, createdAt

### Transactions
- id, title, amount, category, date, type, notes, accountId

### Categories
- id, name, icon, color, type

### Budgets
- id, categoryId, limit, startDate, endDate

## Features in Detail

### Input Validation
- All amounts must be greater than 0
- Username required, password minimum 4 characters
- Required fields validated before submission
- Decimal amounts supported with 2-digit precision

### Error Handling
- Database operation errors caught and displayed
- Insufficient balance warnings
- Duplicate submission prevention
- Graceful handling of missing data

### Offline Support
- All data stored locally in SQLite
- No internet connection required
- Fast and responsive

## Screenshots

(Screenshots would be added here after running the app)

## Future Enhancements

- Budget tracking with alerts
- Recurring transactions
- Data export (CSV/PDF)
- Cloud backup and sync
- Multi-currency support
- Receipt photo attachments
- Biometric authentication

## License

This project is created for educational purposes.

## Support

For issues or questions, please create an issue in the repository.
