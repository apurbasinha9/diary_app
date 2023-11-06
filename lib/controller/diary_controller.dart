import 'package:diary_app/model/diary_model.dart';
import 'package:hive/hive.dart';

class DiaryController {
  var box = Hive.box('diary_box');

  void addDiary(DiaryModel diary) {
    box.add(diary);
  }

  void deleteDiary(int index) {
    box.deleteAt(index);
  }

  List<DiaryModel> listDiaryEntries() {
    return box.values.cast<DiaryModel>().toList();
  }
}
