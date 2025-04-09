import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/main_screen/Widgets/TaskCard.dart';

import '../colors.dart';
import 'Widgets/modalwindow.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var scroll = ScrollController();

  double margin = 20.0;

  Future loadData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String>? dt = _prefs.getStringList('datas');
    List<Map<String, dynamic>> datas = [];

    for (int i = 0; i < dt!.length; i++) {
      datas.add(jsonDecode(dt[i]));
    }

    return datas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          Text(
            "Задачи",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),

          FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                itemBuilder: (context, i) {
                  return CardTask(
                    i: i,
                    textColor: textcolors[i % textcolors.length],
                    backgroundColor: colors[i % colors.length],
                    data: snapshot.data[i],
                  );
                },
                itemCount: snapshot.data.length,
                // onReorder: (oldIndex, newIndex) {
                //   setState(() {
                //     if (newIndex > oldIndex) {
                //       newIndex = newIndex - 1;
                //     }
                //     final newcolor = colors.removeAt(oldIndex);
                //     final newtextcolor = textcolors.removeAt(oldIndex);
                //     final newInfo = Infos.removeAt(oldIndex);
                //     colors.insert(newIndex, newcolor);
                //     textcolors.insert(newIndex, newtextcolor);
                //     Infos.insert(newIndex, newInfo);
                //   });
                // },
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      switch (notification.extent.toStringAsFixed(1)) {
                        case "0.3" || "0.4":
                          setModalState(() {
                            margin = 20.0;
                          });
                          break;
                        case "0.5" || "0.6":
                          setModalState(() {
                            margin = 0.0;
                          });
                          break;
                        default:
                          setModalState(() {
                            margin = 0.0;
                          });
                      }

                      if (notification.extent == notification.minExtent) {
                        Navigator.pop(context);
                      }

                      return true;
                    },
                    child: DraggableScrollableSheet(
                      snap: true,
                      expand: false,
                      initialChildSize: 0.3,
                      maxChildSize: 0.7,
                      minChildSize: 0.3,
                      builder: (context, scroll) {
                        return modalwindow(controller: scroll, margin: margin);
                      },
                    ),
                  );
                },
              );
            },
          ).whenComplete(() {
            setState(() {
              margin = 20.0;
            });
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
