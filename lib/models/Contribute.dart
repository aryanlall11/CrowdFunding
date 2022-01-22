import 'dart:math';

import 'package:admin/constants.dart';
import 'package:admin/metamask.dart';
import 'package:admin/models/Projects.dart';
import 'package:admin/models/Requests.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Contribute extends StatefulWidget {
  final title,
      description,
      timeLeft,
      goal,
      currBal,
      status,
      address,
      creator,
      createReq,
      approveReq,
      contriCount,
      reqLength;
  const Contribute(
      {Key? key,
      this.title,
      this.description,
      this.timeLeft,
      this.goal,
      this.currBal,
      this.status,
      this.address,
      this.creator,
      this.createReq,
      this.approveReq,
      this.contriCount,
      this.reqLength})
      : super(key: key);

  @override
  _ContributeState createState() => _ContributeState();
}

class _ContributeState extends State<Contribute> {
  final _formKey = GlobalKey<FormState>();
  final _addReqKey = GlobalKey<FormState>();
  final amtCont = TextEditingController();
  final addReqDes = TextEditingController();
  final addReqAmt = TextEditingController();
  bool isCreate = false;
  bool done = false;
  String errorText = "";

  Future<List> getReq(context) async {
    if (widget.reqLength == 0) return [];
    Contract PrjCont = Contract(
      widget.address,
      prjABI,
      provider!,
    );
    List reqs = [];
    for (int i = 0; i < widget.reqLength; i++) {
      var req = await PrjCont.call('requests', [i]);
      String desc = req[0].toString();
      String val = req[1].toString();
      bool comp = req[2] as bool;
      String count = req[3].toString();
      reqs.add([desc, int.parse(val), comp, int.parse(count)]);
    }
    return reqs;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (_) => MetaMaskProvider()..init(),
        builder: (context, child) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title),
                errorText.length > 0
                    ? Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(errorText,
                              style: Theme.of(context).textTheme.subtitle2)
                        ],
                      )
                    : done
                        ? Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          )
                        : SizedBox.shrink(),
              ],
            ),
            content: Container(
              width: size.width * 0.5,
              constraints: BoxConstraints(maxHeight: size.height * 0.8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: size.width * 0.5,
                      color: Colors.grey[700],
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.request_page_outlined,
                            ),
                            Text(
                              "${widget.address}",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: size.width * 0.5,
                      color: Colors.grey[700],
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Icon(Icons.contact_page_outlined),
                            Text(
                              "${widget.creator}",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 10),
                    (widget.timeLeft > 0)
                        ? Text(
                            "Time Left           :  ${widget.timeLeft}",
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        : Text(
                            "Contributors   :  ${widget.contriCount}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                    SizedBox(height: 10),
                    Text(
                      "Status                :  ${widget.status}",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: min(1, widget.currBal / widget.goal),
                        center: Text(
                          "${widget.currBal}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "/ ${widget.goal} ETH",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Color(0xFFFFA113),
                      ),
                    ),
                    FutureBuilder(
                      future: getReq(context),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          Object? reqs_obj = snapshot.data;
                          List reqs = reqs_obj as List;
                          print(reqs);
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                for (int i = 0; i < widget.reqLength; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8),
                                    child: Request_Tile(
                                      status: reqs[i][2],
                                      approveReq: widget.approveReq,
                                      desc: reqs[i][0],
                                      value:
                                          ((reqs[i][1]) / ether2wei.toDouble()),
                                      count: reqs[i][3],
                                      total: widget.contriCount,
                                      id: i + 1,
                                      addr: widget.address,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    widget.createReq
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[850],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: size.width * 0.35,
                                    child: Form(
                                      key: _addReqKey,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: size.width * 0.07,
                                                  child: Text(
                                                    "Description : ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  )),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: addReqDes,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Enter the request description',
                                                      labelText: 'Description'),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter the request description!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: size.width * 0.07,
                                                  child: Text(
                                                    "Amount (ETH) : ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  )),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: addReqAmt,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Enter the requested amount',
                                                      labelText:
                                                          'Amount (ETH)'),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter the requested amount!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(7)),
                                    onPressed: () async {
                                      if (_addReqKey.currentState!.validate()) {
                                        double val =
                                            double.parse(addReqAmt.text);
                                        if (val <= widget.currBal) {
                                          setState(() {
                                            errorText = "";
                                            isCreate = true;
                                          });
                                          int val_wei =
                                              (val * ether2wei) as int;
                                          await context
                                              .read<MetaMaskProvider>()
                                              .createRequest(
                                                widget.address,
                                                addReqDes.text,
                                                (val_wei / 1000000) as int,
                                              );

                                          setState(() {
                                            isCreate = false;
                                            done = true;
                                          });
                                        } else {
                                          errorText =
                                              "Insufficient balance for the requested amount ";
                                          setState(() {});
                                        }
                                      }
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text("Add Request"),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 30),
                    widget.status == "Fundraising"
                        ? Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                        alignment: Alignment.centerRight,
                                        width: size.width * 0.1,
                                        child: Center(
                                          child: Text(
                                            "Enter amount to contribute : ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        )),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: amtCont,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText:
                                                'Enter amount to contribute (ETH)',
                                            labelText: 'Amount (ETH)'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a valid amount!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    Consumer<MetaMaskProvider>(
                                        builder: (context, provider, child) {
                                      return Center(
                                        child: isCreate
                                            ? CircularProgressIndicator()
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await provider.connect();
                                                    String msgaddr = provider
                                                        .addr
                                                        .toLowerCase();
                                                    double val = double.parse(
                                                        amtCont.text);
                                                    if ((msgaddr !=
                                                            widget.creator
                                                                .toLowerCase()) &&
                                                        (widget.currBal + val <=
                                                            widget.goal)) {
                                                      int val_wei = (val *
                                                          ether2wei) as int;
                                                      //print(val_wei);

                                                      setState(() {
                                                        isCreate = true;
                                                      });

                                                      await context
                                                          .read<
                                                              MetaMaskProvider>()
                                                          .contibute(
                                                              widget.address,
                                                              val_wei);

                                                      setState(() {
                                                        isCreate = false;
                                                        done = true;
                                                      });
                                                    } else {
                                                      if (widget.currBal + val >
                                                          widget.goal)
                                                        errorText =
                                                            "Net contribution can't exceed goal amount!";
                                                      else
                                                        errorText =
                                                            "Creator can't contribute!";
                                                      setState(() {});
                                                    }
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          bottom: 8.0),
                                                  child:
                                                      const Text('Contribute'),
                                                ),
                                              ),
                                      );
                                    })
                                  ],
                                ),
                                SizedBox(height: 30),
                              ],
                            ))
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
