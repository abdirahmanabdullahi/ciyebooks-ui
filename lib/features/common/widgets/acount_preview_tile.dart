import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class AccountPreviewTile extends StatelessWidget {
  const AccountPreviewTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.titleHeight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabled: true,
      selected: true,
      selectedTileColor: Colors.white,
      // leading: Container(
      //   width: 35,
      //   height: 35,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(30),
      //       border: Border.all(width: 1, color: AppColors.darkGrey)),
      //   child: Center(
      //     child: Text(
      //       "AA",
      //       style: Theme.of(context)
      //           .textTheme
      //           .bodyLarge!
      //           .apply(color: Colors.blueAccent),
      //     ),
      //   ),
      // ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Abdirahman Abdullahi",
            style: TextStyle(
                // fontFamily: "Oswald",
                color: AppColors.prettyDark,
                fontSize: 25,
                height: 1.2),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
                color: AppColors.darkGrey,
              )),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Account no:    ",
                  style:TextStyle(color: Colors.black54)
                ),
                TextSpan(
                  text: "23436467867",
                  style:TextStyle(color: CupertinoColors.systemBlue,fontSize: 16)
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Phone no:       ",
                  style: TextStyle(color: Colors.black54)
                ),
                TextSpan(
                  text: "0700905900",
                    style:TextStyle(color: CupertinoColors.systemBlue,fontSize: 16)
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "USD balance:  ",
                  style: TextStyle(color: Colors.black54)
                ),
                TextSpan(
                  text: "230",
                    style:TextStyle(color:Colors.blue.shade800,fontSize: 16)
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "KES balance:   ",
                  style: TextStyle(color: Colors.black54)
                ),
                TextSpan(
                  text: "45,567",
                    style:TextStyle(color: CupertinoColors.systemBlue,fontSize: 16)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
