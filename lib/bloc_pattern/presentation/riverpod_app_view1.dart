import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_samples/bloc_pattern/search/search_bloc.dart';
import 'package:flutter_samples/bloc_pattern/search/search_event.dart';
import 'package:flutter_samples/bloc_pattern/search/search_state.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_cubit.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_riverpod_notifier.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';
import 'package:flutter_samples/bloc_pattern/riverpod_definitions.dart';
import 'package:flutter_samples/custom_widgets/labeled_divider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodAppView1 extends ConsumerWidget {
  final String title;
  final Color color;
  RiverpodAppView1({Key? key, required this.title, required this.color}) : super(key: key);

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color,
          title: Text("Riverpod pattern test: ${title}"),
        ),
        body: Column(
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
            // LabeledDivider("Input Search Query"),
            // generateSearchBox(),
          ],
        ),
      ),
    );
  }

  // Widget generateSearchBox() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       SizedBox(
  //         child: TextField(
  //           controller: _textController,
  //         ),
  //         width: 100,
  //         height: 50,
  //       ),
  //       Container(
  //         child: BlocBuilder<SearchBloc, SearchState>(
  //           builder: (context, state) {
  //             if (state is SearchStateEmpty) {
  //               return SizedBox.shrink();
  //             }
  //             if (state is SearchStateInProgress) {
  //               if (state.cache == null) {
  //                 return SizedBox.shrink();
  //               } else {
  //                 return Text(state.cache.toString());
  //               }
  //             }
  //             if (state is SearchStateCompleted) {
  //               return Text(state.data.toString());
  //             }
  //             if (state is SearchStateError) {
  //               return Text(state.error);
  //             }
  //             return Text("input your query");
  //           },
  //         ),
  //         height: 100,
  //         width: 200,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.black, width: 1),
  //         ),
  //       ),
  //       Container(
  //         child: BlocBuilder<SearchBloc, SearchState>(
  //           builder: (context, state) => Text(state.toString()),
  //         ),
  //         height: 100,
  //         width: 200,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.black, width: 1),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
        generateResultDisplayArea(ref, notifierProvider),
      ],
    );
  }

  Widget generateResultDisplayArea(
      WidgetRef ref, StateNotifierProvider<SiteDataRiverpodNotifier, SiteDataState> notifierProvider) {
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
