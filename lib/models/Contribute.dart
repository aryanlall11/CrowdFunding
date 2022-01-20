import 'package:admin/constants.dart';
import 'package:admin/metamask.dart';
import 'package:admin/models/Projects.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Contribute extends StatefulWidget {
  final title, description, timeLeft, goal, currBal, status, address, creator;
  const Contribute(
      {Key? key,
      this.title,
      this.description,
      this.timeLeft,
      this.goal,
      this.currBal,
      this.status,
      this.address,
      this.creator})
      : super(key: key);

  @override
  _ContributeState createState() => _ContributeState();
}

class _ContributeState extends State<Contribute> {
  final _formKey = GlobalKey<FormState>();
  final amtCont = TextEditingController();
  bool isCreate = false;
  bool done = false;
  String errorText = "";

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: size.width * 0.25,
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
                    width: size.width * 0.25,
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
                  Text(
                    "Time Left   :  ${widget.timeLeft}",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Status        :  ${widget.status}",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: widget.currBal / widget.goal,
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
                      progressColor: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
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
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
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
                                          'Enter amount to contribute (Eth)',
                                      labelText: 'Amount (Eth)'),
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
                                              String msgaddr =
                                                  provider.addr.toLowerCase();
                                              if (msgaddr !=
                                                  widget.creator
                                                      .toLowerCase()) {
                                                double val =
                                                    double.parse(amtCont.text);
                                                int val_wei =
                                                    (val * ether2wei) as int;
                                                print(val_wei);

                                                setState(() {
                                                  isCreate = true;
                                                });

                                                await context
                                                    .read<MetaMaskProvider>()
                                                    .contibute(widget.address,
                                                        val_wei);

                                                setState(() {
                                                  isCreate = false;
                                                  done = true;
                                                });
                                              } else {
                                                errorText =
                                                    "Creator can't contribute!";
                                                setState(() {});
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 8.0),
                                            child: const Text('Contribute'),
                                          ),
                                        ),
                                );
                              })
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ))
                ],
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
