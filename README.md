### Ceylon Cloud Product App

A robust Flutter application for managing and viewing products, featuring offline capabilities,
local storage with Drift, and state management using Flutter Bloc.

## 🚀 Features

* State Management: Powered by flutter_bloc for predictable state changes.

* Local Database: Uses drift (SQLite) for offline data persistence.

* Offline First: Caches API responses locally; allows viewing products without an internet
  connection.

* Search: Real-time filtering of local product data.

* Theming: Light and Dark mode support.

* Architecture: Clean architecture separating UI, Blocs, Repositories, and Data sources.

🛠 Prerequisites

Before running this project, ensure you have the following installed:

* Flutter SDK (Latest Stable)
* Dart SDK

## 📥 Getting Started

1. Clone the repository

Git clone

```
https://github.com/NimeshPiyumantha/Ceylon-Cloud.git

cd ceylon-product-app
```

2. Install Dependencies

Download the required packages listed in pubspec.yaml.

```
flutter pub get
```

3. Environment Configuration (.env)

* This project uses flutter_dotenv to manage sensitive API endpoints. You must configure the
  environment variables before running the app.

* Create a file named .env in the root directory of the project.

* Add the API_URL variable to the file:

```
API_URL="Your app url"
```

(Optional) Ensure .env is listed in your .gitignore to prevent committing secrets to version
control.

## 🏭 Code Generation (Important)

This project uses Drift for the database and potentially json_serializable or freezed. You must run
the build runner to generate the necessary .g.dart files before the app will compile.

One-time generation:
Use this if you just downloaded the code or added a new library.

```
dart run build_runner build --delete-conflicting-outputs
```

Continuous generation (Watch mode):
Use this during development. It automatically rebuilds files when you save changes.

```
dart run build_runner watch --delete-conflicting-outputs
```

* Note: You may also use the older command syntax if the above doesn't work:

```
flutter pub run build_runner build
```

📱 Running the App

To run the app on an emulator or connected device:

```
flutter run
```

## 🧪 Running Tests

This project includes unit tests for the Database and Repositories.

Run all tests:

```
flutter test
```

Run specific test file:

```
flutter test test/repositories/product_repository_test.dart
```

## 📂 Project Structure

```
lib/
├── blocs/              # BLoC logic (Product, Favorites, etc.)
├── components/         # Reusable UI widgets (ProductCard, CustomAppBar)
├── database/           # Drift configuration, tables, DAOs, migrations
├── models/             # Data models and DTOs
├── repositories/       # Repos: API + local DB coordination
├── screens/            # UI screens (Home, ProductDetail, Splash)
├── theme/              # UI themes (font theme + dark theme and light theme)
├── main.dart           # App entry point
└── globals.dart        # Global helpers, constants, custom exceptions
```

## 📸 Preview

<p align="center">
  <img src="https://github.com/NimeshPiyumantha/Ceylon-Cloud/blob/master/assets/ss/img.png" width="30%" alt="Screen 1" />
   <img src="https://github.com/NimeshPiyumantha/Ceylon-Cloud/blob/master/assets/ss/img_1.png" width="30%" alt="Screen 2" />
   <img src="https://github.com/NimeshPiyumantha/Ceylon-Cloud/blob/master/assets/ss/img_2.png" width="30%" alt="Screen 3" />
   <img src="https://github.com/NimeshPiyumantha/Ceylon-Cloud/blob/master/assets/ss/img_3.png" width="30%" alt="Screen 4" />
   <img src="https://github.com/NimeshPiyumantha/Ceylon-Cloud/blob/master/assets/ss/img_4.png" width="30%" alt="Screen 5" />
   <img src="https://github.com/NimeshPiyumantha/Ceylon-Cloud/blob/master/assets/ss/img_5.png" width="30%" alt="Screen 6" />

</p>

