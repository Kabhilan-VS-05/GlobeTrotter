import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/budget_model.dart';

class BudgetState {
  final bool isLoading;
  final List<BudgetModel> budgets;
  final String? errorMessage;

  const BudgetState({
    this.isLoading = false,
    this.budgets = const [],
    this.errorMessage,
  });

  BudgetState copyWith({
    bool? isLoading,
    List<BudgetModel>? budgets,
    String? errorMessage,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get totalAllocated {
    return budgets.fold(0.0, (sum, budget) => sum + budget.allocatedAmount);
  }

  double get totalSpent {
    return budgets.fold(0.0, (sum, budget) => sum + budget.spentAmount);
  }

  double get totalRemaining => totalAllocated - totalSpent;

  double get overallUtilization {
    return totalAllocated > 0 ? (totalSpent / totalAllocated) * 100 : 0;
  }

  bool get isOverBudget => totalSpent > totalAllocated;

  List<BudgetModel> get overBudgetCategories {
    return budgets.where((budget) => budget.isOverBudget).toList();
  }

  List<BudgetModel> get nearLimitCategories {
    return budgets.where((budget) => budget.isNearLimit && !budget.isOverBudget).toList();
  }
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier() : super(const BudgetState());

  Future<void> loadBudgets(String tripId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Implement actual data fetching from Firebase/Repository
      // For now, using mock data
      final mockBudgets = <BudgetModel>[];
      
      state = state.copyWith(
        isLoading: false,
        budgets: mockBudgets,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createBudget(BudgetModel budget) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedBudgets = [...state.budgets, budget];
      
      state = state.copyWith(
        isLoading: false,
        budgets: updatedBudgets,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateBudget(BudgetModel budget) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedBudgets = state.budgets.map((b) => b.id == budget.id ? budget : b).toList();
      
      state = state.copyWith(
        isLoading: false,
        budgets: updatedBudgets,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedBudgets = state.budgets.where((b) => b.id != budgetId).toList();
      
      state = state.copyWith(
        isLoading: false,
        budgets: updatedBudgets,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateSpending(String budgetId, double amount) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedBudgets = state.budgets.map((budget) {
        if (budget.id == budgetId) {
          return budget.copyWith(spentAmount: budget.spentAmount + amount);
        }
        return budget;
      }).toList();
      
      state = state.copyWith(
        isLoading: false,
        budgets: updatedBudgets,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});
