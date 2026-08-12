import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'helper/hive_service.dart';
import 'route_config/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables before anything else
  await dotenv.load(fileName: ".env");

  // Initialize Hive session box
  await HiveService.init();

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Initialize Cloudinary
  Cloudinary.fromStringUrl(
    'cloudinary://${dotenv.env['CLOUDINARY_API_KEY']}:${dotenv.env['CLOUDINARY_API_SECRET']}@${dotenv.env['CLOUDINARY_CLOUD_NAME']}',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UniBiz',
      routerConfig: _appRouter.config(),
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
