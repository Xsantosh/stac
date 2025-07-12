import 'package:flutter/material.dart';
import 'package:stac/src/framework/stac_exporter.dart';
import 'package:stac/src/utils/widget_type.dart';
import 'package:stac_framework/stac_framework.dart';

class StacElevatedButtonExport extends StacExport<ElevatedButton> {
  const StacElevatedButtonExport();

  @override
  String get type => WidgetType.elevatedButton.name;

  @override
  Type get widget => ElevatedButton;

  @override
  Map<String, dynamic> toStacJson(ElevatedButton widget) {
    final json = <String, dynamic>{
      'type': type,
    };

    // Export child widget if present
    if (widget.child != null) {
      final childJson = StacExporter.instance.exportWidget(widget.child!);
      if (childJson != null) {
        json['child'] = childJson;
      }
    }

    // Export style properties
    if (widget.style != null) {
      final styleJson = <String, dynamic>{};

      // Background color
      final bgColor = widget.style?.backgroundColor?.resolve({});
      if (bgColor != null) {
        styleJson['backgroundColor'] = {
          'r': bgColor.red,
          'g': bgColor.green,
          'b': bgColor.blue,
          'a': bgColor.alpha / 255.0,
        };
      }

      // Foreground color
      final fgColor = widget.style?.foregroundColor?.resolve({});
      if (fgColor != null) {
        styleJson['foregroundColor'] = {
          'r': fgColor.red,
          'g': fgColor.green,
          'b': fgColor.blue,
          'a': fgColor.alpha / 255.0,
        };
      }

      // Padding
      final padding = widget.style?.padding?.resolve({});
      if (padding != null) {
        // Need to handle specific EdgeInsets types
        if (padding is EdgeInsets) {
          styleJson['padding'] = {
            'left': padding.left,
            'top': padding.top,
            'right': padding.right,
            'bottom': padding.bottom,
          };
        }
      }

      // Add shape information if available
      final shape = widget.style?.shape?.resolve({});
      if (shape != null && shape is RoundedRectangleBorder) {
        final borderRadius = shape.borderRadius;
        // Need to handle specific BorderRadius types
        if (borderRadius is BorderRadius) {
          styleJson['shape'] = {
            'type': 'roundedRectangle',
            'borderRadius': {
              'topLeft': borderRadius.topLeft.x,
              'topRight': borderRadius.topRight.x,
              'bottomLeft': borderRadius.bottomLeft.x,
              'bottomRight': borderRadius.bottomRight.x,
            },
          };
        } else {
          styleJson['shape'] = {
            'type': 'roundedRectangle',
          };
        }
      }

      // Add the style to the JSON if we have any style properties
      if (styleJson.isNotEmpty) {
        json['style'] = styleJson;
      }
    }

    // We can't serialize the actual onPressed function, but we can indicate if it's present
    json['hasOnPressed'] = widget.onPressed != null;

    return json;
  }
}
