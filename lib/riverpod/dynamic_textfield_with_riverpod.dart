import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicTextFieldWithRiverpod extends StatelessWidget {
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

class _View1 extends ConsumerWidget {
  final _provider =
      Provider.autoDispose<List<TextEditingController>>((ref) => []);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final button = Center(
      child: IconButton(
        onPressed: () {
          ref.read(_provider).add(TextEditingController());
        },
        icon: Icon(Icons.add),
      ),
    );

    final listView = ListView.builder(
      itemCount: ref.watch(_provider).length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: IconButton(
            onPressed: () {
              final list = ref.read(_provider);
              list.remove(list[index]);
            },
            icon: Icon(Icons.remove_from_queue),
          ),
          title: TextField(
            controller: ref.watch(_provider)[index],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "name ${ref.watch(_provider).length + 1}",
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("Dynamic TextField Riverpod")),
      body: Column(
        children: [
          button,
          Expanded(child: listView),
        ],
      ),
    );
  }
}

// =============================================

class ControllerList extends StateNotifier<List<TextEditingController>> {
  final List<TextEditingController> _disposedList = [];
  ControllerList({String? text}) : super([TextEditingController(text: text)]);

  @override
  void dispose() {
    super.dispose();
    print("DISPOSE===========");
    for (final target in _disposedList) {
      target.dispose();
    }
  }

  void add({String? text}) {
    state = [...state, TextEditingController(text: text)];
  }

  void remove(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    final target = state[index];
    _disposedList.add(target);
    state.remove(target);
    state = [...state];
  }
}

final _controllerListProvider = StateNotifierProvider.autoDispose<
    ControllerList, List<TextEditingController>>((ref) => ControllerList());

class _View2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final button = Center(
      child: IconButton(
        onPressed: () {
          ref.read(_controllerListProvider.notifier).add();
        },
        icon: Icon(Icons.add),
      ),
    );

    final list = ref.watch(_controllerListProvider);
    final listView = ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final controller = list[index];
        print("$index: ${controller.text}");
        return ListTile(
          leading: IconButton(
            onPressed: () {
              ref.read(_controllerListProvider.notifier).remove(index);
            },
            icon: Icon(Icons.remove_from_queue),
          ),
          title: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "name $index / ${list.length}",
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("Dynamic TextField Riverpod2")),
      body: Column(
        children: [
          button,
          Expanded(child: listView),
        ],
      ),
    );
  }
}

// ===========================================

class ControllerList2
    extends StateNotifier<List<AutoDisposeProvider<TextEditingController>>> {
  ControllerList2({String? text}) : super([]);

  AutoDisposeProvider<TextEditingController> _createControllerProvider() {
    return Provider.autoDispose((ref) => TextEditingController());
  }

  void add() {
    state = [...state, _createControllerProvider()];
  }

  void remove(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    final target = state[index];
    state.remove(target);
    state = [...state];
  }
}

class _View3 extends ConsumerWidget {
  final _controllerList2Provider = StateNotifierProvider<ControllerList2,
          List<AutoDisposeProvider<TextEditingController>>>(
      (ref) => ControllerList2());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final button = Center(
      child: IconButton(
        onPressed: () {
          final list = ref.read(_controllerList2Provider.notifier);
          list.add();
        },
        icon: Icon(Icons.add),
      ),
    );

    final list = ref.watch(_controllerList2Provider);
    final listView = ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: IconButton(
            onPressed: () {
              ref.read(_controllerList2Provider.notifier).remove(index);
            },
            icon: Icon(Icons.remove_from_queue),
          ),
          title: TextField(
            controller: ref.watch(list[index]),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "name $index / ${list.length}",
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("Dynamic TextField Riverpod3")),
      body: Column(
        children: [
          button,
          Expanded(child: listView),
        ],
      ),
    );
  }
}
