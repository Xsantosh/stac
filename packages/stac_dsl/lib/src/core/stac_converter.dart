import 'dart:convert';
import 'dart:io';

import 'stac_widget.dart';

/// Utility class for converting STAC widgets to JSON.
class StacConverter {
  /// Converts a STAC widget to a JSON string.
  ///
  /// The [widget] parameter is the STAC widget to convert.
  /// The [indent] parameter controls whether the JSON output is pretty-printed.
  static String toJsonString(StacWidget widget, {bool indent = true}) {
    final encoder = indent
        ? JsonEncoder.withIndent('  ')
        : JsonEncoder();
    
    return encoder.convert(widget.toJson());
  }

  /// Converts a STAC widget to a JSON file.
  ///
  /// The [widget] parameter is the STAC widget to convert.
  /// The [filePath] parameter is the path to the output JSON file.
  /// The [indent] parameter controls whether the JSON output is pretty-printed.
  ///
  /// Returns a [Future] that completes when the file is written.
  static Future<void> toJsonFile(
    StacWidget widget,
    String filePath, {
    bool indent = true,
  }) async {
    final jsonString = toJsonString(widget, indent: indent);
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }
}
