import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../Model/Contact.dart';
import 'dart:io';


class EditContact extends StatefulWidget {
  
  String id;
  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  
  String id;
  _EditContactState(this.id);

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  Contact _contact;
  bool isLoading=true;

  String _fName='';
  String _lName='';
  String _phone='';
  String _email='';
  String _address='';
  String _photoUrl;

  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  
  getContact(id)async{
      _databaseReference.child(id).onValue.listen((event){
        _contact=Contact.fromSnapshotToContact(event.snapshot);
        _fNameController.text=_contact.fName;
        _lNameController.text=_contact.lName;
        _phoneController.text=_contact.phone;
        _emailController.text=_contact.email;
        _addressController.text=_contact.address;
        setState(() {
          _fName=_contact.fName;
          _lName=_contact.lName;
          _phone=_contact.phone;
          _email=_contact.email;
          _address=_contact.address;
          _photoUrl=_contact.photoUrl;
          isLoading=false; 
        });
      });
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

  navigateToLastScreen(BuildContext context){
    Navigator.pop(context);
  }

  updateContact(BuildContext context)async{
    if(
      _fName.isNotEmpty &&
      _lName.isNotEmpty &&
      _phone.isNotEmpty &&
      _email.isNotEmpty &&
      _address.isNotEmpty
    )
    {
      Contact contact=Contact.withId(this.id,this._fName, this._lName,this. _phone, this._email, this._address, this._photoUrl);
      await _databaseReference.push().set(contact.fromContactToSnapshot());
      navigateToLastScreen(context);
    }
    else{
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Error'),
            content: Text('All Fields Required !'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }

  @override
  void initState(){
    super.initState();
    this.getContact(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("images/person.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _fName = value;
                          });
                        },
                        controller: _fNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lName = value;
                          });
                        },
                        controller: _lNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updateContact(context);
                        },
                        color: Colors.indigoAccent,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
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