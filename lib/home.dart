import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_cropper/image_cropper.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  String _text;
  @override
  void initState() {
    _text = "";
  }

  bool isImageLoaded = false;

//  Future pickImage1() async {
//    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      pickedImage = tempStore;
//      isImageLoaded = true;
//    });
//  }
//
//  Future pickImage2() async {
//    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      pickedImage = tempStore;
//      isImageLoaded = true;
//    });
//  }
  Future pickImage(context,source) async {
    var tempFile = await ImagePicker.pickImage(
      source: source,
    );

    if(tempFile != null){
      setState(() {
        pickedImage = tempFile;
        isImageLoaded = true;
      //  _cropImage(pickedImage);
      });
    }
  }

//  _cropImage(File picked) async {
//    File cropped = await ImageCropper.cropImage(
//      androidUiSettings: AndroidUiSettings(
//        statusBarColor: Colors.red,
//        toolbarColor: Colors.red,
//        toolbarTitle: "Crop Image",
//        toolbarWidgetColor: Colors.white,
//      ),
//      sourcePath: picked.path,
//      aspectRatioPresets: [
//        CropAspectRatioPreset.original,
//        CropAspectRatioPreset.ratio16x9,
//        CropAspectRatioPreset.ratio4x3,
//      ],
//      maxWidth: 800,
//    );
//    if (cropped != null) {
//      setState(() {
//        pickedImage = cropped;
//      });
//    }
//  }
  Future readText() async {
    var tempText="";
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
          tempText=tempText+" "+word.text;
        }
        tempText=tempText+'\n';
      }
      tempText=tempText+'\n';
    }
    setState(() {
      _text=tempText;
    });
  }

  Future decode() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    for (Barcode readableCode in barCodes) {
      print(readableCode.displayValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SizedBox(height: 100.0),
                isImageLoaded
                    ? Center(
                  child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(pickedImage), fit: BoxFit.cover))),
                )
                    : Container(),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text('camera'),
                  onPressed:(){
                    pickImage(context,ImageSource.camera);
                  } ,
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text('gallery'),
                  onPressed:(){
                    pickImage(context, ImageSource.gallery);
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text('Read Text'),
                  onPressed: readText,
                ),
//            RaisedButton(
//              child: Text('Read Bar Code'),
//              onPressed: decode,
//            ),
                SizedBox(height: 10,),
                Container(child:
                Text(_text),),
              ],
            ),
          ),
        ));
  }
}