import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/dialog.dart';
import 'package:flutter_samples/drawer.dart';
import 'package:flutter_samples/dropdown_sample.dart';
import 'package:flutter_samples/dynamic_text_field.dart';
import 'package:flutter_samples/ScaffoldFooterView.dart';
import 'package:flutter_samples/draggable_sample.dart';
import 'package:flutter_samples/google_drive.dart';
import 'package:flutter_samples/grouped_expansion_tile_sample.dart';
import 'package:flutter_samples/loading_next.dart';
import 'package:flutter_samples/page_transition.dart';
import 'package:flutter_samples/provider_sample.dart';
import 'package:flutter_samples/riverpod/dynamic_textfield_with_riverpod.dart';
import 'package:flutter_samples/riverpod/multi_providers.dart';
import 'package:flutter_samples/riverpod/riverpod-with-visibility.dart';
import 'package:flutter_samples/riverpod/riverpod_with_list.dart';
import 'package:flutter_samples/scrollable_draggable.dart';
import 'package:flutter_samples/swipe_list_item.dart';
import 'package:flutter_samples/tabbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: "App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
        initialRoute: "/home",
        routes: {
          "/home": (context) => MyApp(),
          "/transition": (context) => PageTransition(),
        },
        onGenerateRoute: generateRoute,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _createButton(Widget view) {
      return TextButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => view),
          );
        },
        child: Text(
          view.toString(),
          textScaleFactor: 1.5,
        ),
      );
    }

    final listView = ListView(
      children: [
        _createButton(ScaffoldFooterView()),
        _createButton(DynamicTextFieldView()),
        _createButton(GroupedExpansionTileSample()),
        _createButton(DraggableSample()),
        _createButton(ProviderSample()),
        _createButton(ScrollableDraggable()),
        _createButton(RiverpodWithList()),
        _createButton(RiverpodWithVisibility()),
        _createButton(DynamicTextFieldWithRiverpod()),
        _createButton(MultiProviders()),
        _createButton(DialogSample()),
        _createButton(DropdownSample()),
        _createButton(DrawerSample()),
        _createButton(PageTransition()),
        _createButton(LoadingNext()),
        _createButton(SwipeListItem()),
        _createButton(GoogleDriveTest()),
        _createButton(MyTabbar()),
      ],
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Samples"),
        ),
        body: listView,
      ),
    );
  }
}
