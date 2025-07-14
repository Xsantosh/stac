import '../core/stac_widget.dart';

/// A STAC Elevated Button widget.
///
/// This widget represents an elevated button in the STAC framework.
class StacElevatedButton extends StacWidget {
  /// The child widget displayed inside the button.
  final StacWidget child;
  
  /// Whether the button has an onPressed handler.
  ///
  /// In STAC JSON, this is represented by the "hasOnPressed" property.
  final bool hasOnPressed;
  
  /// Creates a [StacElevatedButton] with the given properties.
  ///
  /// The [child] parameter is required and represents the widget to display
  /// inside the button.
  /// The [hasOnPressed] parameter indicates whether the button has an onPressed handler.
  StacElevatedButton({
    required this.child,
    this.hasOnPressed = true,
  });
  
  @override
  String get type => 'elevatedButton';
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'child': child.toJson(),
      'hasOnPressed': hasOnPressed,
    };
  }
}
