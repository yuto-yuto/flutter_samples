import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageArguments {
  final String message;
  PageArguments(this.message);
}

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/transition1":
      return MaterialPageRoute(
          settings: settings, builder: (context) => TransitionFirstPage());
    case "/transition2":
      return MaterialPageRoute(
          settings: settings, builder: (context) => TransitionSecondPage());
    case "/transition3":
      return MaterialPageRoute(
          settings: settings, builder: (context) => TransitionThirdPage());
  }
}

class PageTransition extends StatefulWidget {
  @override
  _PageTransitionState createState() => _PageTransitionState();
}

class _PageTransitionState extends State<PageTransition> {
  String? text = "Initial state";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Page Transition sample"),
        ),
        body: Column(
          children: [
            Center(child: Text(text ?? "")),
            Center(child: _button1(context)),
            Center(child: _button2(context)),
          ],
        ),
      ),
    );
  }

  Widget _button1(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(
              name: "/transition1",
            ),
            builder: (context) => TransitionFirstPage(),
          ),
        );
        setState(() {
          text = result;
        });
      },
      child: Text("Go to First Page"),
    );
  }

  Widget _button2(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.pushNamed(
          context,
          "/transition3",
          arguments: PageArguments("Transition Top Page!!"),
        );
        setState(() {
          text = "----";
        });
      },
      child: Text("Go to Third Page by pushNamed"),
    );
  }
}

class TransitionFirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Page")),
      body: Column(
        children: [
          _button1(context),
          _button2(context),
          _button3(context),
        ],
      ),
    );
  }

  Widget _button1(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back"),
        onPressed: () {
          Navigator.pop(context, "From first page");
        },
      ),
    );
  }

  Widget _button2(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Go to second page by push"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransitionSecondPage(),
              settings: RouteSettings(arguments: "Data From first page"),
            ),
          );
        },
      ),
    );
  }

  Widget _button3(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Replace this page with second page"),
        onPressed: () async {
          final completer = Completer();
          final result = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TransitionSecondPage()),
            result: completer.future,
          );
          completer.complete(result);
        },
      ),
    );
  }
}

class TransitionSecondPage extends StatefulWidget {
  @override
  _TransitionSecondPageState createState() => _TransitionSecondPageState();
}

class _TransitionSecondPageState extends State<TransitionSecondPage> {
  String? text = "Initial state";
  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    if (settings == null || settings.arguments == null) {
      text = "No data received";
    } else {
      final data = settings.arguments;
      if (data is String) {
        text = data;
      } else {
        text = "unknown data type";
      }
    }
    return Scaffold(
        appBar: AppBar(title: Text("Second Page")),
        body: Column(
          children: [
            Center(child: Text(text ?? "")),
            _backButton(context),
            Divider(color: Colors.black),
            _backToTop1(context),
            _backToTop2(context),
            _backToTop3(context),
            Divider(color: Colors.black),
            _goToThird1(context),
            _goToThird2(context),
          ],
        ));
  }

  Widget _backButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back"),
        onPressed: () {
          Navigator.pop(context, "From second page");
        },
      ),
    );
  }

  Widget _backToTop1(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back to Top by pushNamed"),
        onPressed: () {
          Navigator.pushNamed(context, "/transition");
        },
      ),
    );
  }

  Widget _backToTop2(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back to Top by pushNamedAndRemoveUntil"),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/transition",
            (route) => route.isFirst,
          );
        },
      ),
    );
  }

  Widget _backToTop3(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back to Top by popAndPushNamed"),
        onPressed: () {
          Navigator.popAndPushNamed(context, "/transition");

          // not work
          // Navigator.popUntil(context, ModalRoute.withName("/transition"));
        },
      ),
    );
  }

  Widget _goToThird1(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Go to third page by push"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransitionThirdPage()),
          );
        },
      ),
    );
  }

  Widget _goToThird2(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Go to third page by pushNamed"),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/transition3",
            arguments: PageArguments("Message from Second Page!!!!!"),
          );
        },
      ),
    );
  }
}

class TransitionThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = _getText(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Page"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Center(child: Text(text)),
          _button1(context),
          _button2(context),
        ],
      ),
    );
  }

  String _getText(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    if (settings == null || settings.arguments == null) {
      return "by push";
    }
    final args = settings.arguments;
    if (args is PageArguments) {
      return args.message;
    }
    return "Unknown Argument";
  }

  Widget _button1(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back to home"),
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  Widget _button2(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Back to first page"),
        onPressed: () {
          // it shows black screen when the route doesn't exist on the stack
          Navigator.popUntil(context, ModalRoute.withName("/transition1"));
        },
      ),
    );
  }
}
