/// Base class for all STAC widgets.
///
/// This abstract class provides the foundation for all STAC widgets,
/// including the ability to convert to JSON.
abstract class StacWidget {
  /// The type identifier for the widget.
  ///
  /// This is used in the JSON output to identify the type of widget.
  String get type;

  /// Converts the widget to a JSON representation.
  ///
  /// This method should be overridden by subclasses to provide
  /// the proper JSON structure for each widget type.
  Map<String, dynamic> toJson();

  /// Helper method to convert a StacWidget child to JSON or null.
  ///
  /// This is useful for widgets that have optional child widgets.
  static Map<String, dynamic>? childToJson(StacWidget? child) {
    return child?.toJson();
  }

  /// Helper method to convert a list of StacWidget children to JSON.
  ///
  /// This is useful for widgets that have a list of children.
  static List<Map<String, dynamic>> childrenToJson(List<StacWidget>? children) {
    return children
            ?.map((widget) => widget.toJson())
            .toList() ??
        [];
  }
}
