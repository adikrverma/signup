import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _mobileNo;
  String? _email;
  List<String> _genres = [];
  List<String> _selectedGenres = [];
  String? _performanceType;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getGenres();
  }

  Future<void> _getGenres() async {
    setState(() {
      _loading = true;
    });
    final response = await http
        .get(Uri.parse('https://apimocha.com/flutterassignment/getGenres'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _genres = List<String>.from(
            data['data']['genres'].map((genre) => genre['name']));
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 24),
                  children: [
                    TextSpan(
                      text: "Let's create your ",
                    ),
                    TextSpan(
                      text: "Account",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text('First Name', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                onSaved: (String? value) {
                  _firstName = value;
                },
              ),
              SizedBox(height: 16.0),
              Text('Last Name', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                onSaved: (String? value) {
                  _lastName = value;
                },
              ),
              SizedBox(height: 16.0),
              Text('Mobile No.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8.0),
              Row(children: [
                Text('+91'),
                SizedBox(width: 8.0),
                Expanded(
                    child: TextFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onSaved: (String? value) {
                          _mobileNo = value;
                        }))
              ]),
              SizedBox(height: 16.0),
              Text('Email', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8.0),
              TextFormField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onSaved: (String? value) {
                    _email = value;
                  }),
              SizedBox(height: 16.0),
              Text('Genre', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                items: _genres
                    .map((genre) =>
                        DropdownMenuItem(child: Text(genre), value: genre))
                    .toList(),
                onChanged: (value) {
                  if (value != null && !_selectedGenres.contains(value)) {
                    setState(() {
                      _selectedGenres.add(value);
                    });
                  }
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              if (_loading)
                CircularProgressIndicator()
              else ...[
                Wrap(
                  spacing: 8.0,
                  children: [
                    for (final genre in _selectedGenres)
                      Chip(
                        backgroundColor: Color.fromARGB(255, 252, 133, 42),
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        label: Text(genre),
                        onDeleted: () {
                          setState(() {
                            _selectedGenres.remove(genre);
                          });
                        },
                      )
                  ],
                ),
                SizedBox(height: 16.0),
                Text('Performance', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                CheckboxListTile(
                    title: Text('In Person'),
                    value: _performanceType == 'In Person',
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _performanceType = 'In Person';
                        } else {
                          _performanceType = null;
                        }
                      });
                    }),
                CheckboxListTile(
                    title: Text('Virtual'),
                    value: _performanceType == 'Virtual',
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _performanceType = 'Virtual';
                        } else {
                          _performanceType = null;
                        }
                      });
                    }),
              ],
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 252, 133, 42))),
                  child: Text('Submit'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    print(_firstName);
                    print(_lastName);
                    print(_mobileNo);
                    print(_email);
                    print(_selectedGenres);
                    print(_performanceType);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
