import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text('SettingsWidget'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.sms),
                    onPressed: () {
                    },
                    label: const Text('Rescan SMS'),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.backup),
                    onPressed: () {
                    },
                    label: const Text('Backup'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // async call to get messages
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
