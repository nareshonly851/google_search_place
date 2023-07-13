library google_search_place;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_search_place/model/place_details.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class SearchPlaceAutoCompletedTextField extends StatefulWidget {
  final String googleAPIKey;
  final InputDecoration? inputDecoration;
  final ItemOnTab itmOnTap;
  final GetPlaceDetailsWithLatLng? getPlaceDetailWithLatLng;
  final bool isLatLngRequired;
  final TextStyle? textStyle;
  final TextStyle? itemTextStyle;
  final int debounceTime;
  final List<String> countries;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const SearchPlaceAutoCompletedTextField(
      {Key? key,
      required this.googleAPIKey,
      this.inputDecoration,
      required this.itmOnTap,
      this.getPlaceDetailWithLatLng,
      this.isLatLngRequired = true,
      this.textStyle,
      this.debounceTime = 600,
      this.countries = const [],
      this.validator,
      this.focusNode,
      this.itemTextStyle,
      this.controller})
      : super(key: key);

  @override
  State<SearchPlaceAutoCompletedTextField> createState() =>
      _SearchPlaceAutoCompletedTextFieldState();
}

class _SearchPlaceAutoCompletedTextFieldState
    extends State<SearchPlaceAutoCompletedTextField> {
  final _subject = PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  final List<Prediction> _alPredictions = [];

  final LayerLink _layerLink = LayerLink();

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();

    _subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(_textChanged);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        textInputAction: TextInputAction.done,
        decoration: widget.inputDecoration,
        style: widget.textStyle,
        controller: widget.controller,
        onChanged: (string) => (_subject.add(string)),
        validator: widget.validator,
        focusNode: widget.focusNode,
      ),
    );
  }

  _getLocation(String text) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}";

    for (int i = 0; i < widget.countries.length; i++) {
      String country = widget.countries[i];

      if (i == 0) {
        url = "$url&components=country:$country";
      } else {
        url = "$url|country:$country";
      }
    }

    Response response = await _dio.get(url);
    PlacesAutocompleteResponse subscriptionResponse =
        PlacesAutocompleteResponse.fromJson(response.data);

    if (text.isEmpty) {
      _alPredictions.clear();
      _overlayEntry?.remove();
      return;
    }

    if (subscriptionResponse.predictions!.isNotEmpty) {
      _alPredictions.clear();
      _alPredictions.addAll(subscriptionResponse.predictions!);
    }

    _overlayEntry = null;
    _overlayEntry = _createOverlayEntry();
    Timer.run(() {
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  _textChanged(String text) async {
    _getLocation(text);
  }

  OverlayEntry? _createOverlayEntry() {
    if (context.findRenderObject() != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      return OverlayEntry(
          builder: (context) => Positioned(
                left: offset.dx,
                top: size.height + offset.dy,
                width: size.width,
                child: CompositedTransformFollower(
                  showWhenUnlinked: false,
                  link: _layerLink,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                      elevation: 1.0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _alPredictions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (index < _alPredictions.length) {
                                widget.itmOnTap(_alPredictions[index]);
                                if (!widget.isLatLngRequired) return;

                                _getPlaceDetailsFromPlaceId(
                                    _alPredictions[index]);

                                _removeOverlay();
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  _alPredictions[index].description ?? "",
                                  style: widget.itemTextStyle,
                                )),
                          );
                        },
                      )),
                ),
              ));
    }
    return null;
  }

  _removeOverlay() {
    _alPredictions.clear();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _overlayEntry?.markNeedsBuild();
  }

  _getPlaceDetailsFromPlaceId(Prediction prediction) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${widget.googleAPIKey}";
    Response response = await _dio.get(
      url,
    );

    PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);

    prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
    prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

    prediction.placeDetails = placeDetails;
    widget.getPlaceDetailWithLatLng!(prediction);
  }
}

typedef ItemOnTab = void Function(Prediction postalCodeResponse);
typedef GetPlaceDetailsWithLatLng = void Function(
    Prediction postalCodeResponse);
