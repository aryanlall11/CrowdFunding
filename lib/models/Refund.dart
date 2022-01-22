import 'package:admin/constants.dart';
import 'package:admin/metamask.dart';
import 'package:admin/models/Projects.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Refund extends StatefulWidget {
  final title, description, goal, address, creator, mycontri;
  const Refund(
      {Key? key,
      this.title,
      this.description,
      this.goal,
      this.address,
      this.creator,
      this.mycontri})
      : super(key: key);

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  bool isCreate = false;
  bool done = false;

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
                done
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
                  Text(
                    "Goal Amount   :  ${widget.goal} ETH",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Contribution   :  ${(widget.mycontri) / ether2wei.toDouble()} ETH",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 30),
                  Consumer<MetaMaskProvider>(
                      builder: (context, provider, child) {
                    return Center(
                      child: isCreate
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isCreate = true;
                                });

                                await context
                                    .read<MetaMaskProvider>()
                                    .refund(widget.address);

                                setState(() {
                                  isCreate = false;
                                  done = true;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: const Text('Get Refund'),
                              ),
                            ),
                    );
                  })
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
