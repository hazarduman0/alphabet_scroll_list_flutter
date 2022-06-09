import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

class _AZItem extends ISuspensionBean {
  final String? title;
  final String? tag;

  _AZItem({required this.title, required this.tag});

  @override
  String getSuspensionTag() => tag!;
}

class AlphabetScrollPage extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onclickedItem;
  const AlphabetScrollPage(
      {Key? key, required this.items, required this.onclickedItem})
      : super(key: key);

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<_AZItem> items = [];
  late final ValueChanged<String> onClickedItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList(widget.items);
  }

  void initList(List<String> items) {
    this.items = items
        .map((item) => _AZItem(title: item, tag: item[0].toUpperCase()))
        .toList();

    setState(() {
      SuspensionUtil.sortListBySuspensionTag(this.items);
      SuspensionUtil.setShowSuspensionStatus(this.items);
    });
  }

  @override
  Widget build(BuildContext context) => AzListView(
        padding: const EdgeInsets.all(16.0),
        data: items,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildListItem(item);
        },
        indexBarMargin: const EdgeInsets.all(10.0),
        indexHintBuilder: (context, hint) => Container(
          width: 64.0,
          height: 60.0,
          decoration:
              const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            hint,
            style: const TextStyle(color: Colors.white, fontSize: 30.0),
          ),
        ),
        indexBarOptions: const IndexBarOptions(
          needRebuild: true,
          selectTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          selectItemDecoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          indexHintAlignment: Alignment.centerRight,
          indexHintOffset: Offset(-20, 0),
        ),
      );

  Widget _buildListItem(_AZItem item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(
      children: [
        Offstage(offstage: offstage, child:  buildHeader(tag),),
        ListTile(
          title: Text(item.title!),
          onTap: () => widget.onclickedItem(item.title!),
        ),
      ],
    );
  }

  Widget buildHeader(String tag) => Container(
        height: 40.0,
        margin: const EdgeInsets.only(right: 20.0),
        padding: const EdgeInsets.only(left: 20.0),
        color: Colors.grey.shade300,
        alignment: Alignment.centerLeft,
        child: Text(
          '$tag',
          softWrap: false,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      );
}
