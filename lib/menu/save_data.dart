import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/model/database_helper.dart';
import 'package:path_provider/path_provider.dart';

class SaveData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FormSaveData();
}

class _Data {
  String text = '';
}

class _FormSaveData extends State<SaveData> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _Data _data = new _Data();
  var txt = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _readTxt();
  }

  void submitSave() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      _save();
      _saveDt();
      _saveTxt();
    }
  }

    void submitRead() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      _read();
      _readDt();
      _readTxt();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Save text'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType: TextInputType
                        .emailAddress, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Hello Word',
                        labelText: 'input Text'),
                    onSaved: (String value) {
                      this._data.text = value;
                    },
                    initialValue: txt.text,
                    ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Save Data',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submitSave,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Read Data',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submitRead,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }

  // Replace these two methods in the examples that follow
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = prefs.getString(key) ?? 0;
    this._data.text = value;
    print('read shared: $value');
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = this._data.text;
    prefs.setString(key, value);
    print('saved shared: $value');
  }

  _readDt() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 14;
    Word word = await helper.queryWord(rowId);
    if (word == null) {
      print('Database-> read row $rowId: empty');
    } else {
      this._data.text = word.word;
      print('Database-> read row $rowId: ${word.word} ${word.frequency}');
    }
  }

  _saveDt() async {
    Word word = Word();
    word.word = this._data.text;
    word.frequency = 15;
    print("befor -> ${word.word}");
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(word);
    print('Database-> inserted row $id: ${word.word}');
  }

  _readTxt() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/test_file.txt');
      String text = await file.readAsString();
      txt.text = text;
      print(text);
    } catch (e) {
      print("Couldn't read File");
    }
  }

  _saveTxt() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/test_file.txt');
    final text = this._data.text;
    await file.writeAsString(text);
    print('Saved to File : $text');
  }
}
