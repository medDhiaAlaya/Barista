import 'package:barista/firebase_options.dart';
import 'package:barista/presentation/home/bloc/home_bloc.dart';
import 'package:barista/presentation/home/home.dart';
import 'package:barista/presentation/on_boarding/on_boarding_screen.dart';
import 'package:barista/shared/network/local/cache_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await CacheHelper.init();
  bool? onBoarding = await CacheHelper.getData(key: 'onboarding');
  final Widget initialWidget;
  if (onBoarding == true) {
    initialWidget = const HomeScreen();
  } else {
    initialWidget = const OnBoardingScreen();
  }
  runApp(MyApp(initialWidget: initialWidget));
}

class MyApp extends StatelessWidget {
  final Widget initialWidget;
  const MyApp({super.key, required this.initialWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: initialWidget,
      ),
    );
  }
}
