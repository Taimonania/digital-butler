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
  final nameCon = new TextEditingController();
  final desCon = new TextEditingController();

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
        name: nameCon.value.text,
        description: desCon.value.text,
        localName: "false",
        picPath: "false"));
    print("A new meal was saved: " + controller.value.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: nameCon,
            decoration: InputDecoration(
              labelText: 'What did you get?',
            ),
            //onEditingComplete: _save, !!! changed this
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
        ListBody(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: desCon,
                decoration: InputDecoration(
                  labelText: 'How was the meal?',
                ),
                //onEditingComplete: _save,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
              //checking if the image is null
              child: _image == null
                  ? Text("image is not loaded")
                  : Image.file(_image)),
        ),
      ],
    );
  }
}
