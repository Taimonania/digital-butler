import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:language_pickers/language_picker_dialog.dart';
import 'package:language_pickers/language_pickers.dart';
import 'package:language_pickers/languages.dart';
import 'output.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:progress_dialog/progress_dialog.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  var myToLanguage = 'en';
  var myFromLanguage = 'en';
  var myFromLanguageName = 'English';
  var myToLanguageName = 'English';
  var ocrLanguageCode = 'eng';

  Language _selectedFromDialogLanguage =
      LanguagePickerUtils.getLanguageByIsoCode('en');
  Language _selectedToDialogLanguage =
      LanguagePickerUtils.getLanguageByIsoCode('en');

// It's sample code of Dialog Item.
  Widget _buildDialogItem(Language language) => Row(
        children: <Widget>[
          Text(
            language.name,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
          ),
          SizedBox(width: 4.0),
          Flexible(
              child: Text(
            "(${language.isoCode})",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
          ))
        ],
      );

  void openFromLanguagePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.red),
            child: LanguagePickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.redAccent,
                searchInputDecoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
                ),
                isSearchable: true,
                title: Text(
                  'Select your language',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                onValuePicked: (Language language) => setState(() {
                      _selectedFromDialogLanguage = language;
                      myFromLanguageName = _selectedFromDialogLanguage.name;
                      myFromLanguage = _selectedFromDialogLanguage.isoCode;
                      ocrLanguageCode = getOcrLanguageCode(
                          _selectedFromDialogLanguage.isoCode);
                    }),
                itemBuilder: _buildDialogItem)),
      );

  String getOcrLanguageCode(String isoCode) {
    String ocrLangCode = 'eng';
    switch (isoCode) {
      case 'en':
        ocrLangCode = 'eng';
        break;
      case 'zh_Hans':
        ocrLangCode = 'chs';
        break;
      case 'zh_Hant':
        ocrLangCode = 'cht';
        break;
      case 'ja':
        ocrLangCode = 'jpn';
        break;
      case 'jv':
        ocrLangCode = 'jpn';
        break;
      case 'ko':
        ocrLangCode = 'kor';
        break;
      default:
        break;
    }
    return ocrLangCode;
  }

  void openToLanguagePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.red),
            child: LanguagePickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.redAccent,
                searchInputDecoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
                ),
                isSearchable: true,
                title: Text(
                  'Select your language',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                onValuePicked: (Language language) => setState(() {
                      _selectedToDialogLanguage = language;
                      myToLanguageName = _selectedToDialogLanguage.name;
                      myToLanguage = _selectedToDialogLanguage.isoCode;
                    }),
                itemBuilder: _buildDialogItem)),
      );

  parseTheText(ImageSource source) async {
    final imageFile = await ImagePicker()
        .getImage(source: source, maxWidth: 700, maxHeight: 1000);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
        message: 'Translating...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progress: 0.0,
        maxProgress: 100.0,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    if (croppedFile != null) {
      progressDialog.show();
    }

    var bytes = Io.File(croppedFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64image": "data:image/jpg;base64,${img64.toString()}",
      "language": ocrLanguageCode
    };
    var header = {"apiKey": "ab1a430f1788957"};
    var post = await http.post(url, body: payload, headers: header);

    var result = jsonDecode(post.body);
    String parsedText = result['ParsedResults'][0]['ParsedText'];
    print(' Parsed text is $parsedText and whole result is ${post.body}');
    if (parsedText.length > 0) {
      final translator = GoogleTranslator();
      var translation = await translator.translate(parsedText,
          from: myFromLanguage, to: myToLanguage);
      print(translation);
      progressDialog.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OutputScreen(img64.toString(), translation.toString())));
    } else {
      progressDialog.hide();
      print("error");
      Fluttertoast.showToast(
          msg: 'Please Pick Other one',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'Translate',
      //     style: GoogleFonts.poppins(
      //         textStyle: TextStyle(
      //       color: Colors.white,
      //       fontSize: 18,
      //       fontWeight: FontWeight.w500,
      //     )),
      //   ),
      //   backgroundColor: Colors.red[300],
      // ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  openFromLanguagePickerDialog();
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            myFromLanguageName,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  openToLanguagePickerDialog();
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            myToLanguageName,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          parseTheText(ImageSource.camera);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 16,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            'Camera',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          parseTheText(ImageSource.gallery);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 16,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Text(
                            'Gallery',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 64)
            ],
          )),
    );
  }
}
