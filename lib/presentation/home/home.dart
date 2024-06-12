import 'package:barista/presentation/home/bloc/home_bloc.dart';
import 'package:barista/presentation/welcome/welcome.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/my_button.dart';
import 'package:barista/shared/helpers/loading_screen/loading_screen.dart';
import 'package:barista/shared/helpers/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  bool permissionGranted = false;

  @override
  void initState() {
    super.initState();
    HomeBloc.get(context).add(HomeGetPermissionEvent());
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      HomeBloc.get(context).add(HomeScanQREvent(data: scanData.code ?? ''));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadingState) {
            LoadingScreen.instance()
                .show(context: context, text: state.message);
          } else if (state is HomeQRScanErrorState) {
            controller?.resumeCamera();
            LoadingScreen.instance().hide();
            snackBar(context, state.message, true);
          } else if (state is HomeQRScanSuccessState) {
            HomeBloc.get(context).add(
              HomeConnectToWifiEvent(
                ssid: state.ssid,
                password: state.password,
                coffeeId: state.coffeeId,
              ),
            );
          } else if (state is HomeConnectToWifiErrorState) {
            controller?.resumeCamera();
            LoadingScreen.instance().hide();
            snackBar(context, state.message, true);
          } else if (state is HomeConnectToWifiSuccessState) {
            LoadingScreen.instance().hide();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Welcome(
                  coffeeId: state.coffeeId,
                ),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is HomePermissionErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DefaultText(
                    text: 'Please Go to settings and allow camera permission',
                  ),
                  MyButton(
                    onPressed: () {
                      HomeBloc.get(context).add(HomeGetPermissionEvent());
                    },
                    title:
                        'Refresh',
                  ),
                ],
              ),
            );
          } else {
            return QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(),
            );
          }
        },
      ),
    );
  }
}
