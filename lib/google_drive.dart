import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samples/show_dialog.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GoogleDriveTest extends StatefulWidget {
  @override
  _GoogleDriveTest createState() => _GoogleDriveTest();
}

class _GoogleDriveTest extends State<GoogleDriveTest> {
  bool _loginStatus = false;
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  @override
  void initState() {
    _loginStatus = googleSignIn.currentUser != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Google Drive Test"),
        ),
        body: _createBody(context),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    final signIn = ElevatedButton(
      onPressed: () {
        _signIn();
      },
      child: Text("Sing in"),
    );
    final signOut = ElevatedButton(
      onPressed: () {
        _signOut();
      },
      child: Text("Sing out"),
    );
    final uploadToHidden = ElevatedButton(
      onPressed: () {
        _uploadToHidden();
      },
      child: Text("Upload to app folder (hidden)"),
    );
    final uploadToNormal = ElevatedButton(
      onPressed: () {
        _uploadToNormal();
      },
      child: Text("Upload to normal folder"),
    );
    final showList = ElevatedButton(
      onPressed: () {
        _showList();
      },
      child: Text("Show the data list"),
    );

    return Column(
      children: [
        Center(child: Text("Sign in status: ${_loginStatus ? "In" : "Out"}")),
        Center(child: signIn),
        Center(child: signOut),
        Divider(),
        Center(child: uploadToHidden),
        Center(child: uploadToNormal),
        Center(child: showList),
      ],
    );
  }

  Future<void> _signIn() async {
    final googleUser = await googleSignIn.signIn();

    try {
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential loginUser =
            await FirebaseAuth.instance.signInWithCredential(credential);

        assert(loginUser.user?.uid == FirebaseAuth.instance.currentUser?.uid);
        print("Sign in");
        setState(() {
          _loginStatus = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    setState(() {
      _loginStatus = false;
    });
    print("Sign out");
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      await showMessage(context, "Sign-in first", "Error");
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<void> _uploadToHidden() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      // Not allow a user to do something else
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(seconds: 2),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      // Create data here instead of loading a file
      final contents = "Technical Feeder";
      final Stream<List<int>> mediaStream =
          Future.value(contents.codeUnits).asStream().asBroadcastStream();
      var media = new drive.Media(mediaStream, contents.length);

      // Set up File info
      var driveFile = new drive.File();
      final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      driveFile.name = "technical-feeder-$timestamp.txt";
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = ["appDataFolder"];

      // Upload
      final response =
          await driveApi.files.create(driveFile, uploadMedia: media);
      print("response: $response");

      // simulate a slow process
      await Future.delayed(Duration(seconds: 2));
    } finally {
      // Remove a dialog
      Navigator.pop(context);
    }
  }

  Future<String?> _getFolderId(drive.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "Flutter-sample-by-tf";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        await showMessage(context, "Sign-in first", "Error");
        return null;
      }

      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = new drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      // I/flutter ( 6132): DetailedApiRequestError(status: 403, message: The granted scopes do not give access to all of the requested spaces.)
      return null;
    }
  }

  Future<void> _uploadToNormal() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      // Not allow a user to do something else
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(seconds: 2),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      final folderId = await _getFolderId(driveApi);
      if (folderId == null) {
        await showMessage(context, "Failure", "Error");
        return;
      }

      // Create data here instead of loading a file
      final contents = "Technical Feeder";
      final Stream<List<int>> mediaStream =
          Future.value(contents.codeUnits).asStream().asBroadcastStream();
      var media = new drive.Media(mediaStream, contents.length);

      // Set up File info
      var driveFile = new drive.File();
      final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      driveFile.name = "technical-feeder-$timestamp.txt";
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [folderId];

      // Upload
      final response =
          await driveApi.files.create(driveFile, uploadMedia: media);
      print("response: $response");

      // simulate a slow process
      await Future.delayed(Duration(seconds: 2));
    } finally {
      // Remove a dialog
      Navigator.pop(context);
    }
  }

  Future<void> _showList() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, modifiedTime)',
    );
    final files = fileList.files;
    if (files == null) {
      return showMessage(context, "Data not found", "");
    }

    final alert = AlertDialog(
      title: Text("Item List"),
      content: SingleChildScrollView(
        child: ListBody(
          children: files.map((e) => Text(e.name ?? "no-name")).toList(),
        ),
      ),
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = new http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
