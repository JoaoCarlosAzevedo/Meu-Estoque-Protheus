import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';

class EpcColetor extends StatefulWidget {
  const EpcColetor({Key? key}) : super(key: key);

  @override
  _EpcColetorState createState() => _EpcColetorState();
}

class _EpcColetorState extends State<EpcColetor> {
  get secondaryColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "EPC",
                        fillColor: secondaryColor,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding * 1.2),
                      margin: const EdgeInsets.only(left: defaultPadding),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Icon(Icons.delete_forever),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
