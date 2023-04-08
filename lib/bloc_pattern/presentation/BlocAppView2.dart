import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_cubit.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';
import 'package:flutter_samples/custom_widgets/labeled_divider.dart';

class BlocAppView2 extends StatefulWidget {
  final String title;
  final Color color;
  const BlocAppView2({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  _BlocAppView2State createState() => _BlocAppView2State();
}

class _BlocAppView2State extends State<BlocAppView2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Text("Bloc pattern test: ${widget.title}"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabeledDivider("technicalfeeder.com"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<TechnicalFeederCubit>(context).read();
                  },
                  child: Text("Successful Trigger"),
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<TechnicalFeederCubit>(context).read(isFail: true);
                  },
                  child: Text("Failing Trigger"),
                ),
                generateResultDisplayArea<TechnicalFeederCubit>(),
              ],
            ),
            LabeledDivider("example.com"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<UnknownSiteCubit>(context).read();
                  },
                  child: Text("Successful Trigger"),
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<UnknownSiteCubit>(context).read(isFail: true);
                  },
                  child: Text("Failing Trigger"),
                ),
                generateResultDisplayArea<UnknownSiteCubit>(),
              ],
            ),
          ],
        ),
      ),
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
