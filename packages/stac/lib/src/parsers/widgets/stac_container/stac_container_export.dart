import 'package:flutter/material.dart';
import 'package:stac/src/framework/stac_exporter.dart';
import 'package:stac/src/utils/widget_type.dart';
import 'package:stac/stac.dart';

class StacContainerExport extends StacExport<Container> {
  const StacContainerExport();

  @override
  String get type => WidgetType.container.name;

  @override
  Type get widget => Container;

  @override
  Map<String, dynamic> toStacJson(Container widget) {
    final Map<String, dynamic> json = {
      'type': type,
    };

    // Handle alignment
    if (widget.alignment != null) {
      json['alignment'] = _convertAlignment(widget.alignment!);
    }

    // Handle padding
    if (widget.padding != null) {
      json['padding'] = _convertEdgeInsets(widget.padding!);
    }

    // Handle decoration
    if (widget.decoration != null) {
      json['decoration'] = _convertDecoration(widget.decoration!);
    }

    // Handle foregroundDecoration
    if (widget.foregroundDecoration != null) {
      json['foregroundDecoration'] =
          _convertDecoration(widget.foregroundDecoration!);
    }

    // Handle color - only if decoration is null
    if (widget.color != null && widget.decoration == null) {
      json['color'] = _colorToHex(widget.color!);
    }

    // Handle width and height
    if (widget.constraints != null) {
      if (widget.constraints!.maxWidth.isFinite &&
          widget.constraints!.maxWidth == widget.constraints!.minWidth) {
        json['width'] = {'value': widget.constraints!.maxWidth};
      }

      if (widget.constraints!.maxHeight.isFinite &&
          widget.constraints!.maxHeight == widget.constraints!.minHeight) {
        json['height'] = {'value': widget.constraints!.maxHeight};
      }

      // Handle general constraints if they don't represent fixed width/height
      if (!((widget.constraints!.maxWidth.isFinite &&
              widget.constraints!.maxWidth == widget.constraints!.minWidth) &&
          (widget.constraints!.maxHeight.isFinite &&
              widget.constraints!.maxHeight ==
                  widget.constraints!.minHeight))) {
        json['constraints'] = _convertConstraints(widget.constraints!);
      }
    }

    // Handle margin
    if (widget.margin != null) {
      json['margin'] = _convertEdgeInsets(widget.margin!);
    }

    // Handle child widget
    if (widget.child != null) {
      // Use the StacExporter singleton to recursively export the child widget
      final childJson = StacExporter.instance.exportWidget(widget.child!);
      if (childJson != null) {
        json['child'] = childJson;
      } else {
        // Fallback to empty object if child couldn't be exported
        json['child'] = {};
      }
    }

    // Handle clipBehavior if it's not the default value (Clip.none)
    if (widget.clipBehavior != Clip.none) {
      json['clipBehavior'] = widget.clipBehavior.name;
    }

    return json;
  }

  // Helper methods
  Map<String, dynamic> _convertAlignment(AlignmentGeometry alignment) {
    if (alignment is Alignment) {
      return {'x': alignment.x, 'y': alignment.y};
    } else {
      // Handle other alignment types or return a default
      return {'type': 'alignment'};
    }
  }

  Map<String, dynamic> _convertEdgeInsets(EdgeInsetsGeometry edgeInsets) {
    if (edgeInsets is EdgeInsets) {
      return {
        'left': edgeInsets.left,
        'top': edgeInsets.top,
        'right': edgeInsets.right,
        'bottom': edgeInsets.bottom
      };
    } else if (edgeInsets is EdgeInsetsDirectional) {
      return {
        'start': edgeInsets.start,
        'top': edgeInsets.top,
        'end': edgeInsets.end,
        'bottom': edgeInsets.bottom
      };
    } else {
      // For other types, return a placeholder
      return {'type': 'edge_insets'};
    }
  }

  Map<String, dynamic> _convertDecoration(Decoration decoration) {
    if (decoration is BoxDecoration) {
      final Map<String, dynamic> decorationJson = {};

      // Convert color
      if (decoration.color != null) {
        decorationJson['color'] = _colorToHex(decoration.color!);
      }

      // Convert border
      if (decoration.border != null) {
        decorationJson['border'] = _convertBorder(decoration.border!);
      }

      // Convert borderRadius
      if (decoration.borderRadius != null) {
        decorationJson['borderRadius'] =
            _convertBorderRadius(decoration.borderRadius!);
      }

      // Convert boxShadow
      if (decoration.boxShadow != null && decoration.boxShadow!.isNotEmpty) {
        decorationJson['boxShadow'] = decoration.boxShadow!
            .map((shadow) => _convertBoxShadow(shadow))
            .toList();
      }

      // Convert gradient
      if (decoration.gradient != null) {
        decorationJson['gradient'] = _convertGradient(decoration.gradient!);
      }

      // Convert shape
      decorationJson['shape'] = decoration.shape.toString().split('.').last;

      return decorationJson;
    } else {
      // For other decoration types, return a placeholder
      return {'type': 'decoration'};
    }
  }

  Map<String, dynamic> _convertConstraints(BoxConstraints constraints) {
    return {
      'minWidth': constraints.minWidth,
      'maxWidth': constraints.maxWidth.isFinite ? constraints.maxWidth : null,
      'minHeight': constraints.minHeight,
      'maxHeight': constraints.maxHeight.isFinite ? constraints.maxHeight : null
    };
  }

  Map<String, dynamic> _convertBorder(BoxBorder border) {
    if (border is Border) {
      return {
        'top': border.top.width > 0
            ? {
                'width': border.top.width,
                'color': _colorToHex(border.top.color)
              }
            : null,
        'right': border.right.width > 0
            ? {
                'width': border.right.width,
                'color': _colorToHex(border.right.color)
              }
            : null,
        'bottom': border.bottom.width > 0
            ? {
                'width': border.bottom.width,
                'color': _colorToHex(border.bottom.color)
              }
            : null,
        'left': border.left.width > 0
            ? {
                'width': border.left.width,
                'color': _colorToHex(border.left.color)
              }
            : null,
      };
    } else if (border is BorderDirectional) {
      return {
        'top': border.top.width > 0
            ? {
                'width': border.top.width,
                'color': _colorToHex(border.top.color)
              }
            : null,
        'start': border.start.width > 0
            ? {
                'width': border.start.width,
                'color': _colorToHex(border.start.color)
              }
            : null,
        'end': border.end.width > 0
            ? {
                'width': border.end.width,
                'color': _colorToHex(border.end.color)
              }
            : null,
        'bottom': border.bottom.width > 0
            ? {
                'width': border.bottom.width,
                'color': _colorToHex(border.bottom.color)
              }
            : null,
      };
    } else {
      return {'type': 'border'};
    }
  }

  Map<String, dynamic> _convertBorderRadius(BorderRadiusGeometry borderRadius) {
    if (borderRadius is BorderRadius) {
      return {
        'topLeft': {'x': borderRadius.topLeft.x, 'y': borderRadius.topLeft.y},
        'topRight': {
          'x': borderRadius.topRight.x,
          'y': borderRadius.topRight.y
        },
        'bottomLeft': {
          'x': borderRadius.bottomLeft.x,
          'y': borderRadius.bottomLeft.y
        },
        'bottomRight': {
          'x': borderRadius.bottomRight.x,
          'y': borderRadius.bottomRight.y
        },
      };
    } else {
      return {'type': 'border_radius'};
    }
  }

  Map<String, dynamic> _convertBoxShadow(BoxShadow shadow) {
    return {
      'color': _colorToHex(shadow.color),
      'offset': {'dx': shadow.offset.dx, 'dy': shadow.offset.dy},
      'blurRadius': shadow.blurRadius,
      'spreadRadius': shadow.spreadRadius
    };
  }

  Map<String, dynamic> _convertGradient(Gradient gradient) {
    if (gradient is LinearGradient) {
      return {
        'type': 'linear',
        'begin': _convertAlignment(gradient.begin),
        'end': _convertAlignment(gradient.end),
        'colors': gradient.colors.map((color) => _colorToHex(color)).toList(),
        'stops': gradient.stops
      };
    } else if (gradient is RadialGradient) {
      return {
        'type': 'radial',
        'center': _convertAlignment(gradient.center),
        'radius': gradient.radius,
        'colors': gradient.colors.map((color) => _colorToHex(color)).toList(),
        'stops': gradient.stops
      };
    } else if (gradient is SweepGradient) {
      return {
        'type': 'sweep',
        'center': _convertAlignment(gradient.center),
        'startAngle': gradient.startAngle,
        'endAngle': gradient.endAngle,
        'colors': gradient.colors.map((color) => _colorToHex(color)).toList(),
        'stops': gradient.stops
      };
    } else {
      return {'type': 'gradient'};
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
