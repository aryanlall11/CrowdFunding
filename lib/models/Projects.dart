import 'package:admin/constants.dart';
import 'package:admin/models/Approve.dart';
import 'package:admin/models/Contribute.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Project {
  final isAdmin,
      icon,
      title,
      description,
      timeLeft,
      goal,
      currBal,
      status,
      address,
      creator;

  Project(
      {this.isAdmin,
      this.title,
      this.description,
      this.icon,
      this.timeLeft,
      this.goal,
      this.currBal,
      this.status,
      this.address,
      this.creator});
}

List<Project> allProjects = [];

class Project_Tile extends StatefulWidget {
  final isAdmin,
      title,
      description,
      timeLeft,
      goal,
      currBal,
      status,
      address,
      creator,
      icon,
      live;
  const Project_Tile(
      {Key? key,
      this.title,
      this.description,
      this.timeLeft,
      this.goal,
      this.currBal,
      this.status,
      this.address,
      this.creator,
      this.icon,
      this.live,
      this.isAdmin})
      : super(key: key);

  @override
  _Project_TileState createState() => _Project_TileState();
}

class _Project_TileState extends State<Project_Tile> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String status = "";
    if (widget.status == 2)
      status = "Successful";
    else if (widget.status == 3)
      status = "Expired";
    else
      status = "Fundraising";

    return Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.2,
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.icon!,
                    height: 30,
                    width: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(widget.title!),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width * 0.15,
              child: widget.live
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Text(widget.timeLeft!.toString()),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Text(widget.goal!.toString()),
                    ),
            ),
            Container(
              width: size.width * 0.2,
              child: widget.live
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Text(widget.goal!.toString()),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Text(status),
                    ),
            ),
            widget.live
                ? ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      openDialog(
                          context,
                          widget.isAdmin,
                          widget.title,
                          widget.description,
                          widget.timeLeft,
                          widget.goal,
                          widget.currBal,
                          status,
                          widget.address,
                          widget.creator);
                    },
                    icon: Icon(Icons.monetization_on_outlined),
                    label: Text(widget.isAdmin ? "Approve" : "Contribute"),
                  )
                : SizedBox.shrink(),
          ],
        ),
        onTap: () {
          openDialog(
              context,
              widget.isAdmin,
              widget.title,
              widget.description,
              widget.timeLeft,
              widget.goal,
              widget.currBal,
              status,
              widget.address,
              widget.creator);
        },
      ),
    );
  }
}

Future openDialog(context, isAdmin, title, description, timeLeft, goal, currBal,
        status, address, creator) =>
    showDialog(
        context: context,
        builder: (context) => !isAdmin
            ? Contribute(
                title: title,
                description: description,
                timeLeft: timeLeft,
                goal: goal,
                currBal: currBal,
                status: status,
                address: address,
                creator: creator)
            : Approve(
                title: title,
                description: description,
                timeLeft: timeLeft,
                goal: goal,
                currBal: currBal,
                status: status,
                address: address,
                creator: creator));
