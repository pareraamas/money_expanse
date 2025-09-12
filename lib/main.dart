import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "Money Expense",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      theme: ThemeData(
        textTheme: GoogleFonts.sourceSans3TextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary, // warna utama
        ),
        useMaterial3: true,
      ),
      locale: const Locale('id', 'ID'), // 🇮🇩 Set locale ke Indonesia
      supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      getPages: AppPages.routes,
    ),
  );
}
