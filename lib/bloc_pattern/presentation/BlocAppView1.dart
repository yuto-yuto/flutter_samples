import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_samples/bloc_pattern/search/search_bloc.dart';
import 'package:flutter_samples/bloc_pattern/search/search_event.dart';
import 'package:flutter_samples/bloc_pattern/search/search_state.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_cubit.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';
import 'package:flutter_samples/custom_widgets/labeled_divider.dart';

class BlocAppView1 extends StatefulWidget {
  final String title;
  final Color color;
  const BlocAppView1({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  _BlocAppView1State createState() => _BlocAppView1State();
}

class _BlocAppView1State extends State<BlocAppView1> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      final searchBloc = context.read<SearchBloc>();
      searchBloc.add(SearchQueryEvent(query: _textController.text));
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Text("Bloc pattern test: ${widget.title}"),
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
            generateCubitSet<TechnicalFeederCubit>(),
            LabeledDivider("example.com"),
            generateCubitSet<UnknownSiteCubit>(),
            LabeledDivider("Input Search Query"),
            generateSearchBox(),
          ],
        ),
      ),
    );
  }

  Widget generateSearchBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: TextField(
            controller: _textController,
          ),
          width: 100,
          height: 50,
        ),
        Container(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
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
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) => Text(state.toString()),
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

  Widget generateCubitSet<T extends SiteDataCubit>() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Same as "BlocProvider.of<T>(context).read();"
            context.read<T>().read();
          },
          child: Text("Successful Trigger"),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<T>(context).read(isFail: true);
          },
          child: Text("Failing Trigger"),
        ),
        generateResultDisplayArea<T>(),
      ],
    );
  }

  Widget generateResultDisplayArea<T extends SiteDataCubit>() {
    return Container(
      child: BlocBuilder<T, SiteDataState>(
        builder: (context, state) {
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
