import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stac_dsl/stac_dsl.dart';

void main() {
  group('StacText tests', () {
    test('StacText with data only', () {
      final text = StacText(data: 'Hello World');
      final json = text.toJson();
      
      expect(json['type'], 'text');
      expect(json['data'], 'Hello World');
      expect(json['style'], isNull);
    });
    
    test('StacText with style', () {
      final text = StacText(
        data: 'Styled Text',
        style: StacTextStyle(
          fontSize: 18.0,
          fontWeight: 700,
          color: '#000000',
        ),
      );
      final json = text.toJson();
      
      expect(json['type'], 'text');
      expect(json['data'], 'Styled Text');
      expect(json['style'], isNotNull);
      expect(json['style']['fontSize'], 18.0);
      expect(json['style']['fontWeight'], 700);
      expect(json['style']['color'], '#000000');
    });
  });
  
  group('StacContainer tests', () {
    test('Empty container', () {
      final container = StacContainer();
      final json = container.toJson();
      
      expect(json['type'], 'container');
      expect(json['width'], isNull);
      expect(json['height'], isNull);
      expect(json['color'], isNull);
      expect(json['child'], isNull);
    });
    
    test('Container with properties', () {
      final container = StacContainer(
        width: 200.0,
        height: 150.0,
        color: '#FF0000',
      );
      final json = container.toJson();
      
      expect(json['type'], 'container');
      expect(json['width'], 200.0);
      expect(json['height'], 150.0);
      expect(json['color'], '#FF0000');
      expect(json['child'], isNull);
    });
    
    test('Container with child', () {
      final container = StacContainer(
        width: 200.0,
        child: StacText(data: 'Child Text'),
      );
      final json = container.toJson();
      
      expect(json['type'], 'container');
      expect(json['width'], 200.0);
      expect(json['child'], isNotNull);
      expect(json['child']['type'], 'text');
      expect(json['child']['data'], 'Child Text');
    });
  });
  
  group('StacElevatedButton tests', () {
    test('Button with text child', () {
      final button = StacElevatedButton(
        child: StacText(data: 'Button'),
      );
      final json = button.toJson();
      
      expect(json['type'], 'elevatedButton');
      expect(json['hasOnPressed'], true);
      expect(json['child']['type'], 'text');
      expect(json['child']['data'], 'Button');
    });
    
    test('Button without onPressed', () {
      final button = StacElevatedButton(
        child: StacText(data: 'Disabled'),
        hasOnPressed: false,
      );
      final json = button.toJson();
      
      expect(json['type'], 'elevatedButton');
      expect(json['hasOnPressed'], false);
      expect(json['child']['type'], 'text');
      expect(json['child']['data'], 'Disabled');
    });
  });
  
  group('StacConverter tests', () {
    test('toJsonString produces valid JSON', () {
      final widget = StacContainer(
        child: StacText(data: 'Test'),
      );
      
      final jsonString = StacConverter.toJsonString(widget);
      expect(() => jsonDecode(jsonString), returnsNormally);
      
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      expect(decoded['type'], 'container');
      expect(decoded['child']['type'], 'text');
      expect(decoded['child']['data'], 'Test');
    });
    
    test('toJsonString with indent=false produces compact JSON', () {
      final widget = StacText(data: 'Compact');
      final jsonString = StacConverter.toJsonString(widget, indent: false);
      
      // Compact JSON should not contain newlines
      expect(jsonString.contains('\n'), isFalse);
    });
  });
}