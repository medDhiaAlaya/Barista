import 'package:barista/models/qr_data.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/presentation/categories/categories.dart';
import 'package:barista/presentation/home/home.dart';
import 'package:barista/presentation/welcome/bloc/welcome_bloc.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_widget.dart';
import 'package:barista/shared/components/my_button.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:barista/shared/helpers/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Welcome extends StatefulWidget {
  final QrData qrData;
  const Welcome({super.key, required this.qrData});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    WelcomeBloc.get(context).add(
      WelcomeGetCoffeeEvent(
        coffeeId: widget.qrData.coffeeId,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            onPressed: () {
              ShoppingCartBloc.get(context).add(ShoppingCartClearEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.qr_code,
            ),
          ),
        ],
      ),
      body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          if (state is WelcomeSucessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                wifiInfoWidget(widget.qrData),
                Center(
                  child: SizedBox(
                    height: 250,
                    width: size.width - 10,
                    child: imageLoader(
                      state.coffee.image,
                    ),
                  ),
                ),
                DefaultText(
                  text: state.coffee.name,
                  textSize: 32,
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultText(
                      text: 'description : ${state.coffee.description}',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  title: 'chack menu',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CategoriesScreen(
                          coffee: state.coffee,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          } else if (state is WelcomeErrorState) {
            return Column(
              children: [
                wifiInfoWidget(widget.qrData),
                errorWidget(
                  state.message,
                  () {
                    WelcomeBloc.get(context).add(
                      WelcomeGetCoffeeEvent(
                        coffeeId: widget.qrData.coffeeId,
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return loadingWidget();
          }
        },
      ),
    );
  }

  Widget wifiInfoWidget(QrData qrData) {
    void copyPassword(BuildContext context) {
      Clipboard.setData(ClipboardData(text: qrData.password));
      showToast("Password copied to clipboard", false);
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'WiFi Name: ${qrData.ssid}',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Password: ${qrData.password}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    copyPassword(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
