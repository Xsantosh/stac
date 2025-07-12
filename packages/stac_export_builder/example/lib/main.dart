// import 'dart:convert';
// import 'package:flutter/material.dart';

// // Import our example widgets
// import 'example_widgets.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'STAC Export Example',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const ExportExampleScreen(),
//     );
//   }
// }

// class ExportExampleScreen extends StatefulWidget {
//   const ExportExampleScreen({super.key});

//   @override
//   State<ExportExampleScreen> createState() => _ExportExampleScreenState();
// }

// class _ExportExampleScreenState extends State<ExportExampleScreen> {
//   // JSON representation of the exported widgets
//   String _jsonOutput = '';

//   @override
//   void initState() {
//     super.initState();
    
//     // In a real app, this would happen during build time
//     // and the generated code would be imported
//     _loadStacExports();
//   }

//   void _loadStacExports() {
//     try {
//       // In a real app, this would be imported from the generated code:
//       // import 'example_widgets.g.dart';
//       // final jsonOutput = stacExports;
      
//       // For demonstration, we'll show a mock of what would be generated
//       final mockGeneratedExports = {
//         'createRedContainer': {
//           'type': 'container',
//           'width': 200,
//           'height': 150,
//           'color': {'type': 'color', 'name': 'red'},
//           'child': {
//             'type': 'text',
//             'data': 'Hello STAC Export!',
//             'style': {
//               'type': 'TextStyle',
//               'fontSize': 18,
//               'fontWeight': {'type': 'fontWeight', 'value': 'bold'},
//             }
//           }
//         },
//         'my_column': {
//           'type': 'container',
//           'padding': {
//             'type': 'edgeInsets',
//             'method': 'all',
//             'arguments': [16.0]
//           },
//           'decoration': {
//             'type': 'BoxDecoration',
//             'color': 'Colors.blue[100]',
//             'borderRadius': {
//               'type': 'borderRadius',
//               'method': 'circular',
//               'arguments': [8.0]
//             },
//             'boxShadow': [
//               {
//                 'type': 'BoxShadow',
//                 'color': 'Colors.black.withOpacity(0.2)',
//                 'offset': 'Offset(0, 2)',
//                 'blurRadius': 4.0
//               }
//             ]
//           },
//           'child': {
//             'type': 'column',
//             'children': [
//               {
//                 'type': 'text',
//                 'data': 'STAC Export Example',
//                 'style': {
//                   'type': 'TextStyle',
//                   'fontSize': 20,
//                   'fontWeight': {'type': 'fontWeight', 'value': 'bold'}
//                 }
//               },
//               {'type': 'SizedBox', 'height': 16},
//               {
//                 'type': 'container',
//                 'color': 'Colors.green[300]',
//                 'padding': {
//                   'type': 'edgeInsets',
//                   'method': 'all',
//                   'arguments': [8.0]
//                 },
//                 'child': {'type': 'text', 'data': 'Nested container'}
//               }
//             ]
//           }
//         }
//       };

//       setState(() {
//         _jsonOutput = const JsonEncoder.withIndent('  ').convert(mockGeneratedExports);
//       });
//     } catch (e) {
//       setState(() {
//         _jsonOutput = 'Error loading exports: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('STAC Export Example'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Live Widgets:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
            
//             // Display the actual widgets
//             Row(
//               children: [
//                 createRedContainer(),
//                 const SizedBox(width: 16),
//                 Flexible(
//                   child: SizedBox(
//                     width: 300,
//                     child: createComplexLayout(),
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 32),
//             const Text(
//               'Generated STAC JSON:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
            
//             // Display the JSON
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     _jsonOutput,
//                     style: const TextStyle(fontFamily: 'monospace'),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
