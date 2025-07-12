import 'package:flutter/widgets.dart';
import 'package:stac/src/utils/widget_type.dart';
import 'package:stac/stac.dart';

class StacTextExport extends StacExport<Text> {
  const StacTextExport();

  @override
  String get type => WidgetType.text.name;

  @override
  Type get widget => Text;

  @override
  Map<String, dynamic> toStacJson(Text widget) {
    final Map<String, dynamic> json = {
      'type': type,
      'data': widget.data ?? '',
    };

    // Handle text style conversion
    if (widget.style != null) {
      json['style'] = _textStyleToJson(widget.style!);
    }

    // Handle basic properties
    if (widget.textAlign != null) {
      json['textAlign'] = widget.textAlign!.name;
    }

    if (widget.textDirection != null) {
      json['textDirection'] = widget.textDirection!.name;
    }

    if (widget.softWrap != null) {
      json['softWrap'] = widget.softWrap;
    }

    if (widget.overflow != null) {
      json['overflow'] = widget.overflow!.name;
    }

    // Handle deprecated textScaleFactor or new textScaler
    if (widget.textScaler != null) {
      // For TextScaler we'll use a placeholder value since we can't
      // directly extract the scale factor from all TextScaler implementations
      // In a real implementation, we might need a more sophisticated approach
      json['textScaler'] = {}; // Indicate that textScaler is present
    } else if (widget.textScaleFactor != null) {
      // Handle deprecated textScaleFactor directly
      json['textScaleFactor'] = {'value': widget.textScaleFactor};
    }

    if (widget.maxLines != null) {
      json['maxLines'] = widget.maxLines;
    }

    if (widget.semanticsLabel != null) {
      json['semanticsLabel'] = widget.semanticsLabel;
    }

    if (widget.textWidthBasis != null) {
      json['textWidthBasis'] = widget.textWidthBasis!.name;
    }

    if (widget.selectionColor != null) {
      json['selectionColor'] = _colorToHex(widget.selectionColor!);
    }

    // Handle textSpan if present (for Text.rich constructor)
    if (widget.textSpan != null) {
      json['children'] = _convertTextSpan(widget.textSpan!);
    }

    return json;
  }

  // Helper method to convert TextStyle to JSON
  Map<String, dynamic>? _textStyleToJson(TextStyle style) {
    final Map<String, dynamic> styleJson = {};

    if (style.color != null) {
      styleJson['color'] = _colorToHex(style.color!);
    }

    if (style.fontSize != null) {
      styleJson['fontSize'] = style.fontSize;
    }

    if (style.fontWeight != null) {
      styleJson['fontWeight'] = style.fontWeight!.value;
    }

    if (style.fontStyle != null) {
      styleJson['fontStyle'] = style.fontStyle!.name;
    }

    if (style.letterSpacing != null) {
      styleJson['letterSpacing'] = style.letterSpacing;
    }

    if (style.wordSpacing != null) {
      styleJson['wordSpacing'] = style.wordSpacing;
    }

    if (style.height != null) {
      styleJson['height'] = style.height;
    }

    if (style.decoration != null) {
      styleJson['decoration'] = style.decoration!.toString();
    }

    if (style.decorationColor != null) {
      styleJson['decorationColor'] = _colorToHex(style.decorationColor!);
    }

    if (style.decorationStyle != null) {
      styleJson['decorationStyle'] = style.decorationStyle!.name;
    }

    if (style.decorationThickness != null) {
      styleJson['decorationThickness'] = style.decorationThickness;
    }

    if (style.fontFamily != null) {
      styleJson['fontFamily'] = style.fontFamily;
    }

    return styleJson.isNotEmpty ? styleJson : null;
  }

  // Helper method to convert TextSpan to list of StacTextSpan
  List<Map<String, dynamic>> _convertTextSpan(InlineSpan span) {
    final List<Map<String, dynamic>> result = [];

    if (span is TextSpan) {
      final Map<String, dynamic> spanJson = {};

      if (span.text != null) {
        spanJson['data'] = span.text;
      }

      if (span.style != null) {
        spanJson['style'] = _textStyleToJson(span.style!);
      }

      if (span.recognizer != null) {
        // For tap gestures we just indicate that there is a tap action
        // The actual action would be handled separately
        spanJson['onTap'] = {};
      }

      if (spanJson.isNotEmpty) {
        result.add(spanJson);
      }

      // Process children recursively
      if (span.children != null && span.children!.isNotEmpty) {
        for (final InlineSpan child in span.children!) {
          result.addAll(_convertTextSpan(child));
        }
      }
    } else if (span is WidgetSpan) {
      // For widget spans, we would need widget exporter integration
      // This is a placeholder as widget spans require their own exporters
      result.add({
        'type': 'widgetSpan',
        // Child widget would need its own export logic
      });
    }

    return result;
  }

  // Helper to convert Color to hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
