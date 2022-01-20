import 'package:admin/models/Projects.dart';
import 'package:admin/models/RecentFile.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class RecentFiles extends StatefulWidget {
  final isLive, isAdmin;
  const RecentFiles({Key? key, this.isLive, this.isAdmin}) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int live = widget.isLive;
    bool admin = widget.isAdmin;
    return Container(
      constraints: BoxConstraints(
          minHeight: size.height * 0.35, maxHeight: size.height * 0.6),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              !widget.isAdmin
                  ? (live == 1 ? "Live Projects" : "Past Projects")
                  : (live == 0 ? "Pending Requests" : "Past Approvals"),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder(
                  valueListenable: allProjects_len,
                  builder: (context, value, widget) {
                    List<Project> temp = [];
                    for (int i = 0; i < allProjects.length; i++) {
                      if (live >= 0) {
                        if (allProjects[i].status == live)
                          temp.add(allProjects[i]);
                      } else {
                        if (allProjects[i].status >= -1 * live)
                          temp.add(allProjects[i]);
                      }
                    }
                    bool real_live = false;
                    if (admin) {
                      if (live == 0) real_live = true;
                    } else {
                      if (live == 1) real_live = true;
                    }
                    return temp.length > 0
                        ? Column(
                            children: [
                              real_live
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width * 0.2,
                                          child: Text(
                                            "Project Title",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.15,
                                          child: Text(
                                            "Time Left",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.2,
                                          child: Text(
                                            "Goal Amount (Eth)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.2,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width * 0.2,
                                          child: Text(
                                            "Project Title",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.15,
                                          child: Text(
                                            "Goal Amount (Eth)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.2,
                                          child: Text(
                                            "Status",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.2,
                                        )
                                      ],
                                    ),
                              SizedBox(height: 5),
                              Divider(color: Colors.grey),
                              SizedBox(height: 4),
                              for (int i = 0; i < temp.length; i++)
                                Project_Tile(
                                    isAdmin: admin,
                                    title: temp[i].title,
                                    description: temp[i].description,
                                    timeLeft: temp[i].timeLeft,
                                    goal: temp[i].goal,
                                    currBal: temp[i].currBal,
                                    status: temp[i].status,
                                    address: temp[i].address,
                                    creator: temp[i].creator,
                                    icon: temp[i].icon,
                                    live: real_live)
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: size.height * 0.08),
                              child: Text(
                                "Nothing to show :(",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
