import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/menu_model.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({Key? key, required this.info}) : super(key: key);

  final MenuItem info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/' + info.route);

        /*        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WarehousePage())); */
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  //padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  //child: const Icon(Icons.access_alarm),
                  child: Center(child: FaIcon(info.icon)),
                ),
                //const Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.numOfFiles} Files",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  info.totalStorage!,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white),
                ),
              ],
            ) */
          ],
        ),
      ),
    );
  }
}
