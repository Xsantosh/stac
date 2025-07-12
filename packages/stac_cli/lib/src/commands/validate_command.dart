import 'dart:io';
import 'package:args/args.dart';
import 'package:stac_cli/src/validator/stac_validator.dart';
import 'package:stac_cli/src/utils/file_utils.dart';
import 'package:path/path.dart' as p;

ArgParser validateCommandParser() {
  final parser = ArgParser();
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help');
  return parser;
}

void handleValidateCommand(ArgResults results, String? projectDir, bool verbose) {
  if (results['help']) {
    _printValidateHelp();
    return;
  }

  // Determine project directory
  final workingDir = projectDir ?? Directory.current.path;
  final stacDir = p.join(workingDir, 'stac');
  
  if (verbose) {
    print('Validating Dart STAC files...');
    print('Looking in directory: $stacDir');
  }

  // Validate stac directory exists
  final stacDirExists = Directory(stacDir).existsSync();
  if (!stacDirExists) {
    print('Error: /stac folder not found in $workingDir.');
    print('Please create a /stac folder containing your STAC Dart code files.');
    exit(1);
  }

  // Process all Dart files in stac directory
  final validator = StacValidator(verbose: verbose);
  final dartFiles = FileUtils.findDartFiles(stacDir);
  
  if (dartFiles.isEmpty) {
    print('No Dart files found in $stacDir.');
    exit(1);
  }
  
  if (verbose) {
    print('Found ${dartFiles.length} Dart files to validate.');
  }
  
  // Validate each Dart file
  int validCount = 0;
  int invalidCount = 0;
  
  for (final dartFile in dartFiles) {
    try {
      if (verbose) {
        print('Validating ${dartFile.path}...');
      }
      
      final result = validator.validateFile(dartFile.path);
      if (result.isValid) {
        validCount++;
        if (verbose) {
          print('✓ ${dartFile.path} is a valid STAC file.');
        }
      } else {
        invalidCount++;
        print('✗ ${dartFile.path} has validation errors:');
        for (final error in result.errors) {
          print('  - $error');
        }
      }
    } catch (e) {
      print('Error validating ${dartFile.path}: $e');
      invalidCount++;
    }
  }
  
  print('Validation complete:');
  print('- Valid files: $validCount');
  print('- Invalid files: $invalidCount');
  
  if (invalidCount > 0) {
    exit(1);
  }
}

void _printValidateHelp() {
  print('''
stac_cli validate - Validate Dart STAC code

Usage: stac_cli validate [options]

Options:
  -h, --help          Show this help
  
Example:
  stac_cli validate
''');
}
