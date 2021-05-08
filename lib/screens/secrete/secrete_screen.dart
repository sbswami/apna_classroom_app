import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:flutter/material.dart';

class SecreteScreen extends StatefulWidget {
  @override
  _SecreteScreenState createState() => _SecreteScreenState();
}

class _SecreteScreenState extends State<SecreteScreen> {
  _setProd() {
    // API env
    apiRootGet = API_ROOT_GET_PROD;
    apiRoot = API_ROOT_PROD;
    setEnv('PROD');

    // Refresh screen
    setState(() {});
  }

  _setDev() {
    // API Env
    apiRootGet = API_ROOT_GET_DEV;
    apiRoot = API_ROOT_DEV;
    setEnv('DEV');

    // Refresh screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secrete'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InfoCard(title: 'API Endpoint', data: apiRootGet),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SecondaryButton(
                      text: 'Set Prod Env',
                      onPress: _setProd,
                    ),
                    SecondaryButton(
                      text: 'Set Dev Env',
                      onPress: _setDev,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
