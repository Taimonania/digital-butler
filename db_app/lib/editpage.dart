import 'dart:io';
import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController controller = new TextEditingController();
  DataService service = new DataService();
  MealList _meals;

  //file where the image is stored
  File _image;
  // future for getting the image
  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  _EditPageState() {
    _meals = new MealList();
  }

  void _save() {
    service.addMeal(MealItem(name: controller.value.text, tasty: false));
    print("A new meal was saved: " + controller.value.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Want to add a new meal?',
            ),
            onEditingComplete: _save,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _save,
                tooltip: 'Save',
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: getImage,
              ),
              Center(
                  //checking if the image is null
                  child: _image == null
                      ? Text("image is not loaded")
                      : Image.file(_image)),
              // this icon when pressed clears all of the meals saved which
              // is not desired
              // IconButton(
              //   icon: Icon(Icons.delete),
              //   onPressed: service.clearMeals,
              //   tooltip: 'Clear storage',
              // )
            ],
          ),
        ),
      ],
    );
  }
}
