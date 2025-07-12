/// Annotation to mark a widget function for STAC export.
///
/// Use this annotation on functions that return Flutter widgets
/// which should be converted to STAC JSON during build time.
///
/// Example:
/// ```dart
/// @StacExportable()
/// Widget createRedContainer() {
///   return Container(
///     color: Colors.red,
///     child: Text('Hello'),
///   );
/// }
/// ```
class StacExportable {
  /// Optional name to use for the generated JSON file.
  ///
  /// If not provided, the function name will be used.
  final String? name;
  
  /// Constructor for the StacExportable annotation.
  const StacExportable({this.name});
}
