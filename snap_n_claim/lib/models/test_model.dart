class Test {
  //variables
  String _name;
  int _age;

  //constructor
  Test(this._name, this._age);

  //getter and setters
  int get age => _age;

  set age(int value) {
    _age = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}