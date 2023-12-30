import 'package:expense_tracker/screens/transactionForm.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/navbar.dart' as navbar;
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/services.dart';
import 'package:sqflite/sqflite.dart';

// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:permission_handler/permission_handler.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context){
    bool isDarkMode = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: (isDarkMode? Colors.black87 : Colors.white.withOpacity(0.9)),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  navbar.Navbar(),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          AnalyticsWidget(),
                          SizedBox(height: 20),
                          TransactionsWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: FloatingActionButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransactionForm()),
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: (isDarkMode? Colors.blue: Colors.orange.shade800),
                ),
              ),
            ]
          ),
        ),
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

class AnalyticsWidget extends StatelessWidget{
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      margin: EdgeInsets.all(10.0),
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
            Text('AnalyticsWidget'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Analytics1'),
                Text('Analytics2'),
                Text('Analytics3'),
              ],
            ),
            SizedBox(height: 20),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // async call to get messages
                    // getMessages();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Placeholder()),
                    );
                  },
                  child: const Text('Open Page'),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class TransactionsWidget extends StatelessWidget{
  const TransactionsWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.all(10.0),
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
            Text('TransactionsWidget'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Transaction1'),
                Text('Transaction2'),
                Text('Transaction3'),
              ],
            ),
          ],
        ),
      )
    );
  }
}
