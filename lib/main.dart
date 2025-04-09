import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magic_epaper_app/providers/screen_size_provider.dart';
import 'package:magic_epaper_app/screens/home_screen.dart';
import 'package:magic_epaper_app/theme/text_util.dart';

import 'package:magic_epaper_app/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Lato", "Montserrat");
    MaterialTheme theme = MaterialTheme(textTheme);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => DisplaySizeProvider())
          ],
          child: MaterialApp(
            theme: theme.light(),
            darkTheme: theme.dark(),
            themeMode: ThemeMode.system,
            home: const HomeScreen(),
          ),
        ));
  }
}
