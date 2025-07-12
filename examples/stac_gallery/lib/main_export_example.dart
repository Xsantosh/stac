import 'dart:convert';

import 'package:flutter/material.dart';
// Import STAC exports
import 'package:stac/src/framework/stac_exporter.dart';
import 'package:stac/src/parsers/widgets/stac_container/stac_container_export.dart';
import 'package:stac/src/parsers/widgets/stac_text/stac_text_export.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'STAC Export Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExportExampleScreen(),
    ),
  );
}

class ExportExampleScreen extends StatefulWidget {
  const ExportExampleScreen({super.key});

  @override
  State<ExportExampleScreen> createState() => _ExportExampleScreenState();
}

class _ExportExampleScreenState extends State<ExportExampleScreen> {
  // JSON representation of the exported widget
  String _jsonOutput = '';

  @override
  void initState() {
    super.initState();
    // Initialize the StacExporter with a StacContainerExport
    _setupExporter();
  }

  void _setupExporter() {
    // Use the export tools utility to setup all needed exporters
    // StacExportTools.setupExporters();

    // Register all needed exporters
    final containerExporter = StacContainerExport();
    final textExporter = StacTextExport();

    // Clear existing exporters and register new ones
    StacExporter.instance.clear();
    StacExporter.instance.registerAll([containerExporter, textExporter]);
  }

  void _exportContainer() {
    // Create a Flutter container with various properties
    final container = Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 3),
            blurRadius: 6.0,
            spreadRadius: 1.0,
          )
        ],
        border: Border.all(color: Colors.blue[800]!, width: 2.0),
      ),
      child: const Text(
        'Hello STAC Export!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    // Export the container to STAC JSON
    final json = StacExporter.instance.exportWidget(container);

    // Format the JSON for display
    final encodedJson = json != null
        ? const JsonEncoder.withIndent('  ').convert(json)
        : 'Failed to export widget';

    // Update the UI
    setState(() {
      _jsonOutput = encodedJson;
    });
  }

  // Export a blue container with text
  void _exportHomeWidget() {
    // Create a blue container with text
    final widget = Container(
      width: 200,
      height: 150,
      color: Colors.blue,
      child: const Text(
        'Hello STAC Export!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    // Export the widget to JSON
    final json = StacExporter.instance.exportWidget(widget);

    // Format the JSON for display
    final encodedJson = json != null
        ? const JsonEncoder.withIndent('  ').convert(json)
        : 'Failed to export widget';

    // Update the UI
    setState(() {
      _jsonOutput = encodedJson;
    });
  }

  // Export the current widget to a file
  void _exportToFile() async {
    final container = Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 3),
            blurRadius: 6.0,
            spreadRadius: 1.0,
          )
        ],
        border: Border.all(color: Colors.blue[800]!, width: 2.0),
      ),
      child: const Text(
        'Hello STAC Export!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    // // Export and save to file
    // final filePath = await StacExportTools.exportWidgetToFile(
    //   container,
    //   filename: 'stac_container_export.json',
    // );

    // // Display result
    // setState(() {
    //   _jsonOutput = filePath != null
    //       ? 'Widget exported successfully to file:\n$filePath'
    //       : 'Failed to export widget to file';
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STAC Export Example'),
      ),
      body: Column(
        children: [
          // Sample container to be exported
          Container(
            width: 200,
            height: 150,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 3),
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                )
              ],
              border: Border.all(color: Colors.blue[800]!, width: 2.0),
            ),
            child: const Text(
              'Hello STAC Export!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Buttons for export options
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _exportContainer,
                child: const Text('Export to JSON'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _exportHomeWidget,
                child: const Text('Export Home Widget'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _exportToFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save to File'),
              ),
            ],
          ),

          // Display the resulting JSON
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Export Result:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: double.infinity,
                      child: Text(
                        _jsonOutput.isNotEmpty
                            ? _jsonOutput
                            : 'Press the button to export',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// If you want to also demonstrate exporting the entire widget tree
void _exportWidgetTreeExample() {
  // This method shows how you would export an entire widget tree
  final container = Container(
    child: Column(
      children: [
        const Text('Header'),
        Row(
          children: [
            Container(color: Colors.red, width: 50, height: 50),
            Container(color: Colors.green, width: 50, height: 50),
          ],
        ),
      ],
    ),
  );

  // Export the entire widget tree
  final json = StacExporter.instance.exportWidgetTree(container);
  print(const JsonEncoder.withIndent('  ').convert(json));
}
