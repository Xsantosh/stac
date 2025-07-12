// import '../../lib/stac_export_builder.dart';

// part 'widgets.g.dart';

// /// A simple container widget with a red background and text.
// ///
// /// This widget is marked with [StacExportable] to generate STAC JSON during build.
// @StacExportable()
// Widget createRedContainer() {
//   return Container(
//     width: 200,
//     height: 150,
//     color: Colors.red,
//     child: const Text(
//       'Hello STAC Export!',
//       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     ),
//   );
// }

// /// A column with multiple children.
// ///
// /// Using a custom name for the export.
// @StacExportable(name: 'my_column')
// Widget createComplexLayout() {
//   return Container(
//     padding: EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       color: Colors.blue[100],
//       borderRadius: BorderRadius.circular(8.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.2),
//           offset: Offset(0, 2),
//           blurRadius: 4.0,
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         Text(
//           'STAC Export Example',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 16),
//         Container(
//           color: Colors.green[300],
//           padding: EdgeInsets.all(8.0),
//           child: Text('Nested container'),
//         ),
//       ],
//     ),
//   );
// }
