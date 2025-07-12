#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Command-line tool for exporting STAC JSON from generated code.
/// 
/// This tool assumes that you have already run build_runner to generate
/// the STAC JSON representations.
void main(List<String> arguments) {
  // Define command-line arguments
  final parser = ArgParser()
    ..addOption('input', 
        abbr: 'i', 
        help: 'Input generated Dart file with stacExports map',
        mandatory: true)
    ..addOption('output', 
        abbr: 'o', 
        help: 'Output directory for JSON files',
        defaultsTo: 'stac_exports')
    ..addOption('format', 
        abbr: 'f',
        help: 'Output format: single (one file) or multiple (one per widget)',
        allowed: ['single', 'multiple'],
        defaultsTo: 'multiple')
    ..addFlag('help', 
        abbr: 'h', 
        help: 'Show this help message', 
        negatable: false);

  // Parse arguments
  ArgResults args;
  try {
    args = parser.parse(arguments);
  } catch (e) {
    _printUsage(parser);
    exit(1);
  }

  // Show help if requested
  if (args['help']) {
    _printUsage(parser);
    return;
  }

  // Get input and output paths
  final inputPath = args['input'] as String;
  final outputPath = args['output'] as String;
  final format = args['format'] as String;

  // Verify input file exists
  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    print('Error: Input file not found: $inputPath');
    exit(1);
  }

  // Create output directory if it doesn't exist
  final outputDir = Directory(outputPath);
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Load the generated code
  final generatedCode = inputFile.readAsStringSync();
  
  // Extract stacExports map from the file
  final exports = _extractExports(generatedCode);
  if (exports.isEmpty) {
    print('Error: No STAC exports found in the input file.');
    exit(1);
  }

  // Export based on format
  if (format == 'single') {
    _exportSingleFile(exports, outputDir);
  } else {
    _exportMultipleFiles(exports, outputDir);
  }
}

/// Extract the stacExports map from generated code string.
///
/// This is a simplistic parser for demonstration purposes.
/// In a production environment, you would use a proper Dart parser
/// or consider other approaches.
Map<String, dynamic> _extractExports(String code) {
  final result = <String, dynamic>{};
  
  // Look for stacExports map
  final startIndex = code.indexOf('const Map<String, Map<String, dynamic>> stacExports =');
  if (startIndex == -1) return result;
  
  // Find opening brace
  final openBrace = code.indexOf('{', startIndex);
  if (openBrace == -1) return result;
  
  // Find closing brace by counting braces
  int depth = 1;
  int closeBrace = openBrace + 1;
  
  while (depth > 0 && closeBrace < code.length) {
    if (code[closeBrace] == '{') {
      depth++;
    } else if (code[closeBrace] == '}') {
      depth--;
    }
    closeBrace++;
  }
  
  if (depth != 0) return result;
  
  // Extract the map content
  final mapContent = code.substring(openBrace, closeBrace);
  
  // Parse entries using regex
  final entryPattern = RegExp(r"'([^']+)'\s*:\s*(\{[^}]+\})", dotAll: true);
  final matches = entryPattern.allMatches(mapContent);
  
  for (final match in matches) {
    if (match.groupCount >= 2) {
      final name = match.group(1)!;
      final jsonStr = match.group(2)!;
      
      try {
        // Try to parse as JSON
        final jsonData = json.decode(jsonStr);
        result[name] = jsonData;
      } catch (e) {
        print('Warning: Failed to parse JSON for $name: $e');
      }
    }
  }
  
  return result;
}

/// Export all widgets to a single JSON file.
void _exportSingleFile(Map<String, dynamic> exports, Directory outputDir) {
  final outputFile = File('${outputDir.path}/stac_exports.json');
  outputFile.writeAsStringSync(
    JsonEncoder.withIndent('  ').convert(exports)
  );
  print('Exported all widgets to ${outputFile.path}');
}

/// Export each widget to a separate JSON file.
void _exportMultipleFiles(Map<String, dynamic> exports, Directory outputDir) {
  exports.forEach((name, data) {
    final outputFile = File('${outputDir.path}/$name.json');
    outputFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(data)
    );
    print('Exported $name to ${outputFile.path}');
  });
  print('Exported ${exports.length} widget(s) to ${outputDir.path}');
}

/// Print usage instructions.
void _printUsage(ArgParser parser) {
  print('STAC Export CLI');
  print('');
  print('Usage: dart stac_export_cli.dart -i <input_file> [options]');
  print('');
  print('Options:');
  print(parser.usage);
}
