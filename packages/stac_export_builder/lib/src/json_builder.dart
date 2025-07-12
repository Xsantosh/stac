import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:path/path.dart' as p;

import 'annotations.dart';
import 'widget_export_generator.dart';

/// A builder that generates JSON files directly from [StacExportable] annotations.
/// Each annotated function generates its own JSON file.
class StacJsonBuilder implements Builder {
  final BuilderOptions options;
  final TypeChecker _typeChecker = TypeChecker.fromRuntime(StacExportable);
  
  /// Output directory for JSON files
  final String outputDir;

  StacJsonBuilder(this.options) : outputDir = options.config['output_dir'] as String? ?? 'stac_json';

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.stac.json', '.stac/*.json'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Get the library for the current asset
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    
    final lib = await resolver.libraryFor(buildStep.inputId);
    final libraryReader = LibraryReader(lib);
    
    // Find all elements annotated with StacExportable
    final elements = libraryReader.annotatedWith(_typeChecker);
    if (elements.isEmpty) return;
    
    // Create a map to store individual widget exports
    final Map<String, Map<String, dynamic>> individualWidgets = {};
    
    // Process each annotated element
    for (final annotatedElement in elements) {
      final element = annotatedElement.element;
      final annotation = annotatedElement.annotation;
      
      if (element is FunctionElement) {
        // Get export name from annotation or function name
        final name = annotation.read('name').literalValue as String? ?? element.name;
        
        try {
          // Use the same widget analysis logic from the generator
          final generator = WidgetExportGenerator();
          final json = generator.analyzeFunction(element);
          
          if (json != null) {
            // Store the JSON for this widget
            individualWidgets[name] = json;
          }
        } catch (e) {
          log.warning('Error processing ${element.name}: $e');
        }
      }
    }
    
    if (individualWidgets.isEmpty) return;
    
    // Create a directory for individual widget JSON files
    final inputPath = buildStep.inputId.path;
    final baseName = p.basenameWithoutExtension(inputPath);
    final dirPath = p.join(p.dirname(inputPath), '.stac');
    
    // Also write the first widget to the legacy file path for backwards compatibility
    final legacyOutputPath = p.join(p.dirname(inputPath), '$baseName.stac.json');
    final legacyOutputId = AssetId(buildStep.inputId.package, legacyOutputPath);
    
    final jsonEncoder = const JsonEncoder.withIndent('  ');
    final Map<String, dynamic> firstWidget = individualWidgets.values.first;
    final legacyJsonContent = jsonEncoder.convert(firstWidget);
    await buildStep.writeAsString(legacyOutputId, legacyJsonContent);
    
    // Write each widget to its own file
    int fileCount = 0;
    for (final entry in individualWidgets.entries) {
      final widgetName = entry.key;
      final widgetJson = entry.value;
      
      // Create a filename based on the function name
      final safeWidgetName = widgetName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
      final fileName = '$safeWidgetName.json';
      final outputPath = p.join(dirPath, fileName);
      final outputId = AssetId(buildStep.inputId.package, outputPath);
      
      // Write the widget JSON content (not wrapped in a map with the function name as key)
      final jsonContent = jsonEncoder.convert(widgetJson);
      await buildStep.writeAsString(outputId, jsonContent);
      fileCount++;
    }
    
    log.info('Generated $fileCount JSON files for widgets in $dirPath');
  }
}
