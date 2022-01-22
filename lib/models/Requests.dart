import 'package:admin/metamask.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/src/provider.dart';

class Request_Tile extends StatefulWidget {
  final id, addr, status, approveReq, desc, value, count, total;
  const Request_Tile(
      {Key? key,
      this.status,
      this.addr,
      this.approveReq,
      this.desc,
      this.value,
      this.count,
      this.total,
      this.id})
      : super(key: key);

  @override
  _Request_TileState createState() => _Request_TileState();
}

class _Request_TileState extends State<Request_Tile> {
  bool isCreate = false;
  bool done = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[850],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Request ${widget.id}  :  "),
                    Text("${widget.value} ETH")
                  ],
                ),
                widget.status
                    ? Text("Approved")
                    : (widget.approveReq
                        ? !isCreate
                            ? (!done
                                ? ElevatedButton.icon(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(3)),
                                    onPressed: () async {
                                      setState(() {
                                        isCreate = true;
                                      });
                                      await context
                                          .read<MetaMaskProvider>()
                                          .approveReq(
                                              widget.addr, widget.id - 1);
                                      setState(() {
                                        isCreate = false;
                                        done = true;
                                      });
                                    },
                                    icon: Icon(Icons.check),
                                    label: Text("Approve"),
                                  )
                                : Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ))
                            : CircularProgressIndicator()
                        : Text("Pending"))
              ],
            ),
            SizedBox(height: 4),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: 5),
            Text("About  :  ${widget.desc}"),
            SizedBox(height: 7),
            Text("Approved by  :  ${widget.count} / ${widget.total}")
          ],
        ),
      ),
    );
  }
}
