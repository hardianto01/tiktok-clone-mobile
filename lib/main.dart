// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/video_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/pages/upload/upload_screen.dart';
import 'screens/video_player_screen.dart';
import 'screens/image_viewer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (optional - can be removed if not using Supabase)
  try {
    await Supabase.initialize(
      url: 'https://jelziqsffylipgmxqecj.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplbHppcXNmZnlsaXBnbXhxZWNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk0NzE0ODAsImV4cCI6MjA2NTA0NzQ4MH0.Y0YFWQOmmhG_JMSoETxQIDSZ2FVz_1KlQhWp3sVdgJY',
    );
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
      ],
      child: MaterialApp(
        title: 'TikTok Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AppInitializer(),
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/upload': (context) => const UploadScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/video_player':
              final video = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(video: video),
              );
            case '/image_viewer':
              final image = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ImageViewerScreen(image: image),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
          }
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check authentication status
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();
    
    // Load initial data
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    await videoProvider.loadCategories();
    
    // Navigate to appropriate screen
    if (mounted) {
      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'TikTok Clone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}