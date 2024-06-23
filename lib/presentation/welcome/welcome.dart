import 'package:barista/models/qr_data.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/presentation/categories/categories.dart';
import 'package:barista/presentation/home/home.dart';
import 'package:barista/presentation/welcome/bloc/welcome_bloc.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_widget.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:barista/shared/helpers/snack_bar.dart';
import 'package:barista/shared/styles/colors.dart';
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
      backgroundColor: Colors.white,
      body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          if (state is WelcomeSucessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  height: 300,
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const DefaultText(
                              text: 'Welcome to',
                              textColor: kSecondaryColor,
                              textSize: 12,
                            ),
                            DefaultText(
                              text: ' ${state.coffee.name}',
                              textSize: 30,
                              weight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              textColor: Colors.white,
                            ),
                            const DefaultText(
                              text: 'Enjoy your coffee experience!',
                              textColor: kSecondaryColor,
                              textSize: 16,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 25,
                        right: 30,
                        child: FloatingActionButton(
                          backgroundColor: kSecondaryColor,
                          onPressed: () {
                            ShoppingCartBloc.get(context)
                                .add(ShoppingCartClearEvent());
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Icon(
                            Icons.qr_code,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 25,
                        left: 30,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(10),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CategoriesScreen(
                                  coffee: state.coffee,
                                ),
                              ),
                            );
                          },
                          child: const DefaultText(
                            text: 'Check our menu ' ' \u{1F4D6}',
                            textSize: 18,
                            textColor: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: DefaultText(
                //       text: ' ${state.coffee.description}',
                //     ),
                //   ),
                // ),
                Center(
                  child: SizedBox(
                    height: 250,
                    width: size.width - 10,
                    child: imageLoader(
                      state.coffee.image,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                wifiInfoWidget(widget.qrData),
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
            DefaultText(
              text: 'WiFi Name: ${qrData.ssid}',
              textSize: 16,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DefaultText(
                  text: 'WiFi Password: ${qrData.password}',
                  textSize: 16,
                ),
                FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    copyPassword(context);
                  },
                  child: const Icon(Icons.content_copy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
