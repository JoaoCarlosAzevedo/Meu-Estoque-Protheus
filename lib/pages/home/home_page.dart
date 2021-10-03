import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/menu_model.dart';
import 'package:meuestoque_protheus/pages/home/home_widgets/menu_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: MenuGridView(),
        ),
      ),
    );
  }
}

class MenuGridView extends StatelessWidget {
  const MenuGridView({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: menuItens.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        //childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => MenuCard(info: menuItens[index]),
    );
  }
}
