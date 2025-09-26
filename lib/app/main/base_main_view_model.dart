import 'package:flutter/material.dart';
import '../../constants/enum/grade_enums.dart';
import '../../core/services/navigation_service.dart';

class BaseMainViewModel extends ChangeNotifier {
  StudentGrade? _selectedLevel;

  BaseMainViewModel() {
    _selectedLevel = null;
  }

  StudentGrade? get selectedLevel => _selectedLevel;

  void selectLevel(StudentGrade level) {
    _selectedLevel = level;
    notifyListeners();
  }

  bool get hasSelection => _selectedLevel != null;

  void startMission(BuildContext context) {
    if (_selectedLevel != null) {
      NavigationService().navigateToMission(context, _selectedLevel!.levelName);
    }
  }
}
