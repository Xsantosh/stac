import 'package:flutter/material.dart';
// Import STAC exports
import 'package:stac/src/framework/stac_exporter.dart';
import 'package:stac/src/parsers/widgets/stac_container/stac_container_export.dart';
import 'package:stac/src/parsers/widgets/stac_text/stac_text_export.dart';

void main() async {
  await _setupExporter();

  final json = StacExporter.instance.exportWidget(createRedContainer());
  print(json);
}

Future<void> _setupExporter() async {
  // Use the export tools utility to setup all needed exporters
  // StacExportTools.setupExporters();

  // Register all needed exporters
  final containerExporter = StacContainerExport();
  final textExporter = StacTextExport();

  // Clear existing exporters and register new ones
  StacExporter.instance.clear();
  await StacExporter.instance.registerAll([containerExporter, textExporter]);
}

Widget createRedContainer() {
  return Container(
    color: Colors.red,
    child: Text('Hello'),
  );
}
