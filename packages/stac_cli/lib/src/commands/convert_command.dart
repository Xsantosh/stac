import 'dart:io';
import 'package:args/args.dart';
import 'package:stac_cli/src/converter/dart_to_stac_converter.dart';
import 'package:stac_cli/src/utils/file_utils.dart';
import 'package:path/path.dart' as p;

ArgParser convertCommandParser() {
  final parser = ArgParser();
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help');
  parser.addOption('output', abbr: 'o', help: 'Output directory for JSON files');
  parser.addFlag('format', defaultsTo: true, help: 'Format output JSON');
  return parser;
}

void handleConvertCommand(ArgResults results, String? projectDir, bool verbose) {
  if (results['help']) {
    _printConvertHelp();
    return;
  }

  final outputDir = results['output'] as String?;
  final formatJson = results['format'] as bool;
  
  // Determine project directory
  final workingDir = projectDir ?? Directory.current.path;
  final stacDir = p.join(workingDir, 'stac');
  
  if (verbose) {
    print('Converting Dart STAC files to JSON...');
    print('Looking in directory: $stacDir');
    if (outputDir != null) {
      print('Output directory: $outputDir');
    }
  }

  // Validate stac directory exists
  final stacDirExists = Directory(stacDir).existsSync();
  if (!stacDirExists) {
    print('Error: /stac folder not found in $workingDir.');
    print('Please create a /stac folder containing your STAC Dart code files.');
    exit(1);
  }

  // Process all Dart files in stac directory
  final converter = DartToStacConverter(formatJson: formatJson, verbose: verbose);
  final dartFiles = FileUtils.findDartFiles(stacDir);
  
  if (dartFiles.isEmpty) {
    print('No Dart files found in $stacDir.');
    exit(1);
  }
  
  if (verbose) {
    print('Found ${dartFiles.length} Dart files to process.');
  }
  
  // Setup output directory
  final outputDirectory = outputDir != null 
      ? Directory(outputDir) 
      : Directory(p.join(workingDir, 'stac_json'));
  
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync(recursive: true);
    if (verbose) {
      print('Created output directory: ${outputDirectory.path}');
    }
  }
  
  // Convert each Dart file
  int successCount = 0;
  for (final dartFile in dartFiles) {
    try {
      final fileName = p.basenameWithoutExtension(dartFile.path);
      final jsonPath = p.join(outputDirectory.path, '$fileName.json');
      
      if (verbose) {
        print('Converting ${dartFile.path} to $jsonPath...');
      }
      
      final result = converter.convertFile(dartFile.path, jsonPath);
      if (result) {
        successCount++;
      }
    } catch (e) {
      print('Error processing ${dartFile.path}: $e');
    }
  }
  
  print('Conversion complete. Successfully converted $successCount/${dartFiles.length} files.');
  print('Output saved to: ${outputDirectory.path}');
}

void _printConvertHelp() {
  print('''
stac_cli convert - Convert Dart STAC code to STAC JSON

Usage: stac_cli convert [options]

Options:
  -h, --help          Show this help
  -o, --output        Output directory for JSON files (default: ./stac_json)
  --format            Format output JSON (default: true)
  
Example:
  stac_cli convert --output=./output
''');
}
