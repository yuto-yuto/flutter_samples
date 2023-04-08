import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
