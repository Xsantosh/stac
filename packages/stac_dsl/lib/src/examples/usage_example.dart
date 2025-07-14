import 'dart:io';

import '../../../stac_dsl.dart';

/// This example demonstrates how to use the STAC DSL to define widgets
/// and convert them to JSON format.
void main() async {
  // Example 1: Simple text widget
  final simpleText = StacText(
    data: 'Hello World',
    style: StacTextStyle(
      fontSize: 18.0,
      fontWeight: 700,
      color: '#000000',
    ),
  );
  
  print('Simple Text JSON:');
  print(StacConverter.toJsonString(simpleText));
  
  // Example 2: Button with text
  final button = StacElevatedButton(
    child: StacText(data: 'Button'),
    hasOnPressed: true,
  );
  
  print('\nButton JSON:');
  print(StacConverter.toJsonString(button));
  
  // Example 3: Container with nested child
  final container = StacContainer(
    width: 200.0,
    height: 150.0,
    color: '#FF0000',
    child: StacText(
      data: 'Container Text',
      style: StacTextStyle(
        fontSize: 14.0,
        color: '#FFFFFF',
      ),
    ),
  );
  
  print('\nContainer JSON:');
  print(StacConverter.toJsonString(container));
  
  // Save to file example
  final exampleDir = Directory('example');
  if (!await exampleDir.exists()) {
    await exampleDir.create();
  }
  
  await StacConverter.toJsonFile(
    container,
    'example/container_example.json',
  );
  
  print('\nSaved container example to: example/container_example.json');
}
