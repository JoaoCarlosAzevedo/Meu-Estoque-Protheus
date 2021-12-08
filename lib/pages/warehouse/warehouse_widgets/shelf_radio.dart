import 'package:flutter/material.dart';

class ShelfOptions extends StatefulWidget {
  const ShelfOptions(
      {Key? key, required this.options, required this.controller})
      : super(key: key);
  final List<String> options;
  final TextEditingController controller;
  @override
  _ShelfOptionsState createState() => _ShelfOptionsState();
}

class _ShelfOptionsState extends State<ShelfOptions> {
  late String _character;

  @override
  void initState() {
    _character = widget.options.first;
    widget.controller.text = _character;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.options.map((item) {
          return Row(
            children: [
              Text(item),
              Radio<String>(
                value: item,
                groupValue: _character,
                onChanged: (String? value) {
                  setState(() {
                    _character = value!;
                    widget.controller.text = _character;
                  });
                },
              ),
            ],
          );
        }).toList());
  }
}
