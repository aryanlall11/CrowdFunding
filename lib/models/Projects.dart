import 'package:admin/constants.dart';
import 'package:admin/models/Approve.dart';
import 'package:admin/models/Contribute.dart';
import 'package:admin/models/Refund.dart';
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
      mycontri,
      contriCount,
      reqLength,
      activeReq,
      myApproval,
      creator;

  Project(
      {this.isAdmin,
      this.contriCount,
      this.reqLength,
      this.activeReq,
      this.title,
      this.mycontri,
      this.description,
      this.icon,
      this.timeLeft,
      this.goal,
      this.currBal,
      this.status,
      this.address,
      this.myApproval,
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
      mycontri,
      contriCount,
      reqLength,
      activeReq,
      myApproval,
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
      this.mycontri,
      this.contriCount,
      this.reqLength,
      this.activeReq,
      this.icon,
      this.myApproval,
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
    if (widget.status == 3)
      status = "Successful";
    else if (widget.status == 2)
      status = "Expired";
    else if (widget.status == 1) status = "Fundraising";

    bool isRefund = false;
    if (widget.status == 2 && widget.mycontri > 0) isRefund = true;

    bool createReq = false;
    bool approveReq = false;
    if ((current_account == widget.creator.toString().toLowerCase()) &&
        (widget.status == 3) &&
        !widget.activeReq) createReq = true;
    if ((widget.status == 3) &&
        (widget.mycontri > 0) &&
        widget.activeReq &&
        !widget.myApproval) approveReq = true;

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
                  // SvgPicture.asset(
                  //   widget.icon!,
                  //   height: 30,
                  //   width: 30,
                  // ),
                  Image.asset(
                    widget.icon!,
                    height: 30,
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
            (widget.live || isRefund || createReq || approveReq)
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
                          widget.mycontri,
                          isRefund,
                          createReq,
                          approveReq,
                          widget.contriCount,
                          widget.reqLength,
                          widget.address,
                          widget.creator);
                    },
                    // icon: Icon(Icons.check),
                    icon: (widget.live || isRefund)
                        ? (isRefund
                            ? Icon(Icons.arrow_back)
                            : (widget.isAdmin
                                ? Icon(Icons.check)
                                : Icon(Icons.attach_money)))
                        : (createReq
                            ? Icon(Icons.playlist_add)
                            : Icon(Icons.unfold_more)),

                    label: Text((widget.live || isRefund)
                        ? (isRefund
                            ? "Get Refund"
                            : (widget.isAdmin ? "Approve" : "Contribute"))
                        : (createReq ? "Add Request" : "View Request")),
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
              widget.mycontri,
              isRefund,
              createReq,
              approveReq,
              widget.contriCount,
              widget.reqLength,
              widget.address,
              widget.creator);
        },
      ),
    );
  }
}

Future openDialog(
        context,
        isAdmin,
        title,
        description,
        timeLeft,
        goal,
        currBal,
        status,
        mycontri,
        isRefund,
        createReq,
        approveReq,
        contriCount,
        reqLength,
        address,
        creator) =>
    showDialog(
        context: context,
        builder: (context) => isRefund
            ? Refund(
                title: title,
                description: description,
                goal: goal,
                address: address,
                creator: creator,
                mycontri: mycontri)
            : (!isAdmin
                ? Contribute(
                    title: title,
                    description: description,
                    timeLeft: timeLeft,
                    goal: goal,
                    currBal: currBal,
                    status: status,
                    address: address,
                    creator: creator,
                    createReq: createReq,
                    approveReq: approveReq,
                    contriCount: contriCount,
                    reqLength: reqLength,
                  )
                : Approve(
                    title: title,
                    description: description,
                    timeLeft: timeLeft,
                    goal: goal,
                    currBal: currBal,
                    status: status,
                    address: address,
                    creator: creator)));
