#!/usr/bin/env dart

import 'package:args/args.dart';
import 'package:stac_cli/src/commands/convert_command.dart';
import 'package:stac_cli/src/commands/validate_command.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  
  // Add global options
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help');
  parser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Show verbose output');
  parser.addOption('project-dir', 
                  abbr: 'p', 
                  help: 'Project directory containing the /stac folder');
  
  // Add commands
  parser.addCommand('convert', convertCommandParser());
  parser.addCommand('validate', validateCommandParser());

  try {
    final results = parser.parse(arguments);
    
    if (results['help']) {
      printUsage(parser);
      return;
    }

    final verbose = results['verbose'] as bool;
    final projectDir = results['project-dir'] as String?;

    final command = results.command;
    if (command == null) {
      print('No command specified.');
      printUsage(parser);
      return;
    }

    switch (command.name) {
      case 'convert':
        handleConvertCommand(command, projectDir, verbose);
        break;
      case 'validate':
        handleValidateCommand(command, projectDir, verbose);
        break;
      default:
        print('Unknown command: ${command.name}');
        printUsage(parser);
    }
  } catch (e) {
    print('Error: $e');
    printUsage(parser);
  }
}

void printUsage(ArgParser parser) {
  print('''
stac_cli - A tool to convert Dart STAC code to STAC JSON

Usage: stac_cli [options] <command> [command-options]

Global Options:
${parser.usage}

Commands:
  convert    Convert Dart STAC code to STAC JSON
  validate   Validate Dart STAC code

For detailed help on each command, run:
  stac_cli <command> --help
''');
}
