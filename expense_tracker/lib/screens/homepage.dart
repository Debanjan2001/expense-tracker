import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/transactions/transaction_home.dart' as transaction_home;
import 'package:expense_tracker/screens/settings/settings.dart' as settings;

// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 20),
                AnalyticsWidget(),
                SizedBox(height: 20),
                transaction_home.TransactionsWidget(),
                SizedBox(height: 20),
                settings.SettingsWidget(),
                SizedBox(height: 20),
                FooterWidget()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// void getMessages() async{
// // To do: Cleanup code here for permission request.
// var status = await Permission.sms.request();
// SmsQuery query = SmsQuery();

// // print last 10 messages or min of msg.length
// print("*****  Printing messages **************");
// for(int cnt=0;cnt<2;++cnt){
//   List<SmsMessage> messages = await query.querySms(
//     kinds: [SmsQueryKind.inbox],
//     count: 10,
//     start: cnt*10,
//   );
//   for(int i=0; i<messages.length; ++i){
//     print("###########  Printing Message - ${i+1}");
//     print(messages[i].id);
//     print(messages[i].body);
//   }
// }

// print("****************************************");
// }

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Placeholder(),
          )
        );
      },
      child: Container(
          // take max of required
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            // color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.orange,
              width: 2,
            ),
            //shadow
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Add a button here that will open a new page using navigator
                const Text('AnalyticsWidget'),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Analytics1'),
                    Text('Analytics2'),
                    Text('Analytics3'),
                  ],
                ),
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Placeholder(),
                          )
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

// create another class for a widget
// this widget will display the following text:
// Made with love(icon) by Debanjan
// where icon is a heart icon

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.green.shade700,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),



        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Made with'),
              SizedBox(width: 5),
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 5),
              Text('by Bob'),
            ],
          ),
        ));
  }
}