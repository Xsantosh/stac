import 'dart:io';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

/// Utilities for file operations
class FileUtils {
  /// Find all Dart files in a directory
  static List<File> findDartFiles(String directory) {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      return [];
    }

    final dartFiles = <File>[];
    final dartGlob = Glob('**.dart');
    
    final allFiles = dir.listSync(recursive: true, followLinks: false);
    
    for (final entity in allFiles) {
      if (entity is File && 
          dartGlob.matches(p.relative(entity.path, from: directory))) {
        dartFiles.add(entity);
      }
    }
    
    return dartFiles;
  }
  
  /// Ensures a directory exists, creating it if necessary
  static Directory ensureDirectoryExists(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }
  
  /// Gets the output JSON path for a given Dart file
  static String getOutputPath(String dartFilePath, String outputDir) {
    final fileName = p.basenameWithoutExtension(dartFilePath);
    return p.join(outputDir, '$fileName.json');
  }
  
  /// Writes JSON content to a file
  static void writeJsonToFile(String content, String filePath) {
    final file = File(filePath);
    file.writeAsStringSync(content);
  }
}
