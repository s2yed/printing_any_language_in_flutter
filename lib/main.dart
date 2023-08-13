 
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:printer/priter_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Demo By Serag Sakr',
      navigatorKey: appNavigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Printer Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List availableBluetoothDevices = [];
  String? result;

  Future<void> getBluetooth() async {
    final List? bluetooth = await BluetoothThermalPrinter.getBluetooths;
    setState(() {
      availableBluetoothDevices = bluetooth!;
    });
  }

  Future setConnect(String mac) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;

    if (isConnected == "false") {
      result = await BluetoothThermalPrinter.connect(mac);

      if (result == "true") {
        List<int> bytes = await printTestBluetooth();
        await BluetoothThermalPrinter.writeBytes(bytes);
      }
    } else {
      List<int> bytes = await printTestBluetooth();
      await BluetoothThermalPrinter.writeBytes(bytes);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          height: 600,
          child: ListView.builder(
              itemCount: availableBluetoothDevices.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {

                    String select =   availableBluetoothDevices[index];
                    List list = select.split("#");

                    /// String name = list[0];
                    String mac = list[1];

                    /// set connect mac printer
                     setConnect(mac);

                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.print),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(availableBluetoothDevices[index] ?? ''),
                                   Text(
                                    'Click to print a test receipt',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getBluetooth();
        },
        tooltip: 'Print',
        child: const Icon(Icons.print),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
