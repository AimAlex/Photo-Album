import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

void main() {
  runApp(const MyApp());
}

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImagePickerState();
  }
}

class MySecondPage extends StatelessWidget {
  final File img;
  const MySecondPage(this.img, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image photo = Image.file(img, fit: BoxFit.contain,);
    final size = ImageSizeGetter.getSize(FileInput(img));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Screen Image"),
      ),
      body:
        Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              // width: window.physicalSize.width,
              height: 600,
              child: photo,
            ),
            Text("Image width ${size.width} px"),
            Text("Image height ${size.height} px")
          ]
        ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<StatefulWidget> {
  final List<File> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Album 571"),
      ),
      body: Column(
          children: <Widget>[
            // _ImageView(_imgPath),
            Expanded(child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(_imagePaths.length, (index) {
                File img = _imagePaths[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySecondPage(img))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(img,
                      fit: BoxFit.none,
                )),
                );
              }),
            )),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text("Use Camera"),
            ),
            ElevatedButton(
              onPressed: _openGallery,
              child: const Text("Add from Photo"),
            ),
          ],
        )
    );
  }

  _takePhoto() async {
    var image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _imagePaths.add(File(image.path));
      }
    });
  }

  _openGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imagePaths.add(File(image.path));
      }
    });
  }
}
