import 'dart:convert';

void main() {
  String jsonText = '''
  { 
    "name" : "celina",
    "isStudent" : true,
    "city" : "Kraków"
  }
  ''';

  final data = jsonDecode(jsonText);
  print("imie: ${data["name"]}");

  String jsonTab = '''
        [1,2,3,4,5]
    ''';
  for (var liczba in jsonDecode(jsonTab)) {
    print(liczba);
  }
  var tablica = jsonDecode(jsonTab);
  tablica = tablica.fold(0, (val1, val2) =>  val1 + val2);
  print("suma: $tablica");

  String jsonText2 = '''
    {
    "group": "Dart",
    "students": ["Ola", "Adam", "Kasia"]
    }
    ''';

  final data2 = jsonDecode(jsonText2);

  print("groupa: ${data2['group']}");
  for (var student in data2['students']) {
    print(student);
  }

  String jsonText3 = '''
    {
    "product": {
    "name": "Laptop",
    "price": 3500
    }
    }
    ''';

  final data3 = jsonDecode(jsonText3);

  print("produkt: ${data3['product']['name']}, cena: ${data3['product']['price']}");

  Future<void> test() async {
    print("A");

    await Future.delayed(Duration(seconds: 2));

    print("B");
  }
  test();
}
