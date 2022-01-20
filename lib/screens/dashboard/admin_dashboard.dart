import 'dart:math';

import 'package:admin/metamask.dart';
import 'package:admin/models/Projects.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Future<bool> getProjects(BuildContext context) async {
    if (allProjects.length == 0) {
      await context.read<MetaMaskProvider>().getTotalProjects();
      int num = context.read<MetaMaskProvider>().totalProjects;

      for (int i = 0; i < num; i++) {
        await context.read<MetaMaskProvider>().getProjects(i);
        String address = context.read<MetaMaskProvider>().thisProject;
        await context.read<MetaMaskProvider>().getFields(address);
        String creator = context.read<MetaMaskProvider>().creator;
        int goal = context.read<MetaMaskProvider>().goalAmount;
        int currBal = context.read<MetaMaskProvider>().currBal;
        String title = context.read<MetaMaskProvider>().title;
        String description = context.read<MetaMaskProvider>().description;
        double goal_eth = goal.toDouble() / ether2wei;
        double curr_eth = currBal.toDouble() / ether2wei;
        await context.read<MetaMaskProvider>().getTime();
        int nowTime = context.read<MetaMaskProvider>().nowTime;
        int raiseUntil = context.read<MetaMaskProvider>().raiseUntil;
        int state = context.read<MetaMaskProvider>().state;
        //print(creator);

        allProjects.add(Project(
            isAdmin: false,
            title: title,
            description: description,
            timeLeft: max(0, raiseUntil - nowTime),
            goal: goal_eth,
            currBal: curr_eth,
            status: state,
            creator: creator,
            address: address,
            icon: icons[random.nextInt(icons.length)]));
      }

      allProjects_len.value = allProjects.length;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (context) => MetaMaskProvider()..init(),
        builder: (context, child) {
          context.read<MetaMaskProvider>().connect();
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              child: Consumer<MetaMaskProvider>(
                  builder: (context, provider, child) {
                String text = "";
                if (provider.isConnected && provider.isInOperatingChain)
                  text = "";
                else if (provider.isConnected)
                  text = "Wrong chain :( Please use the Ropsten testnet";
                else if (provider.isEnabled)
                  text = "Please connect to a Web3 ethereum provider";
                else
                  text = "Please use a Web3 supported browser";

                return Column(
                  children: [
                    Header(
                      connected:
                          provider.isConnected && provider.isInOperatingChain,
                    ),
                    text.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(top: size.height * 0.4),
                            child: Text(
                              text,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          )
                        : FutureBuilder(
                            future: getProjects(context),
                            builder: (context, snapshot) {
                              if (snapshot.hasData)
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: defaultPadding * 1.2,
                                    ),
                                    MyFiles(
                                      isAdmin: true,
                                    ),
                                    SizedBox(height: defaultPadding * 1.2),
                                    RecentFiles(
                                      isLive: 0,
                                      isAdmin: true,
                                    ),
                                    SizedBox(
                                      height: defaultPadding * 1.23,
                                    ),
                                    RecentFiles(
                                      isLive: -1,
                                      isAdmin: true,
                                    ),
                                  ],
                                );
                              else
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.4),
                                  child: CircularProgressIndicator(),
                                );
                            })
                  ],
                );
              }),
            ),
          );
        });
  }
}
