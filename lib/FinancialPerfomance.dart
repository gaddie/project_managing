import 'dart:math';

class ProjectBrain {
  ProjectBrain({required this.expense, required this.income});

  final int income;
  final int expense;

  int _performance = 0;

  int performance() {
    _performance = income - expense;

    if (_performance > 0) {
      return _performance;
    } else if (_performance < 0) {
      return _performance;
    } else {
      return 0;
    }
  }

  Object percentage() {
    if (expense == 0) {
      return '${100}';
    } else if (income == 0) {
      return '${-100}';
    } else {
      double percent = ((income - expense) / expense) * 100;
      if (percent > 0) {
        return '${percent.toStringAsFixed(1)}';
      } else if (percent < 0) {
        return '${percent.toStringAsFixed(1)}';
      } else {
        return '${0}';
      }
    }
  }
}
