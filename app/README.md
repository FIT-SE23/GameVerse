## GameVerse - Flutter Gaming Platform

A modern Flutter-based gaming platform that provides users with game discovery, library management, community forums, and more. The application supports multiple authentication methods including Google OAuth and features a responsive design for desktop platforms.

---

### 🚀 Features

* **Game Discovery**: Browse popular games, featured discounts, and explore new releases
* **Library Management**: Manage your game collection and track your library
* **Community Forums**: Engage with other gamers and discuss games
* **Downloads**: Track and manage game downloads
* **Advanced Search**: Find games with powerful search and filtering
* **Multiple Authentication**: Support for email/password, Google OAuth, and Supabase
* **Theme Support**: Light and dark theme options
* **Deep Linking**: Custom URL protocol support for seamless navigation

---

### 📂 Project Structure

```
lib/
├── main.dart                    # Entry point
├── config/                      # Configuration files
│   ├── api_endpoints.dart       # API endpoint definitions
│   ├── app_providers.dart       # Provider configurations
│   ├── app_theme.dart           # Theme definitions
│   └── url_protocol/             # Custom URL protocol handlers
├── data/                        # Data layer
│   ├── repositories/            # Repository implementations
│   └── services/                # API clients and services
├── domain/                      # Domain layer
│   ├── models/                  # Data models
│   └── use_cases/               # Business logic
├── routing/                     # Navigation
│   ├── router.dart              # GoRouter configuration
│   └── routes.dart              # Route definitions
└── ui/                          # Presentation layer
    ├── auth/                    # Authentication screens
    ├── home/                    # Home screen components
    ├── library/                 # Library management
    ├── forums/                  # Community forums
    ├── shared/                  # Shared UI components
    └── ...                      # Other feature modules
```

---

### 📋 Prerequisites

* **Flutter SDK** (>= 3.0.0)
* **Dart SDK** (>= 3.0.0)
* **Git**
* **IDE** (VS Code, Android Studio, or IntelliJ IDEA)

**Platform-specific requirements:**

* **Windows**

  * Visual Studio 2022 or Visual Studio Build Tools with C++ desktop development workload
  * Windows 10 SDK
* **Web**

  * Chrome browser for debugging

---

### ⚙️ Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/FIT-SE23/GameVerse.git
   cd GameVerse/app
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Environment Setup**

   * Create a `.env` file in the root directory with the following:

     ```bash
     # Supabase Configuration
     SUPABASE_URL=your_supabase_url_here
     SUPABASE_ANON_KEY=your_supabase_anon_key_here
     ```

4. **Generate Code**

   ```bash
   flutter packages pub run build_runner build
   ```

---

### ▶️ Running the Application

#### Development Mode

* **Windows desktop**

  ```bash
  flutter run -d windows
  ```
* **Web**

  ```bash
  flutter run -d chrome
  ```
* **Specific device**

  ```bash
  flutter devices
  flutter run -d <device_id>
  ```

#### Build for Production

* **Windows desktop**

  ```bash
  flutter build windows --release
  ```
* **Web**

  ```bash
  flutter build web --release
  ```

---

### 🏗 Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

1. **Data Layer**

   * *Repositories*: Handle data operations and API communication
   * *Services*: API clients and external service integrations
   * *Models*: Data transfer objects and entity definitions

2. **Domain Layer**

   * *Use Cases*: Business logic implementation
   * *Models*: Domain entities and value objects

3. **Presentation Layer**

   * *Screens*: UI components organized by features
   * *ViewModels*: State management using Provider pattern
   * *Widgets*: Reusable UI components

---

### 🔧 Key Technologies

* **State Management**: Provider pattern
* **Navigation**: GoRouter with nested routes
* **HTTP Client**: Custom API client with response handling
* **Authentication**: Supabase Auth + Google OAuth
* **Theming**: Material 3 design system
* **Deep Linking**: Custom URL protocol handling

---

### 📞 Support

* **Email**: [support@gameverse.com](mailto:support@gameverse.com)
* **Discord**: [GameVerse Community](https://discord.gg/GameVerse...)
* **Issues**: [GitHub Issues](https://github.com/FIT-SE23/GameVerse)

---

### 🙏 Acknowledgments

* Flutter Team for the amazing framework
* Supabase for authentication and backend services
* Steam API for game data
* Material Design for UI/UX guidelines

---

Happy Gaming! 🎮
