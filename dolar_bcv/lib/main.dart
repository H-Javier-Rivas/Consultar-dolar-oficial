import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/local/cache_manager.dart';
import 'data/services/exchange_rate_service.dart';
import 'data/services/network_service.dart';

import 'viewmodels/converter_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';

import 'ui/screens/home_screen.dart';
import 'ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  await dotenv.load(fileName: "assets/.env");

  // Inicializar localización para fechas
  await initializeDateFormatting('es', null);

  // Inyección de dependencias manual básica
  final networkService = NetworkService();
  final exchangeRateService = ExchangeRateService(networkService);
  final cacheManager = CacheManager();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel(cacheManager)),
        ChangeNotifierProvider(create: (_) => ConverterViewModel(exchangeRateService, cacheManager)),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        ChangeNotifierProvider(create: (_) => TodoViewModel()),
      ],
      child: const DolarBcvApp(),
    ),
  );
}

class DolarBcvApp extends StatelessWidget {
  const DolarBcvApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);
    
    // Configurar dimensión base Mobile-First
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13/14 size reference
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Dolar BVC Premium',
          debugShowCheckedModeBanner: false,
          themeMode: themeVM.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppTheme.primary,
            scaffoldBackgroundColor: AppTheme.bgMainLight,
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              secondary: AppTheme.secondary,
              surface: AppTheme.bgCardLight,
              error: AppTheme.error,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppTheme.primary,
            scaffoldBackgroundColor: AppTheme.bgMain,
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              secondary: AppTheme.secondary,
              surface: AppTheme.bgCard,
              error: AppTheme.error,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
