import '../core/stac_widget.dart';

/// A STAC Container widget.
///
/// This widget can be used as a layout container with properties such as width, height,
/// color, and can contain a child widget.
class StacContainer extends StacWidget {
  /// The width of the container.
  final double? width;
  
  /// The height of the container.
  final double? height;
  
  /// The background color of the container.
  /// 
  /// This should be a hex color string (e.g., "#FF0000" for red).
  final String? color;
  
  /// The child widget contained within this container.
  final StacWidget? child;
  
  /// Creates a [StacContainer] with the given properties.
  StacContainer({
    this.width,
    this.height,
    this.color,
    this.child,
  });
  
  @override
  String get type => 'container';
  
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'type': type,
    };
    
    if (width != null) {
      json['width'] = width;
    }
    
    if (height != null) {
      json['height'] = height;
    }
    
    if (color != null) {
      json['color'] = color;
    }
    
    if (child != null) {
      json['child'] = child!.toJson();
    }
    
    return json;
  }
}
