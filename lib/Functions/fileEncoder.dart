import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class EncodingConverter extends StatefulWidget {
  @override
  _EncodingConverterState createState() => _EncodingConverterState();
}

class _EncodingConverterState extends State<EncodingConverter> {
  String _selectedEncoding = 'shift_jis';
  List<File> _selectedFiles = [];
  String _outputText = '';

  void _convertFiles() async {
    if (_selectedFiles.isEmpty) {
      setState(() {
        _outputText = 'Please select files first.';
      });
      return;
    }

    String inputEncoding = _selectedEncoding;
    String outputEncoding = inputEncoding == 'utf8' ? 'shift_jis' : 'utf8';

    for (File selectedFile in _selectedFiles) {
      List<int> bytes = await selectedFile.readAsBytes();
      String inputText = inputEncoding == 'utf8' ? utf8.decode(bytes) : latin1.decode(bytes);
      List<int> outputBytes = outputEncoding == 'utf8' ? utf8.encode(inputText) : latin1.encode(inputText);

      String outputPath = await _getOutputFilePath(selectedFile.path);
      File outputFile = File(outputPath);
      await outputFile.writeAsBytes(outputBytes);
    }

    setState(() {
      _outputText = 'File conversion successful. Output files saved in the same folder as the input files.';
    });
  }

  Future<String> _getOutputFilePath(String inputPath) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String outputFileName = _selectedEncoding == 'utf8' ? 'output_shift_jis.txt' : 'output_utf8.txt';
    return '${appDocumentsDirectory.path}/$outputFileName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lime,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 省略...

              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [''],
                    allowMultiple: true,
                  );
                  if (result != null) {
                    List<File> selectedFiles = result.files.map((platformFile) => File(platformFile.path!)).toList();
                    setState(() {
                      _selectedFiles = selectedFiles;
                    });
                  } else {
                    print('File selection cancelled.'); // デバッグ用のメッセージ
                  }
                },
                child: Text('Select Files'),
              ),

              // 省略...

              SizedBox(height: 16),
              if (_selectedFiles.isNotEmpty)
                Text('Selected Files: ${_selectedFiles.map((file) => file.path).join(', ')}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _convertFiles,
                child: Text('Convert and Output'),
              ),
              SizedBox(height: 16),
              Text(_outputText),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EncodingConverter(),
  ));
}
