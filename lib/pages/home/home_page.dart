import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/pages/home/home_widgets/menu_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(FontAwesomeIcons.dollyFlatbed),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(FontAwesomeIcons.dollyFlatbed),
            SizedBox(width: 20),
            Text("Meu Estoque"),
          ],
        ),
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            child: MenuGridView(),
          ),
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
