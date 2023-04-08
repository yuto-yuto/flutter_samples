import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_cubit.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_reader.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_repository.dart';
import 'package:flutter_samples/bloc_pattern/presentation/BlocAppView1.dart';
import 'package:flutter_samples/bloc_pattern/presentation/BlocAppView2.dart';
import 'package:flutter_samples/bloc_pattern/constants.dart';
import 'package:flutter_samples/main.dart';

class BlocPattern extends StatelessWidget {
  const BlocPattern({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => SiteDataRepository(reader: SiteDataReader()),
          ),
        ],
        child: MultiBlocProvider(
          child: MaterialApp(
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case "/":
                  return MaterialPageRoute(
                    builder: (_) => BlocAppView1(title: "first", color: Colors.yellow),
                  );
                case "/second":
                  return MaterialPageRoute(
                    builder: (_) => BlocAppView2(title: "second", color: Colors.red),
                  );
                case "/home":
                  return MaterialPageRoute(builder: (_) => MyApp());
                default:
                  return null;
              }
            },
          ),
          providers: [
            BlocProvider(
              create: (context) => TechnicalFeederCubit(
                RepositoryProvider.of<SiteDataRepository>(context),
                filename: FILENAME_TECHNICAL_FEEDER,
              ),
            ),
            BlocProvider(
              create: (context) => UnknownSiteCubit(
                RepositoryProvider.of<SiteDataRepository>(context),
                filename: FILENAME_UNKNOWN,
              ),
            ),
          ],
        ));
  }
}
