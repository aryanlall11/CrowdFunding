import 'package:admin/constants.dart';
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

  String get addr => currentAddress;

  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == operatingChain;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;
      currentChain = await ethereum!.getChainId();
      notifyListeners();
    }
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    CFCont = null;
    PrjCont = null;
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
      provider!,
    );
    BigInt goal = await PrjCont!.call<BigInt>('amountGoal');
    goalAmount = goal.toInt();

    BigInt bal = await PrjCont!.call<BigInt>('currentBalance');
    currBal = bal.toInt();

    creator = await PrjCont!.call<String>('creator');

    title = await PrjCont!.call<String>('title');
    description = await PrjCont!.call<String>('description');

    BigInt deadline = await PrjCont!.call<BigInt>('raiseUntil');
    raiseUntil = deadline.toInt();
    state = await PrjCont!.call<int>('state');
    //state = state_tm.toInt();

    //notifyListeners();
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
