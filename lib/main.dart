import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_split/ui/pages/group/open_group.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
// package files
import 'package:easy_split/bloc/theme/theme_bloc.dart';
import 'package:easy_split/ui/pages/home_page.dart';
import 'package:easy_split/ui/pages/login_page.dart';
import 'package:easy_split/bloc/Auth/auth_bloc.dart';
import 'package:easy_split/ui/pages/registration_page.dart';
import 'package:easy_split/ui/pages/group/create_group.dart';
import 'package:easy_split/ui/pages/group/groups_page.dart';

import 'theme/themes.dart';
import 'ui/elements/app_bar.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(CheckAuthStatus())),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => firstPage(context)),
          GoRoute(
            path: '/home',
            builder: (context, state) => HomePage(),
            routes: [
              GoRoute(
                path: 'add_group',
                builder: (context, state) => CreateGroupPage(),
              ),
            ],
          ),

          GoRoute(path: '/login', builder: (context, state) => LoginPage()),
          GoRoute(
            path: '/register',
            builder: (context, state) => RegistrationPage(),
          ),
          GoRoute(path: '/groups', builder: (context, state) => GroupsPage()),
          GoRoute(
            path: '/groups/:groupId',
            builder: (context, state) {
              final groupId = state.pathParameters['groupId'];
              return OpenGroup(groupId: groupId!);
            },
          ),
        ],
      ),
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Easy Split',
      theme: AppThemes.toThemeData(context.watch<ThemeBloc>().state.theme),
    );
  }
}

Widget firstPage(BuildContext bc) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      Widget page = LoginPage();
      if (state is AuthLoading) {
        page = Scaffold(
          appBar: myAppBar(title: "Easy Split"),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Authenticating...'),
              SizedBox(height: 20),
              Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      } else if (state is AuthAuthenticated) {
        page = HomePage();
      } else if (state is AuthError) {
        if (state is! AuthInitial && state is! AuthUnauthenticated) {
          page = LoginPage(errormessage: state.message);
        }
      } else if (state is NewUserState) {
        page = RegistrationPage();
      }
      return page;
    },
  );
}
