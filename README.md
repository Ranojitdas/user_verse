# UserVerse

A modern Flutter application that helps you manage and explore user data in a beautiful, intuitive interface. Built with clean architecture and best practices, UserVerse makes it easy to browse, search, and interact with user information.

## 🌟 What Makes UserVerse Special?

UserVerse isn't just another user management app - it's a thoughtfully designed experience that puts users first. Here's what makes it stand out:

### 🎯 Key Features

- **Smart User Discovery**: Browse through users with smooth infinite scrolling
- **Instant Search**: Find users in real-time as you type
- **Rich User Profiles**: View detailed user information, their posts, and todos
- **Create Posts**: Add your own posts to user profiles
- **Pull to Refresh**: Keep your data fresh with a simple pull gesture
- **Dark Mode**: Switch between light and dark themes for comfortable viewing
- **Offline Support**: Access your data even without internet connection

## 📱 See It in Action

### Screenshots

<table>
  <tr>
    <td>
      <img src="https://res.cloudinary.com/deuhpyrku/image/upload/v1749032473/Screenshot_20250604-154802_gf6lqn.png" alt="User List Screen" width="220"/><br>
      <em>Browse users with infinite scrolling and real-time search</em>
    </td>
    <td>
      <img src="https://res.cloudinary.com/deuhpyrku/image/upload/v1749032473/Screenshot_20250604-154829_zjbhqg.png" alt="User Profile" width="220"/><br>
      <em>View detailed user information and their posts</em>
    </td>
    <td>
      <img src="https://res.cloudinary.com/deuhpyrku/image/upload/v1749032473/Screenshot_20250604-154836_bvd26w.png" alt="Create Post" width="220"/><br>
      <em>Create and manage posts for users</em>
    </td>
  </tr>
</table>

### Demo Video

<a href="https://res.cloudinary.com/deuhpyrku/video/upload/v1749032518/screen-20250604-154930_ndzqps.mp4" target="_blank">
  <img src="https://res.cloudinary.com/deuhpyrku/image/upload/v1749032473/Screenshot_20250604-154813_mkeigc.png" alt="UserVerse Demo" width="320"/>
</a>
<br>
<em>Watch UserVerse in action - Click to play</em>

## 🏗️ How It's Built

UserVerse follows clean architecture principles to ensure maintainable, scalable, and testable code. Here's how we organize things:

```
lib/
├── core/           # Core functionality and utilities
│   ├── di/        # Dependency injection setup
│   └── theme/     # App theming and styling
└── features/      # Feature modules
    └── users/     # User management feature
        ├── data/          # Data layer
        │   ├── datasources/   # API and local storage
        │   ├── models/        # Data models
        │   └── repositories/  # Repository implementations
        ├── domain/        # Business logic layer
        │   ├── entities/      # Business objects
        │   ├── repositories/  # Repository interfaces
        │   └── usecases/     # Business use cases
        └── presentation/  # UI layer
            ├── bloc/          # State management
            ├── pages/         # Screens
            └── widgets/       # Reusable components
```

### 🛠️ Technical Highlights

- **State Management**: Using BLoC pattern for predictable state updates
- **Data Handling**: Repository pattern for clean data management
- **Dependency Injection**: Get_it for easy service management
- **Clean Architecture**: Clear separation of concerns

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/userverse.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🔌 API Integration

UserVerse uses the DummyJSON API for data:
- Users: https://dummyjson.com/users
- Posts: https://dummyjson.com/posts/user/{userId}
- Todos: https://dummyjson.com/todos/user/{userId}

## 📦 Dependencies

- **flutter_bloc**: For state management
- **get_it**: For dependency injection
- **http**: For API calls
- **equatable**: For value equality
- **cached_network_image**: For efficient image loading
- **flutter_spinkit**: For beautiful loading animations

## 🤝 Contributing

We love your input! Here's how you can help:

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Made with ❤️ by [Your Name]
