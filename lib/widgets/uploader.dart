import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/image_uploader_result.dart';

class Uploader extends StatefulWidget {
  Uploader(this.file, this.filePath, {this.onCompleted}) : assert(file != null);

  final File file;
  final String filePath;
  final Function(ImageUploaderResult) onCompleted;

  @override
  State<StatefulWidget> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://only-kids.appspot.com/');

  StorageUploadTask _uploadTask;

  @override
  void initState() {
    _startUpload();
    super.initState();
  }

  void _startUpload() {
    String filePath = widget.filePath ?? 'hairstyles/${DateTime.now()}.jpg';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    _uploadTask.onComplete.then((e) async {
      final url = await e.ref.getDownloadURL();
      print(url);
      if (widget.onCompleted != null) {
        widget.onCompleted(ImageUploaderResult(downloadUrl: url, imageStoragePath: filePath));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: _uploadTask.events,
      builder: (_, snapshot) {
        var event = snapshot?.data?.snapshot;

        double progressFraction = event != null ? event.bytesTransferred / event.totalByteCount : 0;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_uploadTask.isComplete) Text('Upload completed! 🎉🎉🎉'),
              if (_uploadTask.isPaused)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),
                ),
              if (_uploadTask.isInProgress)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),
                ),
              LinearProgressIndicator(
                value: progressFraction,
                backgroundColor: Theme.of(context).colorScheme.background,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primaryVariant),
              ),
              Text('${(progressFraction * 100).toStringAsFixed(2)} % '),
            ],
          ),
        );
      },
    );
  }
}
