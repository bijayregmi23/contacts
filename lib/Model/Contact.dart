import 'package:firebase_database/firebase_database.dart';

class Contact {

  String _id,_fName,_lName,_phone,_email,_address,_photoUrl;
  
  //Constructor For Add Contact
  Contact(this._fName,this._lName,this._phone,this._email,this._address,this._photoUrl);

  //Constructor For Edit Contact (with ID)
  Contact.withId(this._id,this._fName,this._lName,this._phone,this._email,this._address,this._photoUrl);

  //Getters
  String get id=>this._id;
  String get fName=>this._fName;
  String get lName=>this._lName;
  String get phone=>this._phone;
  String get email=>this._email;
  String get address=>this._address;
  String get photoUrl=>this._photoUrl;

  //Setters
  set fName(String fName){
    this._fName=fName;
  }
  set lName(String lName){
    this._lName=lName;
  }
  set phone(String phone){
    this._phone=phone;
  }
  set email(String email){
    this._email=email;
  }
  set address(String address){
    this._address=address;
  }
  set photoUrl(String photoUrl){
    this._photoUrl=photoUrl;
  }

  //From Snapshot(json object) to Contact
  Contact.fromSnapshotToContact(DataSnapshot snapshot){
    this._id=snapshot.key;
    this._fName=snapshot.value['fName'];
    this._lName=snapshot.value['lName'];
    this._phone=snapshot.value['phone'];
    this._email=snapshot.value['email'];
    this._address=snapshot.value['address'];
    this._photoUrl=snapshot.value['photoUrl'];
  }

  //From Contact to Snapshot(json object)
  Map<String,dynamic> fromContactToSnapshot(){
    return{
      'fName': _fName,
      'lName': _lName,
      'phone': _phone,
      'email': _email,
      'address': _address,
      'photoUrl': _photoUrl
    };
  }
}