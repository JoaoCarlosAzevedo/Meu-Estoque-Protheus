import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/core/widgets/reader/input_no_keyboard.dart';

import '../../constants.dart';

class TagReader extends StatefulWidget {
  const TagReader({Key? key}) : super(key: key);
  @override
  State<TagReader> createState() => _TagReaderState();
}

class _TagReaderState extends State<TagReader> {
  Set<String> tags = <String>{};
  final TextEditingController _controller = TextEditingController();
  final focusNode = InputWithKeyboardControlv2FocusNode();

  void _deleteAll() {
    setState(() {
      tags.clear();
    });
    focusNode.requestFocus();
  }

  _deleteItem(String tag) {
    setState(() {
      tags.removeWhere((element) => element == tag);
    });
  }

  void _handleChange(String value) {
    final delimitedTags = value.split('EPC');

    print('onChange: $value');

    delimitedTags.remove('');

    setState(() {
      tags.addAll(delimitedTags);
    });
    _controller.clear();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.center_focus_strong_outlined)),
                Tab(icon: Icon(Icons.assignment_sharp)),
              ],
            ),
            centerTitle: true,
            title: const Text('Coletor de Etiquetas'),
          ),
          body: TabBarView(
            children: [
              _tab1(),
              _tab2(),
            ],
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(tags.toList());
            },
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab1() {
    focusNode.requestFocus();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputWithKeyboardControlv2(
            focusNode: focusNode,
            autofocus: false,
            onChanged: _handleChange,
            onSubmitted: _handleChange,
            controller: _controller,
            width: 15,
            startShowKeyboard: false,
            buttonColorEnabled: Colors.blue,
            buttonColorDisabled: Colors.black,
            underlineColor: Colors.black,
            showUnderline: false,
            showButton: false,
            cursorColor: Colors.white,
          ),
          Text("Etiquetas Coletadas", style: TextStyles.titleHome),
          Text(
            '${tags.length}',
            style: TextStyles.tagCounter,
          ),
        ],
      ),
    );
  }

  Widget _tab2() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Etiquetas Lidas: ${tags.length}'),
            IconButton(
              onPressed: _deleteAll,
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: ListView.builder(
              itemCount: tags.length,
              itemBuilder: (BuildContext context, int index) {
                var allTags = tags.toList();
                return ListTile(
                  title: Text(allTags[index]),
                  visualDensity: VisualDensity.compact,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      _deleteItem(allTags[index]);
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
