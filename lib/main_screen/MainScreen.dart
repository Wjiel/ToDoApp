import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:untitled/InfoCard.dart';

import '../colors.dart';
import 'Widgets/modalwindow.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _choicesItemModalWindow = ["Удалить"];
  final List<String> _choicesItemTask = ["Удалить", "Выполнить"];

  var scroll = ScrollController();

  final _controller = TextEditingController();
  int _countStep = 0;

  double margin = 20.0;

  final List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(
            "Задачи",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => Task(i),
            itemCount: Infos.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex = newIndex - 1;
                }
                final newcolor = colors.removeAt(oldIndex);
                final newtextcolor = textcolors.removeAt(oldIndex);
                final newInfo = Infos.removeAt(oldIndex);
                colors.insert(newIndex, newcolor);
                textcolors.insert(newIndex, newtextcolor);
                Infos.insert(newIndex, newInfo);
              });
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
                            margin = 20.0;
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
                        return modalwindow(
                          controller: scroll,
                          setModalState: setModalState,
                          margin: margin,
                        );
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

  Widget Task(i) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      key: ValueKey(i),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: colors[i],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: Color(0x80000000),
            blurRadius: 8.8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                Infos[i].nameTask,
                style: TextStyle(
                  color: textcolors[i],
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textcolors[i],
                ),
                child: InkWell(
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(Infos[i].reverse / 360),
                    child: AnimatedRotation(
                      turns: Infos[i].reverse,
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (Infos[i].StepName.length > 6) _openStep(i);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: textcolors[i],
                    size: 18,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                  Text(
                    Infos[i].time == "" ? "неограничено" : Infos[i].time,
                    style: TextStyle(
                      color: textcolors[i],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(width: 2, color: textcolors[i]),
              ),
            ),
          ),
          SizedBox(height: 8),
          AnimatedContainer(
            height: Infos[i].heigthGridView,
            duration: Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: GridView.count(
                    //  physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 2 / .3,
                    crossAxisCount: 2,
                    children: List.generate(Infos[i].StepName.length, (index) {
                      if (Infos[i].StepName.length < 7) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Checkbox(
                                value: Infos[i].isChanged[index],
                                activeColor: textcolors[i],
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    width: 1.0,
                                    color: textcolors[i],
                                  ),
                                ),
                                onChanged: (bool? value) {
                                  setState(() {
                                    Infos[i].isChanged[index] = value!;

                                    if (Infos[i].isChanged[index])
                                      Infos[i].proccent +=
                                          1 / Infos[i].isChanged.length;
                                    else
                                      Infos[i].proccent -=
                                          1 / Infos[i].isChanged.length;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(
                                  "${Infos[i].StepName[index]}",
                                  style: TextStyle(color: textcolors[i]),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        if (index <= 4 || Infos[i].isOpen == true) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Checkbox(
                                  value: Infos[i].isChanged[index],
                                  activeColor: textcolors[i],
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      width: 1.0,
                                      color: textcolors[i],
                                    ),
                                  ),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      Infos[i].isChanged[index] = value!;

                                      if (Infos[i].isChanged[index])
                                        Infos[i].proccent +=
                                            1 / Infos[i].isChanged.length;
                                      else
                                        Infos[i].proccent -=
                                            1 / Infos[i].isChanged.length;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Text(
                                    "${Infos[i].StepName[index]}",
                                    style: TextStyle(color: textcolors[i]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          if (index == 5) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _openStep(i);
                                        });
                                      },
                                      child: Text(
                                        "    Еще ${Infos[i].StepName.length - 5} шага...",
                                        style: TextStyle(color: textcolors[i]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox(height: 0);
                          }
                        }
                      }
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      color: Colors.white,
                      itemBuilder: (BuildContext context) {
                        return _choicesItemTask.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                            onTap: () {
                              Menu(i, choice);
                            },
                          );
                        }).toList();
                      },
                    ),
                    //     (
                    //   onTap: () {},
                    //   child: Icon(
                    //     Icons.more_vert,
                    //     size: 50,
                    //     color: _textcolors[i],
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Выполнено",
                  style: TextStyle(
                    color: textcolors[i],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${(Infos[i].proccent * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: textcolors[i],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // GFProgressBar(
          //   percentage: Infos[i].proccent,
          //   animationDuration: 100,
          //   backgroundColor: Colors.white,
          //   progressBarColor: textcolors[i],
          //   lineHeight: 13,
          //   animation: true,
          //   animateFromLastPercentage: true,
          // ),
        ],
      ),
    );
  }

  void _safeInfoWithModalWindow() {
    setState(() {
      Infos.add(new infoTask());
      Infos[Infos.length - 1].setName = _controller.text;

      //    Infos[Infos.length - 1].setTime = _timeTask;

      List<String> _stepName = [];

      for (int i = 0; i < _countStep; i++) {
        _stepName.add(_controllers[i].text);
      }

      Infos[Infos.length - 1].setNameStep = _stepName;
    });

    for (int i = 0; i < _countStep; i++) {
      _controllers[i].text = "";
    }
    _controller.text = "";
    //  _timeTask = "";
    _countStep = 0;

    Navigator.pop(context);
  }

  int extraStep = 0;

  void _openStep(int i) {
    Infos[i].setReversed = !Infos[i].isReverse;

    setState(() {
      if (Infos[i].isReverse) {
        Infos[i].setReverse = -90 / 360;

        Infos[i].setHeigthGridView = Infos[i].heigthGridView + getHeigth(i);
        Infos[i].setHeigthCart = Infos[i].heigthCart + getHeigth(i);
      } else {
        Infos[i].setReverse = 90 / 360;

        Infos[i].setHeigthGridView = Infos[i].heigthGridView - getHeigth(i);
        Infos[i].setHeigthCart = Infos[i].heigthCart - getHeigth(i);
      }

      Infos[i].setOpen = !Infos[i].isOpen;
    });
  }

  double getHeigth(int i) {
    return 23 * ((Infos[i].StepName.length - 5) / 2);
  }

  void Menu(int index, String chouse) {
    if (chouse == "Удалить") {
      setState(() {
        Infos.removeAt(index);
      });
    } else if (chouse == "Выполнить") {
      setState(() {
        Infos[index].setChanged = true;
      });
    }
  }
}
