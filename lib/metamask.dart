import 'dart:math';

import 'package:admin/constants.dart';
import 'package:admin/models/Projects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
//import 'package:funding/constants.dart';

class MetaMaskProvider extends ChangeNotifier {
  static const operatingChain = 3;

  String currentAddress = '';

  int currentChain = -1;

  Contract? CFCont;
  Contract? PrjCont;
  int totalProjects = 0;
  String thisProject = "";
  String creator = "";
  String title = "";
  String description = "";
  int raiseUntil = 0;
  int state = 0;
  int goalAmount = 0;
  int currBal = 0;
  int nowTime = 0;
  int contri = 0;
  int requestLength = 0;
  int contriCount = 0;
  bool reqActive = false;
  bool myApproval = false;

  String get addr => currentAddress;

  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == operatingChain;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) {
        currentAddress = accs.first;
        current_account = accs.first.toLowerCase();
      }
      currentChain = await ethereum!.getChainId();
      notifyListeners();
    }
  }

  clear() {
    currentAddress = '';
    current_account = '';
    currentChain = -1;
    CFCont = null;
    PrjCont = null;
    allProjects = [];
    notifyListeners();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((accounts) {
        clear();
      });
    }
  }

  getTotalProjects() async {
    // ignore: prefer_conditional_assignment
    if (CFCont == null) {
      CFCont = Contract(
        CFAddress,
        CFAbi,
        provider!,
      );
    }
    BigInt idx = await CFCont!.call<BigInt>('id');
    totalProjects = idx.toInt();
    //notifyListeners();
  }

  getProjects(int index) async {
    // ignore: prefer_conditional_assignment
    if (CFCont == null) {
      CFCont = Contract(
        CFAddress,
        CFAbi,
        provider!,
      );
    }
    var prjs = await CFCont!.call<String>('projects', [index]);
    thisProject = prjs;
    //notifyListeners();
  }

  getTime() async {
    if (CFCont == null) {
      CFCont = Contract(
        CFAddress,
        CFAbi,
        provider!,
      );
    }
    BigInt tm = await CFCont!.call<BigInt>('getTime');
    nowTime = tm.toInt();
  }

  getFields(String address) async {
    // ignore: prefer_conditional_assignment
    PrjCont = Contract(
      address,
      prjABI,
      provider!.getSigner(),
    );
    BigInt goal = await PrjCont!.call<BigInt>('amountGoal');
    goalAmount = goal.toInt();

    BigInt bal = await PrjCont!.call<BigInt>('currentBalance');
    currBal = bal.toInt();

    creator = await PrjCont!.call<String>('creator');
    reqActive = await PrjCont!.call<bool>('activeRequest');

    title = await PrjCont!.call<String>('title');
    description = await PrjCont!.call<String>('description');

    BigInt deadline = await PrjCont!.call<BigInt>('raiseUntil');
    raiseUntil = deadline.toInt();
    state = await PrjCont!.call<int>('state');

    if ((raiseUntil < nowTime) && state != 2) {
      await PrjCont!.call('checkIfDeadlineMet');
      state = 2;
    }

    BigInt contri_tm =
        await PrjCont!.call<BigInt>('contributions', [currentAddress]);
    contri = contri_tm.toInt();

    BigInt contriCount_tm = await PrjCont!.call<BigInt>('contributerCount');
    contriCount = contriCount_tm.toInt();

    BigInt reqLn = await PrjCont!.call<BigInt>('requestLength');
    requestLength = reqLn.toInt();

    if (reqActive) {
      myApproval = await PrjCont!.call<bool>('isApproval', [requestLength - 1]);
    }
  }

  Future<List?> getRequests(String address, int idx) async {
    PrjCont = Contract(
      address,
      prjABI,
      provider!,
    );
    List reqs = [];
    for (int i = 0; i < idx; i++) {
      var req = await PrjCont!.call('requests', [i]);
      reqs.add(req);
    }
    return reqs;
  }

  approve(String address) async {
    // ignore: prefer_conditional_assignment
    PrjCont = Contract(
      address,
      prjABI,
      provider!.getSigner(),
    );
    await PrjCont!.call('approve');
    //notifyListeners();
  }

  refund(String address) async {
    // ignore: prefer_conditional_assignment
    PrjCont = Contract(
      address,
      prjABI,
      provider!.getSigner(),
    );
    await PrjCont!.call('getRefund');
    //notifyListeners();
  }

  createRequest(String address, String desc, int val) async {
    // ignore: prefer_conditional_assignment
    PrjCont = Contract(
      address,
      prjABI,
      provider!.getSigner(),
    );
    await PrjCont!.call('createRequest', [desc, val]);
    //notifyListeners();
  }

  approveReq(String address, int val) async {
    PrjCont = Contract(
      address,
      prjABI,
      provider!.getSigner(),
    );
    await PrjCont!.call('approveRequest', [val]);
  }

  createProject(String title, String desc, int val, int deadline) async {
    CFCont = Contract(
      CFAddress,
      CFAbi,
      provider!.getSigner(),
    );
    final tx = await CFCont!.send('startProject', [title, desc, val, deadline]);
    final receipt = tx.wait();
    //notifyListeners();
  }

  contibute(String address, int value) async {
    PrjCont = Contract(
      address,
      prjABI,
      provider!.getSigner(),
    );
    final tx = await PrjCont!
        .send('contribute', [], TransactionOverride(value: BigInt.from(value)));
    final receipt = tx.wait();
    //notifyListeners();
  }
}
