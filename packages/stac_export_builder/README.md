# STAC Export Builder

A code generation tool for exporting Flutter widgets to STAC JSON during build time.

## Overview

STAC Export Builder is a build_runner-based tool that statically analyzes your Flutter widget code and generates STAC JSON representations without running the Flutter framework. This is particularly useful for:

- Automated generation of STAC JSON from existing Flutter code
- CI/CD pipelines that need to extract STAC JSON without running Flutter
- Development workflows that require static analysis of widget structures
- Migration tools from Flutter widgets to STAC model classes

## Installation

Add the dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  stac: ^1.0.0  # Or whatever version you're using
  stac_export_builder: 
    path: ../stac_export_builder  # Adjust path as needed

dev_dependencies:
  build_runner: ^2.4.0
```

## Usage

### 1. Mark widgets for export

Use the `@StacExportable()` annotation on functions that return widgets you want to export:

```dart
import 'package:flutter/material.dart';
import 'package:stac_export_builder/stac_export_builder.dart';

part 'my_file.g.dart';  // Important: Add this to enable code generation

@StacExportable()
Widget createRedContainer() {
  return Container(
    width: 200,
    height: 150,
    color: Colors.red,
    child: const Text('Hello STAC!'),
  );
}

// Custom name for the export
@StacExportable(name: 'custom_name')
Widget anotherWidget() {
  return Text('Another widget');
}
```

### 2. Run build_runner

Generate the STAC JSON representations by running:

```bash
flutter pub run build_runner build
```

### 3. Use the generated code

The generated code will contain a `stacExports` map with your widget representations:

```dart
// Access the generated exports
import 'my_file.g.dart';

void main() {
  // Access by function name
  final json = stacExports['createRedContainer'];
  print(json);
  
  // Or by custom name if provided
  final customJson = stacExports['custom_name'];
  print(customJson);
}
```

### 4. Direct JSON File Output

In addition to generating Dart code, the builder also automatically creates standalone JSON files for each file containing annotated functions. These JSON files are named with the pattern `[filename].stac.json` and are placed in the same directory as the source file.

For example, if you have a file `lib/widgets/my_widgets.dart`, the JSON output will be available at:

```
lib/widgets/my_widgets.stac.json
```

This makes it easy to integrate with CI/CD pipelines, static website generators, or any other tooling that expects JSON files directly.

### 5. Custom JSON Export Script (Optional)

If you need more control over how and where JSON files are generated, you can create a custom script:

```dart
// bin/export_stac.dart
import 'dart:convert';
import 'dart:io';
import 'package:your_package/my_file.g.dart';

void main(List<String> args) {
  // Get output directory from args or use default
  final outputDir = args.isNotEmpty ? args[0] : 'stac_exports';
  
  // Create output directory if it doesn't exist
  Directory(outputDir).createSync(recursive: true);
  
  // Export each widget to a separate JSON file
  stacExports.forEach((name, json) {
    final file = File('$outputDir/$name.json');
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(json));
    print('Exported $name to ${file.path}');
  });
}
```

Run this script with:

```bash
dart bin/export_stac.dart output_directory
```

## Supported Widgets

The current version supports the following Flutter widgets:

- Container
- Text
- Row
- Column

Properties supported include:

- Basic geometric properties (width, height)
- Colors
- Text styles
- Padding and margin (via EdgeInsets)
- Decoration (basic BoxDecoration properties)
- Child and children widgets

## Limitations

### Static Analysis Limitations

- **Dynamic Values**: Only static literals and constants can be fully analyzed. Variables, computed values, and runtime expressions will be represented as strings or may not be correctly evaluated.

- **Context-Dependent Widgets**: Widgets that depend on BuildContext (like Theme.of(context)) cannot be properly evaluated.

- **Custom Widgets**: Only built-in Flutter widgets are supported. Custom widgets need their own analyzer implementations.

- **Complex Expressions**: Complex expressions like conditional operators might not be evaluated correctly.

### Flutter Framework Limitations

- **No Runtime Validation**: Since the analysis happens without running the Flutter framework, there's no validation of widget properties.

- **No Media Queries**: Screen size, orientation, and other media query values aren't available.

- **No Theme Data**: Theme-dependent properties will be represented as literal values or strings.

## Best Practices

1. **Use Simple Static Values**: When possible, use static literals for properties to ensure accurate export.

2. **Prefer Model-First Approach**: For production code, consider using STAC model classes directly:

   ```dart
   StacContainer(
     color: Colors.red,
     child: StacText('Hello STAC!')
   )
   ```

3. **Add Comments**: Document the expected output of complex widgets.

4. **Review Generated Output**: Always review the generated JSON to ensure it matches your expectations.

## Contributing

Contributions to improve the widget support or fix limitations are welcome. Please see CONTRIBUTING.md for details.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
