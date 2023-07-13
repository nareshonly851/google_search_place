# google_search_place

[![Pub](https://img.shields.io/pub/v/google_search_place.svg)](https://pub.dev/packages/google_search_place)
[![Dev](https://img.shields.io/pub/v/google_search_place.svg?label=dev&include_prereleases)](https://pub.dev/packages/google_search_place)

Custom Google search places autocomplete widget for all platform.

## Get started

### Add dependency

You can use the command to add dio as a dependency with the latest stable version:

```console
$ dart pub add google_search_place
```

Or you can manually add dio into the dependencies section in your pubspec.yaml:

```yaml
dependencies:
  google_search_place: ^replace-with-latest-version
```

The latest version is: ![Pub](https://img.shields.io/pub/v/google_search_place.svg)
The latest version including pre-releases is: ![Pub](https://img.shields.io/pub/v/google_search_place?include_prereleases)

**Before you upgrade: Breaking changes might happen in major and minor versions of packages.<br/>
See the [Migration Guide][] for the complete breaking changes list.**

### Super simple to use

```
import 'package:google_search_place/google_search_place.dart';

final TextEditingController _searchPlaceController = TextEditingController();
 SearchPlaceAutoCompletedTextField(
  googleAPIKey: "",
  controller: _searchPlaceController,
  itmOnTap: (Prediction prediction) {
    _searchPlaceController.text = prediction.description ?? "";

    _searchPlaceController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description?.length ?? 0));
  },
  getPlaceDetailWithLatLng: (Prediction prediction) {
    _searchPlaceController.text = prediction.description ?? "";

    _searchPlaceController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description?.length ?? 0));

    debugPrint("${prediction.lat} ${prediction.lng}");
  }
)
    
```

## Customization Option

You can customize a text field input decoration and debounce time

## Screenshots

<img src="https://github.com/nareshonly851/google_search_place/blob/main/screenshots/sample.png" height="400">