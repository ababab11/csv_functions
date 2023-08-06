import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'csvFilesPicker.dart'; // CsvFilePickerをインポートします
// ...

class MergeCsv extends StatefulWidget {
  @override
  _MergeCsvState createState() => _MergeCsvState();
}

class _MergeCsvState extends State<MergeCsv> {
  // マージ処理中かどうかを示すフラグ
  bool isMerging = false;

  // 保存したファイルのパスを保持する変数
  String savedFilePath = '';

  // CSVファイルの選択、マージ、保存を行うメソッド
  void _importAndMergeCSV() async {
    // マージ処理中フラグをtrueに設定して、ボタンを無効化
    setState(() {
      isMerging = true;
    });

    // CsvFilePickerインスタンスを作成し、ユーザーが選択したCSVファイルのリストを取得
    CsvFilePicker csvFilePicker = CsvFilePicker();
    List<FileSystemEntity> csvFiles = await csvFilePicker.pickCsvFiles();

    // 選択されたすべてのCSVファイルの内容を読み込んでマージ
    String mergedCsvContent = '';
    for (var file in csvFiles) {
      String csvContent = await File(file.path).readAsString();
      mergedCsvContent += csvContent;
    }

    // マージしたCSVファイルを保存
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    File outputFile = File('${appDocumentsDirectory.path}/merged_file.csv');
    await outputFile.writeAsString(mergedCsvContent);

    // 保存したファイルのパスを保持
    savedFilePath = outputFile.path;

    // マージ処理中フラグをfalseに設定して、ボタンを再度有効化
    setState(() {
      isMerging = false;
    });

    // 成功ダイアログを表示
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CSV files merged and saved as "merged_file.csv".'),
              SizedBox(height: 8),
              Text('Saved File Path: $savedFilePath'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('CSV File Merge'),
      // ),
      body: Container(
        color: Colors.lime,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // プログラムの説明を表示
              Text(
                'This application allows the user to merge multiple CSV files and save the merged content as a new CSV file. '
                    'Tap the "Start Merging" button to select CSV files, merge them, and save the merged content as "merged_file.csv". '
                    'The merging process will be indicated with a loading indicator. '
                    'After the merging is complete, a success dialog will display the saved file path.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // マージ処理の開始ボタン
              ElevatedButton(
                onPressed: isMerging ? null : _importAndMergeCSV, // マージ中はボタンを無効化
                child: Text('Start Merging'),
              ),
              SizedBox(height: 20),
              if (isMerging)
                Column(
                  children: [
                    // マージ処理中はローディングインジケータを表示
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    // マージ処理中のメッセージを表示
                    Text('Merging CSV files... Please wait.'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}