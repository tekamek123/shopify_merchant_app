# Shopify Merchant App - Flutter Frontend

A premium, modern Flutter application for managing Shopify store operations. Built with **Clean Architecture** and **Feature-first** organization.

## 🚀 Features
- **Dashboard**: Real-time KPI monitoring, revenue charts, and recent order tracking.
- **Product Management**: Inventory control, price updates, and product listings.
- **Order Processing**: Seamless order fulfillment and status management.
- **Analytics**: Deep insights into store performance and customer behavior.

## 🏗️ Architecture
This project follows **Clean Architecture** principles:
- **Core**: Shared utilities, API clients, authentication, and error handling.
- **Features**: Each module is self-contained with its own:
  - **Data**: Models (DTOs) and Repository implementations.
  - **Domain**: Entities and Use Cases.
  - **Presentation**: BLoC/Cubit, Screens, and Widgets.

## 🛠️ Tech Stack
- **Framework**: Flutter (Material 3)
- **State Management**: `flutter_bloc`
- **Routing**: `go_router`
- **Networking**: `dio`
- **Storage**: `flutter_secure_storage`
- **Design**: `google_fonts` (Inter), Custom Shopify Green palette.

## 📂 Project Structure
```text
lib/
├── app/               # Main app config & routing
├── core/              # Shared infrastructure
│   ├── api/           # Networking & Endpoints
│   ├── auth/          # Authentication logic
│   ├── error/         # Error handling
│   └── utils/         # Helpers & Extensions
└── features/          # Feature-based modules
    ├── dashboard/
    ├── products/
    ├── orders/
    └── analytics/
```

## 🚦 Getting Started
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the app:
   ```bash
   flutter run
   ```
