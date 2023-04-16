import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samples/bloc_pattern/presentation/riverpod_app_view1.dart';
import 'package:flutter_samples/bloc_pattern/presentation/riverpod_app_view2.dart';
import 'package:flutter_samples/main.dart';

class RiverpodPattern extends StatelessWidget {
  const RiverpodPattern({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return MaterialPageRoute(
                builder: (_) => RiverpodAppView1(title: "first", color: Colors.pink),
              );
            case "/second":
              return MaterialPageRoute(
                builder: (_) => RiverpodAppView2(title: "second", color: Colors.red),
              );
            case "/home":
              return MaterialPageRoute(builder: (_) => MyApp());
            default:
              return null;
          }
        },
      ),
    );
  }
}
