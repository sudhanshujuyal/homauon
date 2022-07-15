import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:homauon/webview.dart';
import 'package:provider/provider.dart';
import 'networkawarewidget.dart';

enum NetworkStatus {
  online,
  offline
}

Future<void> main() async {
  var connectedornot = NetworkStatus.offline;

  try {
    final result = await InternetAddress.lookup('example.com');
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
      connectedornot = NetworkStatus.online;
    }else{
      connectedornot = NetworkStatus.offline;
    }
  } on SocketException catch (_) {
    connectedornot = NetworkStatus.offline;

  }
  runApp(MyApp(connectedornot: connectedornot));
}

class MyApp extends StatelessWidget {
  final connectedornot;
  const MyApp({Key? key, this.connectedornot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFD1B8AA),
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(primaryColor: Colors.blue),
        home: Home(connectedornot: connectedornot,));
  }
}

class Home extends StatefulWidget{
  var connectedornot;
  Home({this.connectedornot});

  @override
  State<StatefulWidget> createState() {
   return HomeState();
  }
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: widget.connectedornot,
        create: (context) =>
        NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          onlineChild: const Webview(),
          offlineChild: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(child: Image.asset("Assets/no_connection.png",height: MediaQuery.of(context).size.height*2.7,width: MediaQuery.of(context).size.width*2.7 ,)

                        ),
                      ),

                      const SizedBox(height: 25,),

                    ],
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }

}

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController =
  StreamController<NetworkStatus>();

  NetworkStatusService() {
    Connectivity().onConnectivityChanged.listen((status){
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  NetworkStatus _getNetworkStatus(ConnectivityResult status) {
    if(status == ConnectivityResult.wifi){
      return NetworkStatus.online;
    } else if(status == ConnectivityResult.mobile){
      return NetworkStatus.online;
    } else if(status == ConnectivityResult.none){
      return NetworkStatus.offline;
    }
    return NetworkStatus.offline;

  }
}
