import 'package:flutter/material.dart';
import 'Edit_Contact.dart';
import 'HomePage.dart';
import '../Model/Contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends StatefulWidget {
  final String id;
  ViewContact(this.id);
  @override
  _ViewContactState createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  String id;
  _ViewContactState(this.id);

  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  bool isLoading = true;

  Contact _contact;

  getContact(id) async{
    _databaseReference.child(id).onValue.listen((event){
      setState(() {
        _contact = Contact.fromSnapshotToContact(event.snapshot);
        isLoading=false;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    this.getContact(this.id);
  }

  callAction(String number)async{
    String url = 'tel: $number';
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Couldn not call $number';
    }  
  }

  smsAction(String number)async{
    String url = 'sms: $number';
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Couldn not send sms to $number';
    }
  }
  deleteContact()async{
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Delete Contact ?'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: ()async{
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return HomePage();
                  }
                ));
                await _databaseReference.child(id).remove();
              },
              child: Text('Yes'),
            )
          ],
        );
      }
    );

  }
  navigateToEditContact(id){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return EditContact(id);
    }));
  }

  navigateToLastScreen(BuildContext context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Container(
        child: isLoading ?
        Center(
          child: CircularProgressIndicator(),
        )
        : Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Center(
                    child: Container(
                      
                      child: Image(
                        fit: BoxFit.fitWidth,
                        image: _contact.photoUrl == "empty" ? 
                          AssetImage('images/person.png') : NetworkImage(_contact.photoUrl),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: <Widget>[              
                  ListTile(
                    leading:Icon(Icons.person),
                    title: Text('${_contact.fName} ${_contact.lName}'),
                  ),
                  ListTile(
                    leading:Icon(Icons.call),
                    title: Text(_contact.phone),
                    
                  ),
                  ListTile(                    
                    leading:Icon(Icons.alternate_email),
                    title: Text(_contact.email),
                  ),
                  ListTile(
                    leading:Icon(Icons.school),
                    title: Text(_contact.address),
                  ),
                ],
              ), 
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.message),
                            onPressed: (){
                              smsAction(_contact.phone);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: (){
                              navigateToEditContact(this.id);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: (){
                              deleteContact();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        onPressed: (){
          callAction(_contact.phone);
        },
      ),
    );  
  }
}