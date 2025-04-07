import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';

class CardTask extends StatefulWidget {
  int i;
  var backgroundColor;
  var textColor;
  Map<String, dynamic> data;
  CardTask({
    super.key,
    required this.i,
    required this.backgroundColor,
    required this.textColor,
    required this.data,
  });

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  final List<String> _choicesItemTask = ["Удалить", "Выполнить"];

  bool isOpen = false;

  void Menu(int index, String chouse) {
    // if (chouse == "Удалить") {
    //   setState(() {
    //     Infos.removeAt(index);
    //   });
    // } else if (chouse == "Выполнить") {
    //   setState(() {
    //     Infos[index].setChanged = true;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
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
              Text(
                widget.data['goal'] ?? '',
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  overflow: TextOverflow.fade,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  borderRadius: BorderRadius.circular(360),
                  child: Ink(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.textColor,
                    ),
                    child: Icon(
                      !isOpen ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(width: 2, color: widget.textColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: widget.textColor,
                    size: 18,
                  ),
                  Text(
                    widget.data['time'] == ""
                        ? "неограничено"
                        : widget.data['time'],
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 20,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: widget.data['step'].length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Checkbox(
                          value: widget.data['step'][index]['value'],
                          activeColor: widget.textColor,
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(color: widget.textColor),
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              widget.data['step'][index]['value'] = value;
                              updateProcent();
                            });
                          },
                        ),
                        Text(
                          "${widget.data['step'][index]['name']}",
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
              PopupMenuButton(
                color: Colors.white,
                itemBuilder: (BuildContext context) {
                  return _choicesItemTask.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                      onTap: () {
                        Menu(widget.i, choice);
                      },
                    );
                  }).toList();
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Выполнено",
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${percentage.toInt()}",
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GFProgressBar(
            percentage: percentage / 100,
            animationDuration: 100,
            backgroundColor: Colors.white,
            progressBarColor: widget.textColor,
            lineHeight: 13,
            animation: true,
            animateFromLastPercentage: true,
          ),
        ],
      ),
    );
  }

  double percentage = 0;

  void updateProcent() {
    percentage = 0;
    double step = 100 / widget.data['step'].length;

    for (int i = 0; i < widget.data['step'].length; i++) {
      if (widget.data['step'][i]['value']) percentage += step;
    }

    print(percentage);
  }
}
