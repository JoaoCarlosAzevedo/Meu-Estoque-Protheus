import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';

class StreetList extends StatefulWidget {
  const StreetList(
      {Key? key, required this.streetOptions, required this.controller})
      : super(key: key);

  final List<String> streetOptions;
  final TextEditingController controller;

  @override
  _StreetListState createState() => _StreetListState();
}

class _StreetListState extends State<StreetList> {
  late String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.streetOptions.first;
    widget.controller.text = dropdownValue;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.search),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: secondaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.controller.text = dropdownValue;
        });
      },
      items: widget.streetOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyles.titleListTile,
          ),
        );
      }).toList(),
    );
  }
}
