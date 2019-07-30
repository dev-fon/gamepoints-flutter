import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamepointsflutter/src/blocs/player_bloc/player_bloc.dart';
import 'src/app.dart';

void main() {
  // This is the implementation for using multiple BlocProviders when you have more than one bloc.
  // We currently only have 1 bloc so the previous code is below in the event we were NOT going to
  // be using multiple blocs
  runApp(
    MultiBlocProvider(providers: [
    BlocProvider<PlayerBloc>(
      builder: (context) => PlayerBloc()
    )
  ],
  child: App(),
  ));
  // runApp(
  //   BlocProvider<PlayerBloc>(
  //     builder: (context) => PlayerBloc(),
  //     child: App()
  //   ));
}
