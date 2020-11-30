import 'dart:io';
import 'package:flutter/material.dart';
import 'data_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
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
  String imgPath = '';
  // future for getting the image
  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    );
    //final directory = await getApplicationDocumentsDirectory();

    image == null ? imgPath = '' : imgPath = image.path;
    File newImage = File(imgPath);
    //final File newImage = await newImage.copy(newImage.path);

    setState(() {
      _image = newImage;
    });
  }

  // location code -----
  Location mealLocation = new Location();
  String location = '';
  Future getMealLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await mealLocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await mealLocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await mealLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await mealLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await mealLocation.getLocation();

    setState(() {
      location = _locationData.toString();
    });
  }
  //--------------------

  _EditPageState() {
    _meals = new MealList();
  }

  void _save() {
    service.addMeal(MealItem(
      name: nameCon.value.text,
      description: desCon.value.text,
      localName: "false",
      picPath: imgPath,
      coords: location,
    ));
    print("A new meal was saved: " + controller.value.text);
    imgPath = '';
    controller.clear();
    nameCon.clear();
    desCon.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                  icon: Icon(Icons.save, color: Colors.redAccent),
                  onPressed: _save,
                  tooltip: 'Save',
                  splashColor: Colors.green[100],
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: desCon,
              minLines: 4,
              maxLines: 24,
              decoration: InputDecoration(
                labelText: 'How was the meal?',
              ),
              //onEditingComplete: _save,
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    //checking if the image is null
                    child: imgPath == ''
                        ? Text("take a pic...")
                        : Image.file(
                            _image,
                            width: 330,
                            height: 330,
                          )),
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: getImage,
                  splashColor: Colors.lightBlue,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.redAccent[100]),
                alignment: Alignment.center,
              ),
              Container(
                  margin: EdgeInsets.all(16),
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                      //checking if the image is null
                      child: location == ''
                          ? Text("where did you eat?")
                          : Text('saved'))),
              Container(
                child: IconButton(
                  icon: Icon(Icons.map),
                  onPressed: getMealLocation,
                  splashColor: Colors.red[100],
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green[100]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
