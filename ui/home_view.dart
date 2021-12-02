import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api.dart';
import 'package:crypto_wallet/net/flutter_fire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_view.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double dogecoin = 0.0;

  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = (await getPrice('bitcoin'))!;
    ethereum = (await getPrice('ethereum'))!;
    dogecoin = (await getPrice('dogecoin'))!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == 'bitcoin') return bitcoin * amount;
      if (id == 'ethereum') return ethereum * amount;
      if (id == 'dogecoin') return dogecoin * amount;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Coins')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                    children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.blue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Coin Name : ${document.id}',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          Text(
                            "Amount Owned : \$${document['Amount']}",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              await removeCoin(document.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList());
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddView(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

//\$${getValue(document.id, document['Amount'])?.toStringAsFixed(2)}"
