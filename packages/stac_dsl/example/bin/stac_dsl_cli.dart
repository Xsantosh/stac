import 'dart:io';

import 'package:args/args.dart';
import 'package:stac_dsl/stac_dsl.dart';

/// A command-line tool to generate STAC JSON from predefined templates
/// or custom widget configurations.
void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'type',
      abbr: 't',
      help: 'Type of widget to create',
      allowed: ['text', 'container', 'button', 'complex'],
      defaultsTo: 'text',
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output file path',
      defaultsTo: 'stac_output.json',
    )
    ..addOption(
      'text',
      help: 'Text content for text widgets',
      defaultsTo: 'Hello STAC',
    )
    ..addOption(
      'color',
      help: 'Color for containers or text (hex format)',
      defaultsTo: '#3B82F6',
    )
    ..addOption('font-size', help: 'Font size for text', defaultsTo: '18.0')
    ..addFlag(
      'pretty',
      abbr: 'p',
      help: 'Pretty print the JSON output',
      defaultsTo: true,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help message',
      negatable: false,
    );

  try {
    final results = parser.parse(args);

    if (results['help'] as bool) {
      printUsage(parser);
      exit(0);
    }

    final widgetType = results['type'] as String;
    final outputPath = results['output'] as String;
    final prettyPrint = results['pretty'] as bool;
    final textContent = results['text'] as String;
    final color = results['color'] as String;
    final fontSize = double.parse(results['font-size'] as String);

    StacWidget widget = createWidget(widgetType, textContent, color, fontSize);

    // Generate JSON and save to file
    await StacConverter.toJsonFile(widget, outputPath, indent: prettyPrint);

    print('STAC JSON generated successfully at: $outputPath');
    print('\nJSON Content:');
    print(StacConverter.toJsonString(widget, indent: prettyPrint));
  } catch (e) {
    print('Error: $e');
    printUsage(parser);
    exit(1);
  }
}

/// Create a widget based on the specified type and parameters
StacWidget createWidget(
  String type,
  String text,
  String color,
  double fontSize,
) {
  StacTextFormField(id: 'textFormField');

  switch (type) {
    case 'text':
      return StacText(
        data: text,
        style: StacTextStyle(fontSize: fontSize, fontWeight: 500, color: color),
      );

    case 'container':
      return StacContainer(
        width: 300.0,
        height: 200.0,
        color: color,
        child: StacText(
          data: text,
          style: StacTextStyle(fontSize: fontSize, color: '#FFFFFF'),
        ),
      );

    case 'button':
      return StacElevatedButton(
        child: StacText(
          data: text,
          style: StacTextStyle(fontSize: fontSize),
        ),
        hasOnPressed: true,
      );

    case 'complex':
      return StacContainer(
        width: 300.0,
        height: 200.0,
        color: color,
        child: StacText(
          data: text,
          style: StacTextStyle(fontSize: fontSize, color: '#FFFFFF'),
        ),
      );

    default:
      throw ArgumentError('Invalid widget type: $type');
  }
}

/// Print usage instructions
void printUsage(ArgParser parser) {
  print('STAC DSL CLI - Generate STAC JSON from the command line\n');
  print('Usage:');
  print('  dart stac_dsl_cli.dart [options]\n');
  print('Options:');
  print(parser.usage);
  print('\nExamples:');
  print('  dart stac_dsl_cli.dart -t text --text "Hello World" -o text.json');
  print(
    '  dart stac_dsl_cli.dart -t container --color "#FF0000" -o container.json',
  );
  print('  dart stac_dsl_cli.dart -t button --text "Click Me" -o button.json');
  print('  dart stac_dsl_cli.dart -t complex -o complex.json');
}
