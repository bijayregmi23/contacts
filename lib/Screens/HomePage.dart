import 'package:flutter/material.dart';
import 'Add_Contact.dart';
import 'View_Contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  //Navigate to Add Contact
  navigateToAddContact(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return AddContact();
      }
    ));
  }

  //Navigate to View Contact for certain ID
  navigateToViewContact(id){
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return ViewContact(id);
      }
    ));
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation,int index){
            return GestureDetector(
              onTap: (){
                navigateToViewContact(snapshot.key);
              },
              child: Card(
//                color: Colors.tealAccent,
                elevation: 2.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      //Image
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: snapshot.value['photoUrl']=='empty'?
                                AssetImage('images/person.png'): NetworkImage(snapshot.value['photoUrl']),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //First Name Last Name
                            Text(
                              '${snapshot.value['fName']} ${snapshot.value['lName']} '
                            ),
                            //Phone
                            Text(
                              '${snapshot.value['phone']}'
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddContact,
      ),
    );
  }
}