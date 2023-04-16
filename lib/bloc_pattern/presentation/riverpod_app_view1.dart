import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_samples/bloc_pattern/search/search_state.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_riverpod_notifier.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';
import 'package:flutter_samples/bloc_pattern/riverpod_definitions.dart';
import 'package:flutter_samples/custom_widgets/labeled_divider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiverpodAppView1 extends HookConsumerWidget {
  final String title;
  final Color color;
  RiverpodAppView1({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color,
          title: Text("Riverpod pattern test: ${title}"),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/home'),
                    child: Text("Go to Home"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/second'),
                    child: Text("Go to Second"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                  ),
                ],
              ),
              LabeledDivider("technicalfeeder.com"),
              generateRow(ref, tfSiteDataStateNotifierProvider, "technicalfeeder.json"),
              LabeledDivider("example.com"),
              generateRow(ref, unknownSiteDataStateNotifierProvider, "unknown.json"),
              LabeledDivider("Input Search Query (Controller.addListener)"),
              generateSearchBox1(ref),
              LabeledDivider("Input Search Query (onChanged)"),
              generateSearchBox2(ref),
              LabeledDivider("Input Search Query (Controller.addListener2)"),
              generateSearchBox3(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateSearchBox1(WidgetRef ref) {
    final queryController = useTextEditingController();
    useEffect(() {
      final searchApi = ref.read(searchProvider1.notifier);
      queryController.addListener(() => searchApi.debouncedSearch(queryController.text));
      // return queryController.dispose;
    });
    final textField = TextField(controller: queryController);

    return generateSearchBox(ref, textField, searchProvider1);
  }

  Widget generateSearchBox2(WidgetRef ref) {
    final textField = TextField(
      onChanged: (value) {
        print("onChanged");
        final searchApi = ref.read(searchProvider2.notifier);
        searchApi.debouncedSearch(value);
      },
    );
    return generateSearchBox(ref, textField, searchProvider2);
  }

  Widget generateSearchBox3(WidgetRef ref) {
    final queryController = ref.watch(queryControllerProvider);
    final textField = TextField(controller: queryController);
    return generateSearchBox(ref, textField, searchProvider3);
  }

  Widget generateSearchBox(WidgetRef ref, Widget textField, SearchProvider searchProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: textField,
          width: 100,
          height: 50,
        ),
        Container(
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(searchProvider);
              if (state is SearchStateEmpty) {
                return SizedBox.shrink();
              }
              if (state is SearchStateInProgress) {
                if (state.cache == null) {
                  return SizedBox.shrink();
                } else {
                  return Text(state.cache.toString());
                }
              }
              if (state is SearchStateCompleted) {
                return Text(state.data.toString());
              }
              if (state is SearchStateError) {
                return Text(state.error);
              }
              return Text("input your query");
            },
          ),
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
        ),
        Container(
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(searchProvider);
              return Text(state.toString());
            },
          ),
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
        ),
      ],
    );
  }

  Widget generateRow(
      WidgetRef ref, StateNotifierProvider<SiteDataRiverpodNotifier, SiteDataState> notifierProvider, String filename) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(notifierProvider.notifier).read(filename: filename);
          },
          child: Text("Successful Trigger"),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(notifierProvider.notifier).read(filename: filename, isFail: true);
          },
          child: Text("Failing Trigger"),
        ),
        generateResultDisplayArea(notifierProvider),
      ],
    );
  }

  Widget generateResultDisplayArea(StateNotifierProvider<SiteDataRiverpodNotifier, SiteDataState> notifierProvider) {
    return Container(
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(notifierProvider);
          switch (state.status) {
            case SiteDataStatus.initial:
              return SizedBox.shrink();
            case SiteDataStatus.failure:
              return Text("Failed to load");
            case SiteDataStatus.loading:
              return CircularProgressIndicator();
            case SiteDataStatus.success:
              return Text(state.siteData.toString());
            default:
              throw Exception("Unhandled SiteDataStatus: ${state.status}");
          }
        },
      ),
      height: 100,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
    );
  }
}
