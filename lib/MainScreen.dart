import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:untitled/InfoCard.dart';

class MainActivity extends StatefulWidget {
  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  var _colors = [
    Colors.blue[200],
    Colors.red[200],
    Colors.green[200],
    Colors.pink[200],
    Colors.yellow[200]
  ];
  var _textcolors = [
    Color(0xFF1983FF),
    Color(0xFF561D1D),
    Color(0xFF1F5B37),
    Color(0xFF561D1D),
    Color(0xFF53331B),
  ];

  List<String> _choicesItemModalWindow = ["Удалить"];
  List<String> _choicesItemTask = ["Удалить", "Выполнить"];

  var scroll = ScrollController();

  var _controller = TextEditingController();
  int _countStep = 0;

  var _timeTask = "";

  var margin = 20.0;

  List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: AutoSizeText(
                      "Задачи",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                      textAlign: TextAlign.start,
                    ),
                  )),
              Expanded(
                child: Container(
                  height: 650,
                  width: MediaQuery.of(context).size.width,
                  child: ReorderableListView.builder(
                      itemBuilder: (context, i) => Task(i),
                      itemCount: Infos.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex = newIndex - 1;
                          }
                          final newcolor = _colors.removeAt(oldIndex);
                          final newtextcolor = _textcolors.removeAt(oldIndex);
                          final newInfo = Infos.removeAt(oldIndex);
                          _colors.insert(newIndex, newcolor);
                          _textcolors.insert(newIndex, newtextcolor);
                          Infos.insert(newIndex, newInfo);
                        });
                      }),
                ),
              ),
            ],
          ),
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
                    return NotificationListener<
                        DraggableScrollableNotification>(
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
                            return modalwindow(scroll, setModalState);
                          }),
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
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget modalwindow(controller, StateSetter setModalState) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: margin, right: margin, bottom: margin),
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: ListView(
        controller: controller,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 20),
              height: 8,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
            ),
          ),
          AutoSizeText(
            "Новая задача",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Цель",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300]),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Время",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          Text(
            _timeTask == "" ? "неограничено" : _timeTask,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                _showTimePicker(setModalState);
              },
              child: Text(
                "Выбрать",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
              ),
            ),
          ),
          Text(
            "Шаги",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          Column(
            children: List.generate(
                _countStep,
                (index) => Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${index += 1}.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[300]),
                                child: TextField(
                                  controller: _controllers[index -= 1],
                                  decoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              flex: 9,
                            ),
                            Expanded(
                              child: Container(
                                child: PopupMenuButton(
                                  color: Colors.white,
                                  itemBuilder: (BuildContext context) {
                                    return _choicesItemModalWindow
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                        onTap: () {
                                          setModalState(() {
                                            _countStep -= 1;
                                            _controllers.removeAt(index);
                                          });
                                        },
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                setModalState(() {
                  _controllers.add(new TextEditingController());
                  _countStep += 1;
                });
              },
              child: Text(
                "Добавить",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                _safeInfoWithModalWindow();
              },
              child: Text(
                "Сохранить",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Task(i) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        key: ValueKey(i),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        height: Infos[i].heigthCart,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: _colors[i],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Color(0x80000000),
                  blurRadius: 8.8)
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  Infos[i].nameTask,
                  style: TextStyle(
                      color: _textcolors[i],
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: _textcolors[i]),
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
                    ))
              ],
            ),
            SizedBox(
              height: 8,
            ),
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
                      color: _textcolors[i],
                      size: 18,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                    Text(
                      Infos[i].time == "" ? "неограничено" : Infos[i].time,
                      style: TextStyle(
                          color: _textcolors[i], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(width: 2, color: _textcolors[i])),
              ),
            ),
            SizedBox(
              height: 8,
            ),
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
                      children: List.generate(
                        Infos[i].StepName.length,
                        (index) {
                          if (Infos[i].StepName.length < 7) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Checkbox(
                                    value: Infos[i].isChanged[index],
                                    activeColor: _textcolors[i],
                                    side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                            width: 1.0, color: _textcolors[i])),
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
                                      style: TextStyle(
                                        color: _textcolors[i],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                )
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
                                      activeColor: _textcolors[i],
                                      side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(
                                              width: 1.0,
                                              color: _textcolors[i])),
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
                                        style: TextStyle(
                                          color: _textcolors[i],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  )
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
                                                  style: TextStyle(
                                                      color: _textcolors[i]),
                                                )))),
                                  ],
                                );
                              } else {
                                return SizedBox(
                                  height: 0,
                                );
                              }
                            }
                          }
                        },
                      ),
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
                  ))
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
                      color: _textcolors[i],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text("${(Infos[i].proccent * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: _textcolors[i],
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
            GFProgressBar(
              percentage: Infos[i].proccent,
              animationDuration: 100,
              backgroundColor: Colors.white,
              progressBarColor: _textcolors[i],
              lineHeight: 13,
              animation: true,
              animateFromLastPercentage: true,
            ),
          ],
        ));
  }

  void _showTimePicker(StateSetter setModalState) async {
    final TimeOfDay? result = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 24, minute: 0));
    if (result != null) {
      setModalState(() {
        _timeTask = result.format(context);
      });
    }
  }

  void _safeInfoWithModalWindow() {
    setState(() {
      Infos.add(new infoTask());
      Infos[Infos.length - 1].setName = _controller.text;

      Infos[Infos.length - 1].setTime = _timeTask;

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
    _timeTask = "";
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
