import 'package:flutter/widgets.dart';
import 'package:stac/src/framework/stac_registry.dart';
import 'package:stac_framework/stac_framework.dart';
import 'package:stac_logger/stac_logger.dart';

/// StacExporter is responsible for converting Flutter widgets to STAC JSON format
/// It leverages the StacRegistry for managing exporters and provides methods to export widgets.
class StacExporter {
  StacExporter._internal();

  static final StacExporter _instance = StacExporter._internal();

  /// Factory constructor to return the singleton instance.
  factory StacExporter() => _instance;

  /// Access the singleton instance.
  static StacExporter get instance => _instance;

  /// Map of widget types to their exporters - maintained in memory for quick type lookup
  final Map<Type, StacExport> _widgetTypeToExporter = <Type, StacExport>{};

  /// Registers a single exporter using StacRegistry.
  ///
  /// Returns true if the exporter was successfully registered,
  /// false if an exporter for the same widget type already exists and override is false.
  bool register(StacExport exporter, [bool override = false]) {
    final Type widgetType = exporter.widget;
    final String type = exporter.type;

    // Check if this widget type is already registered in our local map
    if (_widgetTypeToExporter.containsKey(widgetType) && !override) {
      Log.w('Exporter for ${widgetType.toString()} is already registered');
      return false;
    }

    // Use a special key format to store in StacRegistry
    final String exporterKey = 'stac_exporter:${widgetType.toString()}';

    // Store in StacRegistry for global access
    StacRegistry.instance.setValue(exporterKey, exporter);

    // Also keep in our local type map for quick type-based lookups
    _widgetTypeToExporter[widgetType] = exporter;

    Log.i('Registered exporter for $type (${widgetType.toString()})');
    return true;
  }

  /// Registers multiple exporters at once.
  ///
  /// Returns a Future that completes when all exporters have been registered.
  Future<void> registerAll(List<StacExport> exporters,
      [bool override = false]) async {
    for (final exporter in exporters) {
      register(exporter, override);
    }
  }

  /// Gets an exporter for a specific widget type.
  ///
  /// Returns null if no exporter is registered for the given type.
  StacExport<T>? getExporter<T extends Widget>(Type type) {
    return _widgetTypeToExporter[type] as StacExport<T>?;
  }

  /// Gets an exporter by its type string.
  ///
  /// Returns null if no exporter is registered for the given type string.
  StacExport? getExporterByType(String type) {
    // Search through all registered exporters to find one with matching type
    for (final exporter in _widgetTypeToExporter.values) {
      if (exporter.type == type) {
        return exporter;
      }
    }
    return null;
  }

  /// Exports a widget to STAC JSON format.
  ///
  /// Returns the JSON representation of the widget, or null if no exporter
  /// is registered for the widget's type.
  Map<String, dynamic>? exportWidget(Widget widget) {
    final exporter = getExporter(widget.runtimeType);
    if (exporter == null) {
      Log.w('No exporter found for ${widget.runtimeType}');
      return null;
    }

    try {
      return exporter.toStacJson(widget);
    } catch (e) {
      Log.e('Error exporting ${widget.runtimeType}: $e');
      return null;
    }
  }

  /// Recursively exports a widget and its children to STAC JSON.
  ///
  /// This method attempts to export the widget tree by traversing it depth-first.
  /// Returns a JSON representation of the widget tree, or null if the root widget
  /// cannot be exported.
  Map<String, dynamic>? exportWidgetTree(Widget widget) {
    // Export the current widget
    final Map<String, dynamic>? json = exportWidget(widget);
    if (json == null) return null;

    // Handle specific widget types with children
    if (widget is SingleChildRenderObjectWidget && widget.child != null) {
      final childJson = exportWidgetTree(widget.child!);
      if (childJson != null) {
        json['child'] = childJson;
      }
    } else if (widget is MultiChildRenderObjectWidget) {
      final List<Map<String, dynamic>> children = [];
      for (final child in widget.children) {
        final childJson = exportWidgetTree(child);
        if (childJson != null) {
          children.add(childJson);
        }
      }
      if (children.isNotEmpty) {
        json['children'] = children;
      }
    }

    return json;
  }

  /// Clears all registered exporters.
  void clear() {
    // Clear our local map
    final List<Type> registeredTypes =
        List<Type>.from(_widgetTypeToExporter.keys);

    // Remove all exporter entries from the StacRegistry
    for (final type in registeredTypes) {
      final String exporterKey = 'stac_exporter:${type.toString()}';
      StacRegistry.instance.removeValue(exporterKey);
    }

    // Clear our local map
    _widgetTypeToExporter.clear();
  }
}
