import 'Account.dart';
class Client{
  String _id;
  String _firstName;
  String _lastName;
  String _address;
  String _tel;
  Account _account;
  String _token;

  Client();
  Map<String,dynamic> toJson() =>{
    "id":_id,
    "firstName":_firstName,
    "lastName":_lastName,
    "address":_address,
    "tel":_tel,
    "token":_token,
    "account":_account
  };

  Client.fromJson(Map<String,dynamic> json)
  : _id=json["id"],
   _firstName=json["firstName"],
   _lastName=json["lastName"],
   _address=json["address"],
   _tel=json["tel"],
  _token=json["token"],
  _account=Account.fromJson(json["account"]);
  
  String get id => _id;

  String get token => _token;
  set token(String value) {
    _token = value;
  }

  set id(String value) {
    _id = value;
  }

  String get firstName => _firstName;

  Account get account => _account;

  set account(Account value) {
    _account = value;
  }





  String get tel => _tel;

  set tel(String value) {
    _tel = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  set firstName(String value) {
    _firstName = value;
  }

  @override
  String toString() {
    return 'Client{_id: $_id, _firstName: $_firstName, _lastName: $_lastName, _address: $_address, _tel: $_tel, _account: $_account, _token: $_token}';
  }
}