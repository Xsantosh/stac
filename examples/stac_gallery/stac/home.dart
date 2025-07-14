import 'package:flutter/material.dart';

final a = 1;
final b = 2;

Widget homeContainer() {
  return Container(
    alignment: Alignment.center,
    color: Colors.red,
    child: Text((a + b).toString()),
  );
}

class ItemClass extends StatefulWidget {
  const ItemClass({super.key});

  @override
  State<ItemClass> createState() => _ItemClassState();
}

class _ItemClassState extends State<ItemClass> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
          ),
          ElevatedButton(onPressed: () {}, child: Text('Submit')),
        ],
      ),
    );
  }
}
