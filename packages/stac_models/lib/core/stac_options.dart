class StacOptions {
  const StacOptions({
    required this.name,
    this.description,
    required this.projectId,
    this.apiKey,
    this.sourceDir = '/stac/',
    this.outputDir = '/stac/.build',
  });

  /// Project name
  final String name;

  /// Project description
  final String? description;

  /// Project ID
  final String projectId;

  /// API key
  final String? apiKey;

  /// Source directory path
  final String sourceDir;

  /// Output directory path
  final String outputDir;
}
