import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/transactions/transaction_home.dart' as transaction_home;
import 'package:expense_tracker/screens/settings/settings.dart' as settings;
import 'package:expense_tracker/screens/analytics/analytics_home.dart' as analytics_home;
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ValueNotifier<bool> reloadNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        reloadNotifier.value = !reloadNotifier.value;
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  ValueListenableBuilder<bool>(
                    valueListenable: reloadNotifier,
                    builder: (context, value, child) {
                      return analytics_home.AnalyticsWidget(key: UniqueKey());
                    },
                  ),

                  const SizedBox(height: 20),
                  
                  ValueListenableBuilder<bool>(
                    valueListenable: reloadNotifier,
                    builder: (context, value, child) {
                      return transaction_home.TransactionsWidget(key: UniqueKey());
                    },
                  ),

                  const SizedBox(height: 20),
                  const settings.SettingsWidget(),
                  const SizedBox(height: 20),
                  const FooterWidget()
                ],
              ),
            ),
          ),
        ],
      ),
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