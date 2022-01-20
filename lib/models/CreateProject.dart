import 'package:admin/constants.dart';
import 'package:admin/metamask.dart';
import 'package:admin/models/Projects.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({Key? key}) : super(key: key);

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  final titleCont = TextEditingController();
  final desCont = TextEditingController();
  final amtCont = TextEditingController();
  final durCont = TextEditingController();
  bool isCreate = false;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => MetaMaskProvider()..init(),
      builder: (context, child) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Create New Project"),
              done
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    )
                  : SizedBox.shrink()
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
                                child: Text(
                                  "Title : ",
                                  style: Theme.of(context).textTheme.subtitle1,
                                )),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: titleCont,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter the project title',
                                    labelText: 'Title'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the title!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                width: size.width * 0.1,
                                child: Text(
                                  "Description : ",
                                  style: Theme.of(context).textTheme.subtitle1,
                                )),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: desCont,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter a project description',
                                    labelText: 'Description'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the project description!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                width: size.width * 0.1,
                                child: Text(
                                  "Raise Till (days) : ",
                                  style: Theme.of(context).textTheme.subtitle1,
                                )),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: durCont,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter duration for funding',
                                    labelText: 'Duration'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the funding deadline!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                width: size.width * 0.1,
                                child: Text(
                                  "Goal Amount (Eth) : ",
                                  style: Theme.of(context).textTheme.subtitle1,
                                )),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: amtCont,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter the amount to raise (Eth)',
                                    labelText: 'Goal Amount'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the goal amount!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
                        Consumer<MetaMaskProvider>(
                          builder: (context, provider, child) {
                            return Center(
                              child: isCreate
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          String title = titleCont.text;
                                          String description = desCont.text;
                                          int raiseUntil =
                                              int.parse(durCont.text);
                                          double val =
                                              double.parse(amtCont.text);
                                          int val_wei =
                                              (val * ether2wei) as int;

                                          setState(() {
                                            isCreate = true;
                                          });

                                          await context
                                              .read<MetaMaskProvider>()
                                              .createProject(title, description,
                                                  val_wei, raiseUntil);

                                          setState(() {
                                            isCreate = false;
                                            done = true;
                                          });
                                        }
                                      },
                                      child: const Text('Create'),
                                    ),
                            );
                          },
                        ),
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
      },
    );
  }
}
