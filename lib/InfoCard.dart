List<infoTask> Infos = [];

class infoTask {
  String nameTask = "";
  String time = "";
  List<String> StepName = [];
  List<bool> isChanged = [];

  double proccent = 0;

  double reverse = 90;
  bool isOpen = false;
  bool isReverse = false;

  double heigthGridView = 100;
  double heigthCart = 260;

  void set setReversed(bool isRevers) {
    isReverse = isRevers;
  }

  void set setHeigthGridView(double heigth) {
    heigthGridView = heigth;
  }

  void set setHeigthCart(double heigth) {
    heigthCart = heigth;
  }

  void set setReverse(double revers) {
    reverse = revers;
  }

  void set setOpen(bool opened) {
    isOpen = opened;
  }

  void set setName(String name) {
    nameTask = name;
  }

  void set setTime(String value) {
    time = value;
  }

  void set setNameStep(List<String> step) {
    StepName = step;

    for (int i = 0; i < StepName.length; i++) {
      isChanged.add(false);
    }
  }

  void set setChanged(bool chang) {
    for (int i = 0; i < isChanged.length; i++) {
      isChanged[i] = chang;
    }
  }
}
