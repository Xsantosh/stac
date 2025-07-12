import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
// Import STAC exports
import 'package:stac/src/framework/stac_exporter.dart';
import 'package:stac/src/parsers/widgets/stac_container/stac_container_export.dart';
import 'package:stac/src/parsers/widgets/stac_elevated_button/stac_elevated_button_exporter.dart';
import 'package:stac/src/parsers/widgets/stac_text/stac_text_export.dart';

import '../stac/button.dart' as button;
// Import the known widget definitions from stac folder
import '../stac/home.dart' as home;

/// Script to scan the stac directory, find all Dart files,
/// and convert their widgets to JSON using STAC exporter
void main() async {
  // Setup STAC exporter with required parsers
  await _setupExporter();

  // Define directories
  final scriptDir = Directory.current.path;
  final stacDir = Directory(path.join(scriptDir, 'stac'));
  final outputDir = Directory(path.join(scriptDir, 'stac_json'));

  // Ensure output directory exists
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Check if stac directory exists
  if (!stacDir.existsSync()) {
    print('Error: stac directory not found at ${stacDir.path}');
    return;
  }

  print('Scanning directory: ${stacDir.path}');

  // Map of known widget builder functions by their source file
  // In a real implementation, you would dynamically load these or use code generation
  final knownWidgetsByFile = {
    'home.dart': {
      'homeContainer': home.homeContainer,
      'getButton': button.getButton,
    },
    // Add other files here as needed
  };

  // Process all Dart files in the stac directory
  final dartFiles = stacDir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));

  if (dartFiles.isEmpty) {
    print('No Dart files found in the stac directory');
    return;
  }

  print('Found ${dartFiles.length} Dart file(s) to process');

  // Process each file
  for (final dartFile in dartFiles) {
    final fileName = path.basename(dartFile.path);
    final baseName = path.basenameWithoutExtension(dartFile.path);

    print('Processing $fileName...');

    // Check if we have known widgets for this file
    final widgetBuilders = knownWidgetsByFile[fileName];
    if (widgetBuilders == null || widgetBuilders.isEmpty) {
      print('  No known widget builders for $fileName');
      continue;
    }

    // Process each widget builder
    for (final entry in widgetBuilders.entries) {
      final widgetName = entry.key;
      final widgetBuilder = entry.value;

      try {
        // Build the widget
        final widget = widgetBuilder();

        // Convert to JSON using StacExporter
        final jsonMap = StacExporter.instance.exportWidget(widget);

        // Save to JSON file
        final outputFile =
            File('${outputDir.path}/${baseName}_$widgetName.json');
        outputFile.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(jsonMap),
        );

        print('  Exported $widgetName to ${path.basename(outputFile.path)}');
      } catch (e) {
        print('  Error processing widget $widgetName: $e');
      }
    }
  }

  print('\nExport completed.');
}

/// Setup the STAC exporter with required parsers
Future<void> _setupExporter() async {
  // Register exporters for the widget types we want to support
  final containerExporter = StacContainerExport();
  final textExporter = StacTextExport();
  final elevatedButtonExporter = StacElevatedButtonExport();

  // Clear existing exporters and register new ones
  StacExporter.instance.clear();
  await StacExporter.instance.registerAll([
    containerExporter,
    textExporter,
    elevatedButtonExporter,
  ]);

  print('STAC exporters registered.');
}
