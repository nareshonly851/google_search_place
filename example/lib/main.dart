import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:google_search_place/model/prediction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Google Place',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Search Google Place'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchPlaceAutoCompletedTextField(
                googleAPIKey: "",
                controller: _searchPlaceController,
                itmOnTap: (Prediction prediction) {
                  _searchPlaceController.text =
                      prediction.description ?? "";

                  _searchPlaceController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: prediction.description?.length ?? 0));
                },
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  _searchPlaceController.text =
                      prediction.description ?? "";

                  _searchPlaceController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: prediction.description?.length ?? 0));

                  debugPrint("${prediction.lat} ${prediction.lng}");
                }),
          ),
        ));
  }
}
