import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/show_dialog.dart';

class MyData {
  final int uid;
  final String name;
  MyData({
    required this.uid,
    required this.name,
  });
}

class _Params {
  final MyData data;
  final TextEditingController controller;

  _Params({
    required this.data,
    required this.controller,
  });

  void dispose() {
    controller.dispose();
    print("Data for uid ${data.uid} was disposed");
  }
}

Future<List<MyData>> _fetchFromDatabase() => Future.value([0, 1, 2, 3, 4]).then(
    (value) => value.map((e) => MyData(uid: e, name: "name $e")).toList());

class _ParamsListNotifier extends StateNotifier<AsyncValue<List<_Params>>> {
  _ParamsListNotifier() : super(const AsyncValue.loading()) {
    _fetch();
  }
  _ParamsListNotifier.create(List<_Params> state)
      : super(AsyncValue.data(state));

  @override
  void dispose() {
    state.whenData((value) {
      for (final data in value) {
        data.dispose();
      }
    });
    super.dispose();
  }

  Future<void> _fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = await _fetchFromDatabase();
      return data.map((e) {
        return _Params(
          data: e,
          controller: TextEditingController(text: e.name),
        );
      }).toList();
    });
  }
}

class MultiProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: [
          _View1(),
          _View2(),
          _View3(),
        ],
      ),
    );
  }
}

final _futureProvider = FutureProvider.autoDispose<List<_Params>>((ref) async {
  final value = await ref.watch(_provider1.future);
  final list = value.map((e) {
    return _Params(
      data: e,
      controller: TextEditingController(text: e.name),
    );
  }).toList();

  return list;
});

final _provider2 = StateNotifierProvider.autoDispose<_ParamsListNotifier,
    AsyncValue<List<_Params>>>((ref) {
  print("_provider2 was triggered");
  return _ParamsListNotifier();
});

final _stateProvider = StateProvider((ref) => false);

Widget _createEditButton(BuildContext context) {
  return IconButton(
    onPressed: () => context.read(_stateProvider).state =
        !context.read(_stateProvider).state,
    icon: Icon(Icons.edit),
  );
}

class _View1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final button = _createEditButton(context);

    // final listView = watch(_futureProvider).maybeWhen(
    final listView = watch(_provider2).maybeWhen(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => TextField(
            controller: data
                .firstWhere((element) => element.data.uid == index)
                .controller,
            enabled: watch(_stateProvider).state,
          ),
        );
      },
      orElse: () => Center(
        child: Text("Loading"),
      ),
    );

    final footer = Row(
      children: [
        TextButton(
          onPressed: () async {
            context.read(_provider2).whenData((list) {
              for (final element in list) {
                element.controller.text = element.data.name;
              }
            });
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            context.read(_provider2).whenData((list) async {
              String msg = "";
              for (final element in list) {
                msg += "${element.data.name} => ${element.controller.text}\n";
              }
              await showMessage(context, msg, "Result");
            });
          },
          child: const Text("OK"),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Multi Providers")),
      body: Column(
        children: [
          button,
          Expanded(child: listView),
        ],
      ),
      persistentFooterButtons: [
        Visibility(
          child: footer,
          visible: context.read(_stateProvider).state,
        ),
      ],
    );
  }
}

// ================================
// BAD Example

final _provider1 = FutureProvider<List<MyData>>((ref) => _fetchFromDatabase());
final _futureProvider2 =
    FutureProvider.autoDispose<_ParamsListNotifier>((ref) async {
  print("_futureProvider2 was triggered");
  final value = await ref.watch(_provider1.future);
  final list = value.map((e) {
    return _Params(
      data: e,
      controller: TextEditingController(text: e.name),
    );
  }).toList();

  return _ParamsListNotifier.create(list);
});

class _View2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final button = _createEditButton(context);

    final listView = watch(_futureProvider2).maybeWhen(
      data: (data) {
        return data.state.maybeWhen(
          data: (inState) {
            return ListView.builder(
              itemCount: inState.length,
              itemBuilder: (context, index) => TextField(
                controller: inState
                    .firstWhere((element) => element.data.uid == index)
                    .controller,
                enabled: watch(_stateProvider).state,
              ),
            );
          },
          orElse: () => Center(
            child: Text("Loading2"),
          ),
        );
      },
      orElse: () => Center(
        child: Text("Loading"),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Multi Providers2")),
      body: Column(
        children: [
          button,
          Expanded(child: listView),
        ],
      ),
      persistentFooterButtons: [
        Visibility(
          child: Center(child: Text("FOOTER")),
          visible: context.read(_stateProvider).state,
        ),
      ],
    );
  }
}

// ================================

final _dataProvider =
    FutureProvider<List<MyData>>((ref) => _fetchFromDatabase());
final _controllersProvider =
    StateProvider.autoDispose<Map<int, TextEditingController>>((ref) {
  return ref.watch(_dataProvider).maybeWhen(
        data: (list) {
          final Map<int, TextEditingController> controllers = {};
          for (final data in list) {
            controllers[data.uid] = TextEditingController(text: data.name);
          }
          return controllers;
        },
        orElse: () => {},
      );
});
final _controllerProvider =
    StateProvider.autoDispose.family<TextEditingController?, int>((ref, uid) {
  final controllers = ref.watch(_controllersProvider).state;
  ref.onDispose(() => print("controller for uid $uid was disposed"));
  return controllers[uid];
});

class _View3 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final button = _createEditButton(context);

    final listView = watch(_dataProvider).maybeWhen(
      data: (list) {
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final myData = list[index];
            final controller = watch(_controllerProvider(myData.uid)).state;
            return TextField(
              controller: controller,
              enabled: watch(_stateProvider).state,
            );
          },
        );
      },
      orElse: () => Center(
        child: Text("Loading3"),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Multi Providers3")),
      body: Column(
        children: [
          button,
          Expanded(child: listView),
        ],
      ),
      persistentFooterButtons: [
        Visibility(
          child: Center(child: Text("FOOTER")),
          visible: context.read(_stateProvider).state,
        ),
      ],
    );
  }
}
