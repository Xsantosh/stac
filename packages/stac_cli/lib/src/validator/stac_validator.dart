import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

/// Result of a validation operation
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, this.errors = const []});
}

/// Validates Dart STAC code files
class StacValidator {
  final bool verbose;
  
  StacValidator({this.verbose = false});

  /// Validates a Dart file to ensure it contains proper STAC model classes
  ValidationResult validateFile(String filePath) {
    final errors = <String>[];
    
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return ValidationResult(
          isValid: false, 
          errors: ['File does not exist: $filePath']
        );
      }
      
      // Create analysis context
      final contextCollection = AnalysisContextCollection(
        includedPaths: [p.dirname(filePath)],
      );
      
      final context = contextCollection.contextFor(filePath);
      final result = context.currentSession.getParsedUnit(filePath);
      
      if (result is! ParsedUnitResult) {
        return ValidationResult(
          isValid: false,
          errors: ['Failed to parse file: $filePath'],
        );
      }
      
      // Visit the AST to check for STAC classes
      final visitor = _StacClassVisitor();
      result.unit.visitChildren(visitor);
      
      if (visitor.stacClasses.isEmpty) {
        errors.add('No STAC model classes found in the file.');
      }
      
      // Validate each STAC class
      for (final stacClass in visitor.stacClasses) {
        // Check for fromJson factory
        if (!stacClass.hasFromJsonFactory) {
          errors.add('STAC class ${stacClass.name} missing fromJson factory method');
        }
        
        // Check for toJson method
        if (!stacClass.hasToJsonMethod) {
          errors.add('STAC class ${stacClass.name} missing toJson method');
        }
      }
      
      return ValidationResult(
        isValid: errors.isEmpty,
        errors: errors,
      );
    } catch (e) {
      return ValidationResult(
        isValid: false,
        errors: ['Error validating file: $e'],
      );
    }
  }
}

/// Information about a STAC class found in the AST
class _StacClassInfo {
  final String name;
  bool hasFromJsonFactory = false;
  bool hasToJsonMethod = false;
  
  _StacClassInfo(this.name);
}

/// Visitor to find STAC classes in the AST
class _StacClassVisitor extends RecursiveAstVisitor<void> {
  final List<_StacClassInfo> stacClasses = [];
  
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Check if the class name starts with "Stac"
    final className = node.name.lexeme;
    if (className.startsWith('Stac')) {
      final classInfo = _StacClassInfo(className);
      
      // Check for fromJson factory method
      for (final member in node.members) {
        if (member is ConstructorDeclaration && 
            member.factoryKeyword != null &&
            member.name?.lexeme == 'fromJson') {
          classInfo.hasFromJsonFactory = true;
        }
        
        // Check for toJson method
        if (member is MethodDeclaration && member.name.lexeme == 'toJson') {
          classInfo.hasToJsonMethod = true;
        }
      }
      
      stacClasses.add(classInfo);
    }
    
    super.visitClassDeclaration(node);
  }
}
