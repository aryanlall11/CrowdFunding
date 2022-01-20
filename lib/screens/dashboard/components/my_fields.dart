import 'package:admin/models/CreateProject.dart';
import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  final isAdmin;
  const MyFiles({
    Key? key,
    this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Welcome!",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        !isAdmin
            ? ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  openDialog(context);
                },
                icon: Icon(Icons.add),
                label: Text("Create Project"),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

Future openDialog(context) =>
    showDialog(context: context, builder: (context) => CreateProject());
