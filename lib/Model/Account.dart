class Account{
  String _id;
  String _accountNumber;
  double _solde;
  double _credit;
  Account();
  Map<String,dynamic> toJson()=>{
    'id':_id,
    'accountNumber':_accountNumber,
    'solde':_solde,
    'credit':_credit,

  };
  Account.fromJson(Map<String,dynamic> json)
      : _id = json["id"],
      _accountNumber = json["accountNumber"],
      _solde= json["solde"],
      _credit=json["credit"];


  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get accountNumber => _accountNumber;

  double get credit => _credit;

  set credit(double value) {
    _credit = value;
  }

  double get solde => _solde;

  set solde(double value) {
    _solde = value;
  }

  set accountNumber(String value) {
    _accountNumber = value;
  }

  @override
  String toString() {
    return 'Account{_id: $_id, _accountNumber: $_accountNumber, _solde: $_solde, _credit: $_credit}';
  }
}