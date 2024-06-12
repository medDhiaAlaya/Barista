import 'package:barista/presentation/categories/categories.dart';
import 'package:barista/presentation/welcome/bloc/welcome_bloc.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_widget.dart';
import 'package:barista/shared/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Welcome extends StatefulWidget {
  final String coffeeId;
  const Welcome({super.key, required this.coffeeId});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    WelcomeBloc.get(context)
        .add(WelcomeGetCoffeeEvent(coffeeId: widget.coffeeId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          if (state is WelcomeSucessState) {
            return Column(
              children: [
                DefaultText(
                  text: state.coffee.name,
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
                )
              ],
            );
          } else if (state is WelcomeErrorState) {
            return errorWidget(
              state.message,
              () {
                WelcomeBloc.get(context).add(
                  WelcomeGetCoffeeEvent(
                    coffeeId: widget.coffeeId,
                  ),
                );
              },
            );
          } else {
            return loadingWidget();
          }
        },
      ),
    );
  }
}
