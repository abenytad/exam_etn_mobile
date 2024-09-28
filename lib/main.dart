import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:pics/src/screens/change_password_screen.dart';
import 'package:pics/src/screens/edit_profile_screen.dart';
import 'package:pics/src/screens/login_screen.dart';
import 'package:pics/src/screens/materials_screen.dart';
import 'package:pics/src/screens/profile_screen.dart';
import 'package:pics/src/screens/program_details_screen.dart';
import 'package:pics/src/screens/result_screen.dart';
import 'package:pics/src/screens/signup_screen.dart';
import './src/screens/home_screen.dart';
import './src/blocs/programs_provider.dart';
import './src/screens/courses_screen.dart';
import './src/screens/pdf_vscreen.dart';
import './src/screens/exam_screec.dart';
import './src/screens/video_player_screen.dart';
import './src/blocs/exam_provider.dart';
import './src/blocs/auth_provider.dart';
import './src/services/shared_data.dart';
import './src/blocs/profile_provider.dart';
import './src/screens/edit_profile_screen.dart';
import './src/blocs/chatbot_provider.dart';
import './src/screens/chatbot_screen.dart';
import './src/screens/answers_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _preventScreenshot();
  }

  Future<void> _preventScreenshot() async {
    // This flag prevents screenshots and screen recording
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child: ProgramsProvider(
        child: ExamProvider(
          child: ProfileProvider(
            child: ChatbotProvider(
              child: MaterialApp(
                title: 'EXAM ETN',
                theme: ThemeData(
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: Color.fromARGB(255, 0, 116, 169), // Primary color
                    onPrimary:
                        Colors.white, // Color for text/icons on primary color
                    secondary:
                        Color.fromARGB(255, 88, 99, 99), // Secondary color
                    onSecondary:
                        Colors.white, // Color for text/icons on secondary color
                    background: Colors.white, // Background color
                    onBackground: Colors
                        .black, // Color for text/icons on background color
                    surface: Colors.white, // Surface color
                    onSurface:
                        Colors.black, // Color for text/icons on surface color
                    error: Colors.red, // Error color
                    onError:
                        Colors.white, // Color for text/icons on error color
                  ),
                  appBarTheme: AppBarTheme(
                    foregroundColor:
                        Colors.blueGrey[900], // Text color for AppBar
                  ),
                  useMaterial3: true,
                ),
                debugShowCheckedModeBanner: false,
                home: AuthenticationWrapper(), // Use the AuthenticationWrapper
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove the flag when the widget is disposed
    // FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthentication(), // Check authentication status
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
                child:
                    CircularProgressIndicator()), // Show a loading indicator while waiting
          );
        }

        if (snapshot.hasError) {
          // Handle error state if needed
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final isAuthenticated = snapshot.data ?? false;

        return MaterialApp(
          title: 'EXAM ETN',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color.fromARGB(255, 4, 112, 151), // Primary color
              onPrimary: const Color.fromARGB(
                  255, 255, 255, 255), // Color for text/icons on primary color
              secondary: Color.fromARGB(255, 192, 219, 217), // Secondary color
              onSecondary:
                  Colors.white, // Color for text/icons on secondary color
              background: Colors.white, // Background color
              onBackground:
                  Colors.black, // Color for text/icons on background color
              surface: Colors.white, // Surface color
              onSurface: Colors.black, // Color for text/icons on surface color
              error: Colors.red, // Error color
              onError: Colors.white, // Color for text/icons on error color
            ),
            appBarTheme: AppBarTheme(
              foregroundColor: Colors.blueGrey[900], // Text color for AppBar
            ),
            useMaterial3: true,
          ),
          onGenerateRoute: (settings) {
            return _handleRoute(settings, isAuthenticated, context);
          },
        );
      },
    );
  }

  Future<bool> _checkAuthentication() async {
    final token = await PreferencesService.getToken();
    return token != null; // If token exists, user is authenticated
  }

  Route<dynamic> _handleRoute(
      RouteSettings settings, bool isAuthenticated, BuildContext context) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      default:
        if (!isAuthenticated &&
            !settings.name!.startsWith('/') &&
            !settings.name!.startsWith('/signup')) {
          return MaterialPageRoute(builder: (context) => LoginScreen());
        } else if (settings.name != null &&
            settings.name!.startsWith('/home')) {
          final bloc = ProgramsProvider.of(context);
          bloc.setEnrolledFalse();
          return MaterialPageRoute(builder: (context) {
            return HomeScreen();
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/profile')) {
          return MaterialPageRoute(builder: (context) {
            return ProfileScreen();
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/edit-profile')) {
          return MaterialPageRoute(builder: (context) {
            return EditProfileScreen();
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/course/')) {
          final name = settings.name;
          final programId = name!.replaceFirst('/course/', '');
          return MaterialPageRoute(builder: (context) {
            final coursesBloc = ProgramsProvider.of(context);
            coursesBloc.fetchCourses(programId);
            return CoursesScreen(programId: programId);
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/program/')) {
          final name = settings.name;
          final programId = name!.replaceFirst('/program/', '');
          return MaterialPageRoute(builder: (context) {
            final programsBloc = ProgramsProvider.of(context);
            programsBloc.fetchProgramDetails(programId);
            return ProgramDetailsScreen(programId: programId);
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/materials/')) {
          final name = settings.name;
          final courseId = name!.replaceFirst('/materials/', '');
          return MaterialPageRoute(builder: (context) {
            final materialsBloc = ProgramsProvider.of(context);
            materialsBloc.fetchMaterials(courseId);
            return MaterialsScreen(courseId: courseId);
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/pdf/')) {
          final name = settings.name;
          final materialUrl = name!.replaceFirst('/pdf/', '');
          return MaterialPageRoute(builder: (context) {
            return PDFScreen(url: materialUrl);
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/video/')) {
          final name = settings.name;
          final materialUrl = name!.replaceFirst('/video/', '');
          return MaterialPageRoute(builder: (context) {
            return VideoPlayerScreen(videoUrl: materialUrl);
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/mockExam/')) {
          final name = settings.name;
          final programId = name!.replaceFirst('/mockExam/', '');
          return MaterialPageRoute(builder: (context) {
            final examBloc = ExamProvider.of(context);
            examBloc.fetchExam(programId);
            return ExamScreen();
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/result/')) {
          final name = settings.name;
          final id = name!.replaceFirst('/result/', '');
          return MaterialPageRoute(builder: (context) {
            return ResultScreen(examId: id);
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/answers/')) {
          final name = settings.name;
          print(name);
          final examId = name!.replaceFirst('/answers/', '');
          return MaterialPageRoute(builder: (context) {
            final examBloc = ExamProvider.of(context);
            examBloc.fetchQuestions(examId);
            return AnswerScreen();
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/password')) {
          return MaterialPageRoute(builder: (context) {
            return ChangePasswordScreen();
          });
        } else if (settings.name != null &&
            settings.name!.startsWith('/chatbot')) {
          return MaterialPageRoute(builder: (context) {
            return ChatBotScreen();
          });
        } else {
          return MaterialPageRoute(builder: (context) => LoginScreen());
        }
    }
  }
}
