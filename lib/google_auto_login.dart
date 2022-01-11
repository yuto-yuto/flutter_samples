import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as http;

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = new http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    // try {
    return _client.send(request);
    // } catch (e) {
    //   print(e);
    // }
  }
}

class GoogleAutoLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

final tokenProvider = StateProvider<String?>((ref) => null);
final apiProvider = StateProvider<DriveApi?>((ref) {
  final token = ref.watch(tokenProvider);
  if (token == null) {
    return null;
  }

  final headers = {"Authorization": "Bearer $token"};
  return DriveApi(_GoogleAuthClient(headers));
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Don't add await keyword
    _onAuthStateChange(context, ref);
    return const Scaffold(
      body: Center(child: Text("your splash screen")),
    );
  }

  Future<void> _onAuthStateChange(BuildContext context, WidgetRef ref) async {
    _autoLogin(ref);

    Future.delayed(Duration(seconds: 1), () {
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        try {
          if (user == null) {
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (context) => _LoginPage(),
              ),
            );
            return;
          }

          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (context) => _Home(),
            ),
          );
        } catch (e) {
          print(e);
        }
      });
    });
  }
}

final _google = GoogleSignIn.standard(scopes: [
  DriveApi.driveAppdataScope,
  DriveApi.driveFileScope,
]);

class _Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBar = AppBar(
      title: Text("Home"),
      actions: [
        TextButton(
          onPressed: () async {
            await _google.signOut();
            await FirebaseAuth.instance.signOut();
          },
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<List<File>?>(
        future: _fetchList(ref),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return Center(child: CircularProgressIndicator());
          }

          if (data.isEmpty) {
            return Center(child: Text("No data found"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${data[index].name}"),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<File>> _fetchList(WidgetRef ref) async {
    final api = ref.watch(apiProvider.state).state;
    if (api == null) {
      return [];
    }

    try {
      final fileList = await api.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(name)',
      );
      return fileList.files ?? [];
    } on DetailedApiRequestError catch (e) {
      print(e);
      if (e.status == 401 && e.message == "Invalid Credentials") {
        final googleUser = await _google.signInSilently();
        if (googleUser == null) {
          return [];
        }
        _afterLoginProcess(ref, googleUser);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}

class _LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _autoLogin(ref);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _login(ref);
                // not necessary to put nagivator here
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(WidgetRef ref) async {
    final googleUser = await _google.signIn();

    if (googleUser == null) {
      return;
    }

    try {
      _afterLoginProcess(ref, googleUser);
    } catch (e) {
      print(e);
    }
  }
}

Future<void> _autoLogin(WidgetRef ref) async {
  final googleUser = await _google.signInSilently(reAuthenticate: true);
  if (googleUser == null) {
    return;
  }
  _afterLoginProcess(ref, googleUser);
}

Future<void> _afterLoginProcess(
  WidgetRef ref,
  GoogleSignInAccount googleUser,
) async {
  final googleAuth = await googleUser.authentication;
  ref.read(tokenProvider.state).state = googleAuth.accessToken;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final UserCredential loginUser =
      await FirebaseAuth.instance.signInWithCredential(credential);
  assert(loginUser.user?.uid == FirebaseAuth.instance.currentUser?.uid);
}
