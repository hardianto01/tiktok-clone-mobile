# 🎵 TikTok Clone - Flutter Mobile App

Flutter cross-platform application for TikTok Clone with video sharing capabilities.

## ✨ Features
- 📱 **Cross-platform** (iOS, Android, Web)
- 🎥 **Video upload and playback**
- 👥 **User authentication and profiles**
- ❤️ **Social interactions** (like, comment, follow)
- 🔍 **Search and discovery**
- 📊 **Real-time video feed**
- 🎯 **Category-based content**

## 🚀 Quick Setup

### Prerequisites
- Flutter 3.0+ installed
- Android Studio / VS Code
- Backend API running

### Installation
1. **Clone repository**
   ```bash
   git clone https://github.com/Driaaan17/tiktok-clone-mobile.git
   cd tiktok-clone-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint** (See Configuration section)

4. **Run the app**
   ```bash
   flutter run              # For mobile
   flutter run -d chrome    # For web
   ```

## ⚙️ Configuration

### API Endpoints
API configuration is in **`lib/config/api_config.dart`**:

```dart
// Development (local)
static const String _developmentUrl = 'http://localhost:8000/api';

// Production (update with your domain)
static const String _productionUrl = 'https://your-backend-domain.com/api';
```

### For Deployment:
1. Update `_productionUrl` with your backend domain
2. Build for web: `flutter build web --release`
3. Deploy `build/web` folder to hosting (Vercel, Netlify, etc.)

## 🔧 Tech Stack
- **Flutter 3.0+** - Cross-platform framework
- **Provider** - State management
- **HTTP** - API communication
- **Video Player** - Media playback
- **File Picker** - File selection and upload

## 📁 Project Structure
```
lib/
├── config/          # Configuration files
│   └── api_config.dart
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # API services
└── widgets/         # Reusable components
```

## 🌐 API Integration

This app connects to a Laravel backend API for:
- User authentication (login/register)
- Video CRUD operations
- Social features (likes, comments, follows)
- Category management
- File uploads

**Backend Repository:** https://github.com/Driaaan17/tiktok-clone-backend

## 🚀 Deployment Options

### Frontend Hosting:
- **Vercel** (Recommended) - Free tier available
- **Netlify** - Free tier available
- **Firebase Hosting** - Google's hosting platform
- **GitHub Pages** - Free static hosting

### Build Commands:
```bash
flutter build web --release     # For web deployment
flutter build apk --release     # For Android APK
flutter build ios --release     # For iOS (Mac only)
```

## 🔗 Environment Switching

The app automatically switches between development and production:
- **Debug mode**: Uses localhost backend
- **Release mode**: Uses production backend

No manual switching required! 🎯

## 📱 Platform Support
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🤝 Contributing
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License
This project is licensed under the MIT License.

## 🆘 Support
- Create an [Issue](https://github.com/Driaaan17/tiktok-clone-mobile/issues) for bugs
- Check [Backend Repository](https://github.com/Driaaan17/tiktok-clone-backend) for API docs

---

**Made with ❤️ using Flutter**

🔗 **Backend API**: https://github.com/Driaaan17/tiktok-clone-backend
```


Sekarang mobile repository sudah lengkap dengan:
- ✅ Configuration files
- ✅ Updated API service
- ✅ Comprehensive README
- ✅ Proper folder structure

**Lanjut ke backend repository sekarang?** 🔧
