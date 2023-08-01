import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_view/split_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedFunctionIndex = 0;

  final List<String> functionList = [
    'Encode Change',
    'Merge Files',
    'Function 3',
    // Add more functions as needed
  ];

  final SplitViewController _splitViewController = SplitViewController(
    weights: [0.2],
    limits: [WeightLimit(min: 0.1, max: 0.9)],
  );

  Widget _getSelectedWidget() {
    switch (_selectedFunctionIndex) {
      case 0:
        return Container(
          color: Colors.red,
          child: Center(
            child: Text('Function 1 Widget'),
          ),
        );
      case 1:
        return Container(
          color: Colors.white10,
          child: Center(
            child: Text('Function 2 Widget'),
          ),
        );
      case 2:
        return Container(
          color: Colors.lime,
          child: Center(
            child: Text('Function 3 Widget'),
          ),
        );
    // Add more cases for each function's corresponding widget
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green, // APPバーの背景色を緑に変更
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4), // ラインの高さを設定
          child: Divider(
            height: 4, // ラインの高さを設定（前述のPreferredSizeと同じ値にする必要があります）
            thickness: 4, // ラインの太さを設定
            color: Colors.grey, // ラインの色を設定
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black54), // アイコンの色を白に設定
            onPressed: () {
              // 家アイコンが押されたときの処理
              print('Home Icon Pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.folder, color: Colors.black54), // アイコンの色を白に設定
            onPressed: () {
              // フォルダアイコンが押されたときの処理
              print('Folder Icon Pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black54), // アイコンの色を白に設定
            onPressed: () {
              // 歯車アイコンが押されたときの処理
              print('Settings Icon Pressed');
            },
          ),
        ],
      ),
      body: SplitView(
        controller: _splitViewController,
        viewMode: SplitViewMode.Horizontal,
        children: [
          Container(
            width: 350,
            color: Colors.green,
            child: ListView.builder(
              itemCount: functionList.length,
              itemBuilder: (context, index) {
                // 選択された項目の背景色とテキスト色を設定
                bool isSelected = index == _selectedFunctionIndex;
                return ListTile(
                  title: Text(
                    functionList[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  tileColor: isSelected ? Colors.blue.shade100 : null,
                  onTap: () {
                    setState(() {
                      _selectedFunctionIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          _getSelectedWidget(),
        ],
      ),
    );
  }
}
