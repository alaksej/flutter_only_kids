import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/image_uploader_result.dart';
import 'package:cross_file/src/types/interface.dart';


class Uploader extends StatefulWidget {
  Uploader(this.file, this.filePath, {this.onCompleted}) : assert(file != null);

  final XFile file;
  final String filePath;
  final Function(ImageUploaderResult)? onCompleted;

  @override
  State<StatefulWidget> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://only-kids.appspot.com/');

  UploadTask? _uploadTask;

  @override
  void initState() {
    _startUpload();
    super.initState();
  }

  void _startUpload() {
    String filePath = widget.filePath ?? 'hairstyles/${DateTime.now()}.jpg';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(File(widget.file.path));
    });

    _uploadTask!.whenComplete(() => null).then((e) async {
      final url = await e.ref.getDownloadURL();
      print(url);
      if (widget.onCompleted != null) {
        widget.onCompleted!(ImageUploaderResult(downloadUrl: url, imageStoragePath: filePath));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: _uploadTask?.snapshotEvents,
      builder: (_, snapshot) {
        var event = snapshot?.data;

        double progressFraction = event != null ? event.bytesTransferred / event.totalBytes : 0;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (progressFraction == 1) Text('Upload completed! 🎉🎉🎉'),
              // TODO: fix paused
              if (false)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: _uploadTask?.resume,
                  ),
                ),
              if (progressFraction > 0 && progressFraction < 1)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: _uploadTask?.pause,
                  ),
                ),
              LinearProgressIndicator(
                value: progressFraction,
                backgroundColor: Theme.of(context).colorScheme.background,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              ),
              Text('${(progressFraction * 100).toStringAsFixed(2)} % '),
            ],
          ),
        );
      },
    );
  }
}
