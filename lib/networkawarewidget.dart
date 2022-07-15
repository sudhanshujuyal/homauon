
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({Key? key, required this.onlineChild, required this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.online) {
      return onlineChild;
    } else {
      return offlineChild;
    }
  }

}