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
      title: 'Galaxy Motion Photo Extractor',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Galaxy Motion Photo Extractor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Welcome, please press one of these buttons!';
  bool running = false;
  bool cancellationRequested = false;

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
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '$_status',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                        onPressed: running
                            ? null
                            : () {
                                doit(true);
                              },
                        child: Text('Dry Run')),
                    RaisedButton(
                        onPressed: running
                            ? null
                            : () {
                                doit(false);
                              },
                        child: Text('Do It for Real!')),
                    RaisedButton(
                        onPressed: !running && !cancellationRequested
                            ? null
                            : () {
                                if (running) {
                                  cancellationRequested = true;
                                }
                              },
                        child: Text('Cancel'))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void doit(bool dryRun) async {
    setState(() {
      running = true;
    });
    try {
      if (!(await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage))) {
        SimplePermissions.requestPermission(Permission.WriteExternalStorage);
      }
      Directory externalStorageDir = await getExternalStorageDirectory();
      Directory cameraDir = Directory(externalStorageDir.path + '/DCIM/Camera');
      int scanned = 0;
      int extracted = 0;
      int already = 0;
      int notFound = 0;
      String previous = '';
      await for (var file in cameraDir.list()) {
        if (cancellationRequested) {
          setState(() {
            _status = 'Canceled.';
          });
          return;
        }
        if (file.path.endsWith('.jpg')) {
          var mp4TargetPath = file.path + '.mp4';
          if ((await File(mp4TargetPath).exists())) {
            already += 1;
          } else {
            var bytes = await File(file.path).readAsBytes();
            var found = -1;
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
            if (found >= 0) {
              if (!dryRun) {
                await File(mp4TargetPath)
                    .writeAsBytes(bytes.skip(found + 16).toList(), flush: true);
              }
              extracted += 1;
              previous = '\n\nLast written: $mp4TargetPath';
            } else {
              notFound += 1;
            }
          }
          if ((await File(mp4TargetPath).exists())) {
            File(mp4TargetPath)
                .setLastAccessedSync(File(file.path).lastAccessedSync());
            File(mp4TargetPath)
                .setLastModifiedSync(File(file.path).lastModifiedSync());
          }
          scanned += 1;
          setState(() {
            _status =
                'Scanned $scanned files, $extracted ${dryRun ? 'to extract' : 'extracted'}, $already already extracted, $notFound not found$previous';
          });
        }
      }
    } finally {
      cancellationRequested = false;
      running = false;
    }
  }
}
