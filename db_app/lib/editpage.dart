import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.title, this.description}) : super(key: key);
  final String title;
  final String description;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController controller = new TextEditingController();
  DataService service = new DataService();
  String picPath;
  MealList _meals;

  //file where the image is stored
  File _image;
  // future for getting the image
  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    final directory = await getApplicationDocumentsDirectory();
    picPath = directory.path;
    final File newImage = await image.copy('$picPath/test.png');

    setState(() {
      _image = image;
    });
  }

  _EditPageState() {
    _meals = new MealList();
  }

  void _save() {
    service.addMeal(MealItem(
        name: controller.value.text, localName: "false", picPath: "false"));
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
        Container(
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'How was the meal?',
            ),
            onEditingComplete: _save,
          ),
        ),
        Center(
            //checking if the image is null
            child: _image == null
                ? Text("image is not loaded")
                : Image.file(_image)),
      ],
    );
  }
}
