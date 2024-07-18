infoTask info = infoTask();

List<infoTask> Infos = [info];

class infoTask {
  String nameTask = "";
  String time = "";
  List<String> StepName = [];
  List<bool> isChanged = [];

  double proccent = 0;

  void set setName(String name) {
    nameTask = name;
  }

  void set setTime(String value) {
    time = value;
  }

  void set setNameStep(List<String> step) {
    StepName = step;

    for(int i = 0; i < StepName.length; i++){
      isChanged.add(false);
    }
  }
}
