import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class modalwindow extends StatefulWidget {
  final controller;
  final StateSetter setModalState;
  final margin;
  const modalwindow({
    super.key,
    required this.controller,
    required this.setModalState,
    required this.margin,
  });

  @override
  State<modalwindow> createState() => _modalwindowState();
}

class _modalwindowState extends State<modalwindow> {
  final TextEditingController controllerGoal = new TextEditingController();
  final List<TextEditingController> controllersStep = [];

  String _timeTask = '';

  void _showTimePicker(StateSetter setModalState) async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 24, minute: 0),
    );
    if (result != null) {
      setModalState(() {
        _timeTask = result.format(context);
      });
    }
  }

  Future saveDataCard() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String> stepData = [
      for (int i = 0; i < controllersStep.length; i++) controllersStep[i].text,
    ];

    final data = {
      'goal': controllerGoal.text,
      'time': _timeTask,
      'step': stepData,
    };
    _prefs.setString('infoCard', data.toString());

    print(_prefs.getString('infoCard'));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.only(
        left: widget.margin,
        right: widget.margin,
        bottom: widget.margin,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        controller: widget.controller,
        children: [
          Center(
            child: Container(
              height: 8,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          Text(
            "Новая задача",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Цель",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),

          SizedBox(height: 10),

          TextField(
            controller: controllerGoal,
            decoration: InputDecoration(
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          SizedBox(height: 15),

          Text(
            "Время",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),

          SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _showTimePicker(widget.setModalState);
                },
                child: Ink(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _timeTask.isEmpty ? "неограничено" : _timeTask,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Шаги",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
          ),

          Column(
            children: List.generate(
              controllersStep.length,
              (index) => Column(
                children: [
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${index + 1}.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: TextField(
                            controller: controllersStep[index],
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        flex: 9,
                      ),
                      //               Expanded(
                      //                 child: Container(
                      //                   child: PopupMenuButton(
                      //                     color: Colors.white,
                      //                     itemBuilder: (BuildContext context) {
                      //                       return _choicesItemModalWindow.map((
                      //                         String choice,
                      //                       ) {
                      //                         return PopupMenuItem<String>(
                      //                           value: choice,
                      //                           child: Text(choice),
                      //                           onTap: () {
                      //                             widget.setModalState(() {
                      // //                              _countStep -= 1;
                      //   //                            _controllers.removeAt(index);
                      //                             });
                      //                           },
                      //                         );
                      //                       }).toList();
                      //                     },
                      //                   ),
                      //                 ),
                      //               ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                widget.setModalState(() {
                  controllersStep.add(new TextEditingController());
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              child: Text(
                "Добавить",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                saveDataCard();
              },
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Text(
                  "Сохранить",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
