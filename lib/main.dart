import 'package:covid19india/features/home/presentation/bloc/page_bloc.dart';
import 'package:covid19india/features/home/presentation/pages/home_page.dart';
import 'package:covid19india/features/states/presentation/bloc/page_bloc.dart';
import 'package:covid19india/features/states/presentation/pages/state_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  var appDir = await getApplicationDocumentsDirectory();
  var path = appDir.path;
  Hive.init(path);

  await Hive.openBox('states');
  await Hive.openBox('districts');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'COVID19 INDIA',
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
            accentColor: Colors.white),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: BlocProvider<HomePageBloc>(
          create: (_) => HomePageBloc(),
          child: HomePage(),
        ),
        onGenerateRoute: (settings) {
          if (settings.name == StatePage.routeName) {
            final StatePageArguments args = settings.arguments;

            return MaterialPageRoute(
              builder: (context) {
                return BlocProvider<StatePageBloc>(
                  create: (_) => StatePageBloc(region: args.region),
                  child: StatePage(),
                );
              },
            );
          }

          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}
