import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;
import 'package:stac_cli/src/utils/file_utils.dart';

/// Class to convert Dart STAC code to JSON
class DartToStacConverter {
  final bool formatJson;
  final bool verbose;
  
  DartToStacConverter({
    this.formatJson = true,
    this.verbose = false,
  });
  
  /// Convert a Dart file to STAC JSON and write to output
  bool convertFile(String dartFilePath, String outputJsonPath) {
    try {
      if (verbose) {
        print('Parsing ${p.basename(dartFilePath)}...');
      }
      
      final file = File(dartFilePath);
      if (!file.existsSync()) {
        print('Error: File does not exist: $dartFilePath');
        return false;
      }
      
      // Create analysis context
      final contextCollection = AnalysisContextCollection(
        includedPaths: [p.dirname(dartFilePath)],
      );
      
      final context = contextCollection.contextFor(dartFilePath);
      final result = context.currentSession.getParsedUnit(dartFilePath);
      
      if (result is! ParsedUnitResult) {
        print('Error: Failed to parse file: $dartFilePath');
        return false;
      }
      
      // Visit the AST to extract STAC objects
      final visitor = StacObjectVisitor();
      result.unit.visitChildren(visitor);
      
      if (visitor.stacObjects.isEmpty) {
        print('No STAC objects found in the file.');
        return false;
      }
      
      if (verbose) {
        print('Found ${visitor.stacObjects.length} STAC objects in the file.');
      }
      
      // Convert to JSON
      final jsonObjects = visitor.stacObjects.map((obj) => obj.toJson()).toList();
      
      // Write to output file
      final encoder = JsonEncoder.withIndent(formatJson ? '  ' : null);
      final jsonContent = jsonObjects.length == 1 
          ? encoder.convert(jsonObjects.first) 
          : encoder.convert(jsonObjects);
      
      FileUtils.writeJsonToFile(jsonContent, outputJsonPath);
      
      if (verbose) {
        print('Successfully converted ${visitor.stacObjects.length} STAC objects to JSON.');
        print('Output written to: $outputJsonPath');
      }
      
      return true;
    } catch (e) {
      print('Error converting file: $e');
      return false;
    }
  }
}

/// Represents a STAC object extracted from Dart code
class StacObject {
  final String type;
  final Map<String, dynamic> properties;
  
  StacObject({required this.type, required this.properties});
  
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
    };
    
    json.addAll(properties);
    return json;
  }
}

/// Visitor to extract STAC objects from Dart AST
class StacObjectVisitor extends RecursiveAstVisitor<void> {
  final List<StacObject> stacObjects = [];
  
  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    // Skip nodes without initializers
    if (node.initializer == null) {
      return super.visitVariableDeclaration(node);
    }
    
    // Add debug logging for variable name
    print('DEBUG: Found variable: ${node.name.lexeme}');
    print('DEBUG: Initializer type: ${node.initializer.runtimeType}');
    
    // Check for STAC class instance creation
    if (node.initializer is InstanceCreationExpression) {
      final creation = node.initializer as InstanceCreationExpression;
      final typeName = creation.constructorName.type.toString();
      
      print('DEBUG: Variable initialization type: $typeName');
      
      // Look for classes starting with "Stac"
      print('DEBUG: Checking if $typeName starts with "Stac": ${typeName.startsWith("Stac")}');
      if (typeName.startsWith('Stac')) {
        final stacType = _getStacTypeFromClassName(typeName);
        final properties = _extractProperties(creation.argumentList);
        
        stacObjects.add(StacObject(
          type: stacType,
          properties: properties,
        ));
      }
    }
    
    // Check for STAC class method invocation
    else if (node.initializer is MethodInvocation) {
      final methodInvocation = node.initializer as MethodInvocation;
      final target = methodInvocation.target?.toString() ?? '';
      final methodName = methodInvocation.methodName.name;
      
      print('DEBUG: Method invocation - Target: $target, Method: $methodName');
      
      // Look for methods that create STAC objects (e.g., StacContainer, StacText)
      if (target.startsWith('Stac') || methodName.startsWith('Stac')) {
        final stacType = target.startsWith('Stac') ? 
            target.substring(4) : // Remove 'Stac' prefix from target
            methodName.substring(4); // Remove 'Stac' prefix from method name
        
        // Extract properties from method invocation arguments
        final properties = _extractProperties(methodInvocation.argumentList);
        
        stacObjects.add(StacObject(
          type: stacType,
          properties: properties,
        ));
        
        print('DEBUG: Added STAC object from method invocation: $stacType');
      }
    }
    
    super.visitVariableDeclaration(node);
  }
  
  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target?.toString() ?? '';
    final methodName = node.methodName.name;
    
    print('DEBUG: Visiting method invocation - Target: $target, Method: $methodName');
    
    // Look for methods that create STAC objects in target or method name
    if (target.startsWith('Stac') || methodName.startsWith('Stac')) {
      final stacType = target.startsWith('Stac') ? 
          target.substring(4) : // Remove 'Stac' prefix from target
          methodName.substring(4); // Remove 'Stac' prefix from method name
      
      // Extract properties from method invocation arguments
      final properties = _extractProperties(node.argumentList);
      
      stacObjects.add(StacObject(
        type: stacType,
        properties: properties,
      ));
      
      print('DEBUG: Added STAC object from method invocation visitor: $stacType');
    }
    
    super.visitMethodInvocation(node);
  }
  
  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final typeName = node.constructorName.type.toString();
    
    print('DEBUG: Instance creation expression type: $typeName');
    print('DEBUG: Checking if $typeName starts with "Stac": ${typeName.startsWith("Stac")}');
    
    // Look for classes starting with "Stac"
    if (typeName.startsWith('Stac')) {
      final stacType = _getStacTypeFromClassName(typeName);
      final properties = _extractProperties(node.argumentList);
      
      stacObjects.add(StacObject(
        type: stacType,
        properties: properties,
      ));
    }
    
    super.visitInstanceCreationExpression(node);
  }
  
  /// Convert StacClassName to STAC type (e.g., StacContainer -> container)
  String _getStacTypeFromClassName(String className) {
    if (className.startsWith('Stac')) {
      final typeWithoutPrefix = className.substring(4); // Remove 'Stac'
      return typeWithoutPrefix[0].toLowerCase() + typeWithoutPrefix.substring(1);
    }
    return className.toLowerCase();
  }
  
  /// Extract property values from constructor arguments
  Map<String, dynamic> _extractProperties(ArgumentList argumentList) {
    final properties = <String, dynamic>{};
    
    for (final argument in argumentList.arguments) {
      if (argument is NamedExpression) {
        final name = argument.name.label.name;
        final value = _extractValue(argument.expression);
        properties[name] = value;
      }
    }
    
    return properties;
  }
  
  /// Extract a Dart expression value into a JSON-compatible value
  dynamic _extractValue(Expression expression) {
    if (expression is StringLiteral) {
      return expression.stringValue;
    } else if (expression is IntegerLiteral) {
      return expression.value;
    } else if (expression is DoubleLiteral) {
      return expression.value;
    } else if (expression is BooleanLiteral) {
      return expression.value;
    } else if (expression is ListLiteral) {
      return expression.elements
          .where((e) => e is Expression)
          .map((e) => _extractValue(e as Expression))
          .toList();
    } else if (expression is SetOrMapLiteral) {
      final map = <String, dynamic>{};
      // Handle maps differently since the API has changed
      if (expression.elements.isNotEmpty) {
        for (var element in expression.elements) {
          if (element is MapLiteralEntry) {
            final key = _extractValue(element.key);
            final value = _extractValue(element.value);
            if (key is String) {
              map[key] = value;
            }
          }
        }
      }
      return map;
    } else if (expression is InstanceCreationExpression) {
      final typeName = expression.constructorName.type.toString();
      
      // Handle nested STAC objects
      if (typeName.startsWith('Stac')) {
        final stacType = _getStacTypeFromClassName(typeName);
        final properties = _extractProperties(expression.argumentList);
        
        if (typeName == 'StacDouble' && properties.containsKey('value')) {
          return properties['value'];
        } else if (typeName == 'StacEdgeInsets') {
          // Handle special edge insets cases
          if (properties.containsKey('all')) {
            return properties['all'];
          } else {
            final padding = <String, dynamic>{};
            if (properties.containsKey('left')) padding['left'] = properties['left'];
            if (properties.containsKey('top')) padding['top'] = properties['top'];
            if (properties.containsKey('right')) padding['right'] = properties['right'];
            if (properties.containsKey('bottom')) padding['bottom'] = properties['bottom'];
            return padding;
          }
        } else if (typeName == 'StacAlignment' && properties.containsKey('value')) {
          return properties['value'];
        } else {
          // For other nested objects, include type and properties
          return {
            'type': stacType,
            ...properties,
          };
        }
      }
      
      // Handle Color objects
      if (typeName == 'Color') {
        // Try to extract color value
        final args = expression.argumentList.arguments;
        if (args.length == 1 && args[0] is IntegerLiteral) {
          final value = (args[0] as IntegerLiteral).value;
          return '#${value!.toRadixString(16).padLeft(8, '0')}';
        }
      }
      
      return null;
    } else if (expression is PrefixedIdentifier) {
      // Handle constants like Colors.red
      if (expression.prefix.name == 'Colors') {
        return expression.identifier.name;
      }
      return expression.name;
    } else if (expression is PropertyAccess) {
      // Handle property access like Theme.of(context).primaryColor
      return null; // Simplified for now
    } else if (expression is NullLiteral) {
      return null;
    } else {
      // Fallback for other expressions
      return expression.toString();
    }
  }
}
