import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/apply_text_style.dart';
import 'package:flutter_samples/cross_axis_scroll.dart';
import 'package:flutter_samples/date_time_picker.dart';
import 'package:flutter_samples/dialog.dart';
import 'package:flutter_samples/drawer.dart';
import 'package:flutter_samples/dropdown_sample.dart';
import 'package:flutter_samples/dynamic_text_field.dart';
import 'package:flutter_samples/ScaffoldFooterView.dart';
import 'package:flutter_samples/draggable_sample.dart';
import 'package:flutter_samples/get_widget_info.dart';
import 'package:flutter_samples/google_auto_login.dart';
import 'package:flutter_samples/google_drive.dart';
import 'package:flutter_samples/google_drive_search.dart';
import 'package:flutter_samples/graph.dart';
import 'package:flutter_samples/grouped_expansion_tile_sample.dart';
import 'package:flutter_samples/loading_next.dart';
import 'package:flutter_samples/page_transition.dart';
import 'package:flutter_samples/provider_sample.dart';
import 'package:flutter_samples/riverpod/dynamic_textfield_with_riverpod.dart';
import 'package:flutter_samples/riverpod/multi_providers.dart';
import 'package:flutter_samples/riverpod/riverpod-with-visibility.dart';
import 'package:flutter_samples/riverpod/riverpod_with_list.dart';
import 'package:flutter_samples/row_double_tap.dart';
import 'package:flutter_samples/scrollable_draggable.dart';
import 'package:flutter_samples/specify_area_on_slider.dart';
import 'package:flutter_samples/swipe_list_item.dart';
import 'package:flutter_samples/tabbar.dart';
import 'package:flutter_samples/table_column_resize.dart';
import 'package:flutter_samples/time_input_by_textfield.dart';
import 'package:flutter_samples/time_of_day.dart';
import 'package:flutter_samples/key_detection_on_table.dart';
import 'package:flutter_samples/select_row_with_shift_key.dart';
import 'package:flutter_samples/bloc_pattern/main.dart';
import 'package:flutter_samples/bloc_pattern/riverpod_main.dart';
import 'package:flutter_samples/toggle_sample.dart';

final navigatorKey = new GlobalKey<NavigatorState>();

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
        navigatorKey: navigatorKey,
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

    final viewList = [
      ScaffoldFooterView(),
      DynamicTextFieldView(),
      GroupedExpansionTileSample(),
      DraggableSample(),
      ProviderSample(),
      ScrollableDraggable(),
      RiverpodWithList(),
      RiverpodWithVisibility(),
      DynamicTextFieldWithRiverpod(),
      MultiProviders(),
      DialogSample(),
      DropdownSample(),
      DrawerSample(),
      PageTransition(),
      LoadingNext(),
      SwipeListItem(),
      GoogleDriveTest(),
      GoogleDriveSearch(),
      GoogleAutoLogin(),
      MyTabbar(),
      CrossAxisScroll(),
      Graph(),
      ApplyTextStyle(),
      TimeOfDaySample(),
      DateTimePicker(),
      RowDoubleTap(),
      TableColumnResize(),
      SpecifyAreaOnSlider(),
      GetWidgetInfo(),
      KeyDetectionOnTable(),
      SelectRowWithShiftKey(),
      BlocPattern(),
      RiverpodPattern(),
      ToggleSample(),
      TimeInputByTextField(),
    ];
    viewList.sort((a, b) => a.runtimeType.toString().compareTo(b.runtimeType.toString()));
    final listView = ListView(children: viewList.map((e) => _createButton(e)).toList());

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
