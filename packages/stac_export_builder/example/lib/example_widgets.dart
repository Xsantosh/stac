import 'package:flutter/material.dart';
import 'package:stac_export_builder/stac_export_builder.dart';

// This part directive is necessary for the generated code
part 'example_widgets.g.dart';

/// A simple container widget with a red background and text.
///
/// This widget is marked with [StacExportable] to generate STAC JSON during build.
@StacExportable()
Widget createRedContainer() {
  return Text(
    'Hello STAC Export!',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}
