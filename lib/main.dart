import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Galaxy Motion Photo Extractor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_status',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
                onPressed: () async {
                  if (!(await SimplePermissions.checkPermission(
                      Permission.WriteExternalStorage))) {
                    SimplePermissions.requestPermission(
                        Permission.WriteExternalStorage);
                  }
                  Directory externalStorageDir =
                      await getExternalStorageDirectory();
                  Directory cameraDir =
                      Directory(externalStorageDir.path + '/DCIM/Camera');
                  await for (var file in cameraDir.list()) {
                    if (file.path.endsWith('.jpg')) {
                      if (file.path.endsWith('20181226_232123.jpg')) {
                        var mp4TargetPath = file.path + '.mp4';
                        if (!(await File(mp4TargetPath).exists())) {
                          setState(() {
                            _status = 'Hi!';
                          });
                          var bytes = await File(file.path).readAsBytes();
                          var found = -1;
                          setState(() {
                            _status = 'File is ${bytes.length} large';
                          });
                          for (var i = 0; i < bytes.length - 16; i++) {
                            if (bytes[i] == 'M'.codeUnitAt(0) &&
                                bytes[i + 1] == 'o'.codeUnitAt(0) &&
                                bytes[i + 2] == 't'.codeUnitAt(0) &&
                                bytes[i + 3] == 'i'.codeUnitAt(0) &&
                                bytes[i + 4] == 'o'.codeUnitAt(0) &&
                                bytes[i + 5] == 'n'.codeUnitAt(0) &&
                                bytes[i + 6] == 'P'.codeUnitAt(0) &&
                                bytes[i + 7] == 'h'.codeUnitAt(0) &&
                                bytes[i + 8] == 'o'.codeUnitAt(0) &&
                                bytes[i + 9] == 't'.codeUnitAt(0) &&
                                bytes[i + 10] == 'o'.codeUnitAt(0) &&
                                bytes[i + 11] == '_'.codeUnitAt(0) &&
                                bytes[i + 12] == 'D'.codeUnitAt(0) &&
                                bytes[i + 13] == 'a'.codeUnitAt(0) &&
                                bytes[i + 14] == 't'.codeUnitAt(0) &&
                                bytes[i + 15] == 'a'.codeUnitAt(0)) {
                              found = i;
                              break;
                            }
                          }
                          setState(() {
                            _status = 'Found at $found';
                          });
                          if (found >= 0) {
                            File(mp4TargetPath)
                                .writeAsBytes(bytes.skip(found + 16).toList());
                            setState(() {
                              _status = 'Written';
                            });
                          }
                        }
                      }
                    }
                  }
                },
                child: Text('Scan Images'))
          ],
        ),
      ),
    );
  }
}
