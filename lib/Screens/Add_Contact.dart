import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:contacts/Model/Contact.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}


class _AddContactState extends State<AddContact> {
  
  DatabaseReference _databaseReference =FirebaseDatabase.instance.reference();

  String _fName = '',_lName = '',_phone = '',_email = '',_address = '',_photoUrl = 'empty';

  navigateToLastScreen(BuildContext context){
    Navigator.of(context).pop();
  }

  saveContact(BuildContext context)async{
    if(
      _fName.isNotEmpty &&
      _lName.isNotEmpty &&
      _phone.isNotEmpty &&
      _email.isNotEmpty &&
      _address.isNotEmpty
    )
    {
      Contact contact = Contact(this._fName, this._lName, this._phone, this._email, this._address, this._photoUrl);

      //Uploading Contact Snapshot Format
      await _databaseReference.push().set(contact.fromContactToSnapshot());
      navigateToLastScreen(context);
    }
    else{
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Error !'),
            content: Text('All Fields are required !'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: (){
                  // Navigator.pop(context);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }
  Future pickImage() async{
    File file=await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    String fileName = basename(file.path);
    uploadImage(file,fileName);
  }
  void uploadImage(File file, String fileName) async{
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    storageReference.putFile(file).onComplete.then((firebaseFile) async{
      var downloadUrl=await firebaseFile.ref.getDownloadURL();

      setState((){
        _photoUrl=downloadUrl;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: this.pickImage,
                  child: Center(
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _photoUrl == "empty" ? 
                          AssetImage('images/person.png') : NetworkImage(_photoUrl)
                        )
                      ),
                    ),
                  ),
                ),
              ),
              //First Name
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                     _fName=value; 
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              //Last Name
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                     _lName=value; 
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              //Phone
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                     _phone=value; 
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              //Email
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                     _email=value; 
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              //Address
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                     _address=value; 
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              //Save
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: (){
                    saveContact(context);
                  },
                  color: Colors.indigoAccent,
                  child: Text('Save',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}