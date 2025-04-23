import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://abjnclqznfxeccdjmwkg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiam5jbHF6bmZ4ZWNjZGptd2tnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MTEyNTIsImV4cCI6MjA2MDE4NzI1Mn0.8vAOC7Vb_-WLMd1dnqR9aWpAzCiZRI_zaVv-yWzr5Jc',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        // Background image
        background(),
        // Scrollable content
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logInHeader(context),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255,28,59,138).withOpacity(0.7),
                        Color.fromARGB(255, 69,121,190).withOpacity(0.7), 
                      ],                           
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      usernameField(),
                      SizedBox(height: 10),
                      passwordField(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Text(
                  _userId ?? 'Not signed in',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                signInButton(),
                if (_userId != null) // Show logout button only if the user is logged in
                  signOutButton(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Column passwordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30), // Add margin to align with TextField
        child: Text(
          "Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(height: 4),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}

Column usernameField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30), // Add margin to align with TextField
        child: Text(
          "AdDUNET Username",
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(height: 4),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}

Row logInHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.1,
        child: Placeholder(),
      ),
      Column(
        children: [
          Text("Ateneo"),
          Text("Events"),
        ],
      ),
    ],
  );
}

  Container background() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://abjnclqznfxeccdjmwkg.supabase.co/storage/v1/object/sign/assets/UniVentsLogInBG.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InN0b3JhZ2UtdXJsLXNpZ25pbmcta2V5XzkzMDBhOGRmLTJlZDctNDNlMi1hODYwLTU2YjRhZDg5YzcwYSJ9.eyJ1cmwiOiJhc3NldHMvVW5pVmVudHNMb2dJbkJHLmpwZWciLCJpYXQiOjE3NDUyMjM4NTksImV4cCI6MTc3Njc1OTg1OX0.pV-OE9spFmFYkC5In_8kBYaaP_KeMIiWmgcQqJHVxJk',
          ),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  ElevatedButton signInButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          const webClientId = '371734532339-4mv4nja0baj7539q8o26gdvhmagotunr.apps.googleusercontent.com';
          const iosClientId = '371734532339-av5a053e4sf1ik15t48kl608qko464qa.apps.googleusercontent.com';

          final GoogleSignIn googleSignIn = GoogleSignIn(
            clientId: iosClientId,
            serverClientId: webClientId,
          );
          final googleUser = await googleSignIn.signIn();
          if (googleUser == null) {
            print('Sign-in aborted by user.');
            return;
          }
          final googleAuth = await googleUser.authentication;
          final accessToken = googleAuth.accessToken;
          final idToken = googleAuth.idToken;

          if (accessToken == null || idToken == null) {
            throw 'Missing tokens';
          }

          await supabase.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );
        } catch (e) {
          print('Error during Google Sign-In: $e');
        }
      },
      child: Text("Sign in with Google"),
    );
  }

  ElevatedButton signOutButton() {
    return ElevatedButton(
      onPressed: () async {
      try {
        // Sign out from Supabase
        await supabase.auth.signOut();

        // Sign out from GoogleSignIn
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();

        // Clear the user ID
        setState(() {
          _userId = null;
        });
      } catch (e) {
        print('Error during logout: $e');
      }
    },
      child: Text("Logout"),
    );
  }
}