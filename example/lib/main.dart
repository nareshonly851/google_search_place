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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Search Google Place'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchPlaceAutoCompletedTextField(
                googleAPIKey: "GOOGLE_API_KEY",
                controller: _searchPlaceController,
                itmOnTap: (Prediction prediction) {
                  _searchPlaceController.text = prediction.description ?? "";

                  _searchPlaceController.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: prediction.description?.length ?? 0));
                },
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  _searchPlaceController.text = prediction.description ?? "";

                  _searchPlaceController.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: prediction.description?.length ?? 0));

                  // Get search place latitude and longitude
                  debugPrint("${prediction.lat} ${prediction.lng}");

                  // Get place Detail
                  debugPrint("Place Detail : ${prediction.placeDetails}");
                }),
          ),
        ));
  }
}
