import 'package:doctor_gen_app/pages/chat_with_bot_page.dart';
import 'package:doctor_gen_app/pages/edit_profile_page.dart';
import 'package:doctor_gen_app/pages/speak_to_bot_page.dart';
import 'package:doctor_gen_app/pages/tips_page.dart';
import 'package:doctor_gen_app/pages/profile_page.dart';
import 'package:doctor_gen_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:doctor_gen_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:doctor_gen_app/consts.dart';

void main() {
  // const apiKey = API_KEY;

  // Gemini.init(apiKey: apiKey, enableDebugging: true);

  // Gemini.instance
  //     .prompt(parts: [Part.text('Write a story about a magic backpack')])
  //     .then((value) {
  //       print(value?.output);
  //     });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoctorGen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(137, 217, 242, 1),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: const Color(0xff232729),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)),
          ),
        ),

        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xff2c3234),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // Dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(137, 217, 242, 1),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: const Color(0xff2c3234),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 2, color: Color(0xff343b3d)),
          ),
        ),

        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xff2c3234),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,

      //home: const HomePage(),
      initialRoute: '/home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => const HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/chat': (context) => const ChatWithBotPage(),
        '/talk': (context) => const SpeakToBotPage(),
        '/tips': (context) => const TipsPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
